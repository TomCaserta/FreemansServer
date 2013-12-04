part of FreemansServer;

class Client {
  WebSocket s;
  bool loggedIn = false;
  JsonEncoder encoder = new JsonEncoder(null);
  Map<String, Completer> responsePacket = new Map<String, Completer>();
  Uuid u = new Uuid();
  WebsocketHandler wsh;
  User user = User.getUser("Guest","");
  Client (this.s, this.wsh);
  void send (String message) {
    s.add(message); 
  }
  void sendPacket (ServerPacket message) {
    s.add(encoder.convert(message)); 
  }

  /// Disconnect the client and remove them from the listener.
  void disconnect (String reason) {
    this.sendPacket(new DisconnectServerPacket(reason));
    wsh.removeClient(this);
    s.close();
  }
  
  void foundResponse (String respID, WebsocketHandler handler, ClientPacket packet) {
    if (responsePacket.containsKey(respID)) { 
      if (!responsePacket[respID].isCompleted) {
        responsePacket[respID].complete(packet);
        responsePacket.remove(respID);
      }
      else {
        print("Response had already timed out...");
      }
    }
  }
  
  Future<ClientPacket> sendGetResponse(ResponsePacket packet) {
    Completer c = new Completer();
    String id = u.v4();
    new Timer(new Duration(seconds: 5), () {
      c.completeError("Response timed out. $id");
      sendPacket(new ResponsePacketTimeoutServerPacket());
      disconnect("Client did not respond in time");
    });
    responsePacket[id] = c;
    return c.future;
  }
}