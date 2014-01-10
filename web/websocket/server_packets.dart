part of FreemansClient;

/// TODO: Work out a better way of doing this.
String getSymName (Symbol sym) {
  String str = sym.toString();
  return str.substring(8, str.length - 2);
}

class PacketInstancer {
  Map<String, Symbol> positional = new Map<String, Symbol>();
  Map<String, Symbol> optional = new Map<String, Symbol>();
  Map<String, Symbol> named = new Map<String, Symbol>();
  ClassMirror cm;
  PacketInstancer (ClassMirror this.cm) {
     Map<Symbol, DeclarationMirror> declarations = cm.declarations;
     Symbol createMethod = new Symbol("${getSymName(cm.simpleName)}.create");
     if (declarations.containsKey(createMethod)) {
       DeclarationMirror dm = declarations[createMethod];
       if (dm is MethodMirror && dm.isConstructor) {
          List<ParameterMirror> pm = dm.parameters;
          pm.forEach((ParameterMirror parameter)  {
            TypeMirror paramType = parameter.type;
            if (parameter.isNamed) {
               named[getSymName (parameter.simpleName)] = paramType.simpleName;
            }
            else if (parameter.isOptional) {
               optional[getSymName (parameter.simpleName)] = paramType.simpleName;
            }
            else {
              positional[getSymName(parameter.simpleName)] = paramType.simpleName;
            }
          });
       }
       else {
         ServerPacket.serverPacketLogger.severe("Cannot construct PacketInstancer as packets create declaration is not a constructor");
       }
     }
     else {
       ServerPacket.serverPacketLogger.severe("Cannot construct PacketInstancer as packet does not have create method.");
     }
  }
  ServerPacket getPacket (Map params) {
    List<dynamic> posArguments = new List<dynamic>();
    positional.forEach((String parameterName, Symbol paramType) { 
      if (params.containsKey(parameterName)) {
        dynamic obj = params[parameterName];
        TypeMirror im = reflectType(obj.runtimeType);
        if (im.simpleName == paramType) {
          posArguments.add(obj);
        }
      }
    });
    Map<Symbol, dynamic> namedParams = new Map<Symbol, dynamic>();
    named.forEach((String parameterName, Symbol paramType) { 
      if (params.containsKey(parameterName)) {
        dynamic obj = params[parameterName];
        TypeMirror im = reflectType(obj.runtimeType);
        if (im.simpleName == paramType) {
          namedParams[new Symbol(parameterName)] = obj;
        }
      }
    });
    if (posArguments.length == positional.length) {
      return cm.newInstance(const Symbol("create"), posArguments, namedParams).reflectee;
    }
    else {
      ServerPacket.serverPacketLogger.warning("Incorrect parameters found.");
    }
  }
}

abstract class ServerPacket {
  static Logger serverPacketLogger = new Logger("ServerPacket");
  static int ID = 0;
  ServerPacket();
  ServerPacket.create();
  void handlePacket ();
  
  static Map<int, PacketInstancer> packets = new Map<int, PacketInstancer>();
  static bool init() {
    serverPacketLogger.info("Initializing");
    MirrorSystem ms = currentMirrorSystem();
    // Allows us to refactor the name of the class and not have to update the symbol name
    TypeMirror tm = reflectType(ServerPacket);
    Symbol thisSymbol = tm.simpleName;
    Symbol packetSym = const Symbol("ID");
    //ms.libraries.keys
    int keyN = ms.libraries.keys.length;
    for (var x = 0; x < keyN; x++) {
      Uri libUri = ms.libraries.keys.elementAt(x);
      LibraryMirror libM = ms.libraries[libUri];

      int keyL = libM.declarations.keys.length;
      for (var i = 0; i < keyL; i++) {
       Symbol declarationN = libM.declarations.keys.elementAt(i);
       DeclarationMirror dm = libM.declarations[declarationN];
        if (dm is ClassMirror) { 
          ClassMirror superClass = dm.superclass;
           if (superClass != null)  {
             if (superClass.simpleName == thisSymbol) {
               InstanceMirror packetField;
               try {
                  packetField = dm.getField(packetSym);
                 if (packetField != null) {
                   int packetID = packetField.reflectee;
                   if (!packets.containsKey(packetID)) {
                     packets[packetID] = new PacketInstancer(dm);
                   }
                   else {
                     serverPacketLogger.severe("Could not load packet ${dm.simpleName} as its ID conflicts");
                     return false;
                   }
                 }
                 else {
                   serverPacketLogger.severe("Could not load packet ${dm.simpleName} as it does not have a packet ID");
                   return false;
                 }
               }
               catch (E) { }
             }
           }
        }
      }
    }
    return true;
  }
  
  static ServerPacket getPacket (int packetID, Map props) {
    if (packets.containsKey(packetID)) {
      return packets[packetID].getPacket(props);
    }
    else {
      serverPacketLogger.warning("Unknown packet ID $packetID received by getPacket");
    }
  }
}

class DisconnectServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DISCONNECT_SERVER;
  String reason;
  DisconnectServerPacket.create (this.reason);
  void handlePacket () {
    
  }
}

class LoggedInServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.LOGGED_IN;
  Map user;
  LoggedInServerPacket.create (this.user);
  void handlePacket () {
    
  }

}

class DataChangeServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DATA_CHANGE;
  int userID = 0;
  String change = "";
  int type = 0;
  String identifier = "";
  DataChangeServerPacket.create (this.userID, this.change, this.type, this.identifier);
  void handlePacket () {
    
  }

}

class SupplierAddServerPacket extends ServerPacket {
  static int ID  = SERVER_PACKET_IDS.SUPPLIER_ADD;
  int supplierID = 0;
  String supplierName = "";
  SupplierAddServerPacket.create (this.supplierID, this.supplierName);
  void handlePacket () {
    
  }

}

class CustomerAddServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.CUSTOMER_ADD;
   int customerID = 0;
   String customerName = "";
   CustomerAddServerPacket.create (this.customerID, this.customerName);
   void handlePacket () {
     
   }

}

class TransportAddServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.TRANSPORT_ADD;
  int transportID = 0;
  String transportName = "";
  TransportAddServerPacket.create (this.transportID, this.transportName);
  void handlePacket () {
    
  }

}

class ActionResponseServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.ACTION_RESPONSE;
  bool completeSucessfully = false;
  List<String> errors = new List<String>();
  ActionResponseServerPacket.create (this.completeSucessfully, [this.errors]);
  void handlePacket () {
    
  }

}

class PingPongServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.PING_PONG;
  bool ping;
  PingPongServerPacket.create (this.ping);
  void handlePacket () {
    
  }

}

class SERVER_PACKET_IDS {
  //1 - REMOVED PACKET
  //2
  static const int DISCONNECT_SERVER = 3;
  static const int LOGGED_IN = 4;
  static const int DATA_CHANGE = 5;
  static const int SUPPLIER_ADD = 6;
  static const int CUSTOMER_ADD = 7;
  static const int TRANSPORT_ADD = 8;
  static const int ACTION_RESPONSE = 9;
  static const int PING_PONG = 10;
}
