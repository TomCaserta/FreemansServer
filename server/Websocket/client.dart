part of FreemansServer;

class Client {
  WebSocket _websocket;
  bool loggedIn = false;
  JsonEncoder encoder = new JsonEncoder(null);
  Map<String, Completer> responsePacket = new Map<String, Completer>();
  uuid.Uuid _Uuid = new uuid.Uuid();
  
  /// NEVER EXPOSE TO CLIENTS - IT IS ESSENTIALLY THE SESSION KEY
  String _uniqueID;
  WebsocketHandler wsh;
  HttpRequest _req;
  User user = User.getUser("Guest","");
  Client (this._websocket, this.wsh, this._req) {
    _uniqueID = _Uuid.v4();
  }
  void send (String message) {
    _websocket.add(message);
  }
  void sendPacket (ServerPacket message) {
    print(message.toJson());
    _websocket.add(encoder.convert(message));
  }

  /// Disconnect the client and remove them from the listener.
  void disconnect (String reason) {
    this.sendPacket(new DisconnectServerPacket(reason));
    wsh.removeClient(this);
    _websocket.close();
  }
  
  bool isResponse (String respID) {
     return responsePacket.containsKey(respID);
  }
  
  void foundResponse (String respID, WebsocketHandler handler, ClientPacket packet) {
    if (responsePacket.containsKey(respID)) { 
      if (!responsePacket[respID].isCompleted) {
        responsePacket[respID].complete(packet);
        responsePacket.remove(respID);
      }
      else {
        ffpServerLog.warning("Response had already timed out...");
      }
    }
  }
  
  void onMessage(message) {
   try { 
     // Parse the sent message into JSON
     dynamic obj = JSON.decode(message);
     ffpServerLog.info(message);
     if (obj is Map) {
       if (obj.containsKey("ID") && obj["ID"] is int) {
         // Construct our client packet
         ClientPacket c = ClientPacket.getPacket(obj["ID"], obj);
         // Send the client and websocket handler to the packet and ask it to handle the packet.
         if (c != null) {
           if (obj.containsKey("rID") && obj["rID"] is String) {
             String rID = obj["rID"];
             if (this.isResponse(rID)) {
               this.foundResponse(obj["rID"], wsh, c);
             }
             else c.handlePacket(wsh, this);
           }
           else c.handlePacket(wsh, this);
         }
       }
     }
   }
   catch (e) {
     ffpServerLog.warning("Error when parsing packet $e");
   }
 }
  
  Timer destroyer;
  void destroyClient (Duration duration, onDestroyClient onDestroyClient) {
    cancelDestroy();
    destroyer = new Timer(duration, () { 
      onDestroyClient(this);
    });
  }
  void cancelDestroy () {
    if (destroyer != null) {
      if (destroyer.isActive) {
        destroyer.cancel();
      }
    }
  }
  

  void mergeWith(updated, [bool forceMerge = false]) {
    if (this.runtimeType == updated.runtimeType || forceMerge) {
      InstanceMirror origIM = reflect(this);
      InstanceMirror updatedIM = reflect(updated);
      ClassMirror origCM = reflectClass(this.runtimeType);
      _merge(origCM, origIM, updatedIM);
    } else throw new Exception("Cannot merge two objects of different types. To override set forceMerge to true");
  }

  void _merge(ClassMirror fromClass, InstanceMirror original, InstanceMirror newValues) {
    fromClass.declarations.forEach((Symbol s, DeclarationMirror dm) {
      if (dm is VariableMirror && dm.isPrivate == false) {
        dynamic val = newValues.getField(s).reflectee;
        if (val != null) {
          original.setField(s, val);
        }
      }
    });
    if (fromClass.superclass != null) {
      _merge(fromClass.superclass, original, newValues);
    }
  }

  
  Future<ClientPacket> sendGetResponse(ResponsePacket packet) {
    Completer c = new Completer();
    String id = _Uuid.v4();
    new Timer(new Duration(seconds: 5), () {
      c.completeError("Response timed out. $id");
      disconnect("Client did not respond in time");
    });
    responsePacket[id] = c;
    return c.future;
  }
}

typedef void onDestroyClient (Client cli);