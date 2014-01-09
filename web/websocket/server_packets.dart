part of FreemansClient;

class PacketInstancer {
  Map<String, Type> positional = new Map<String, Type>();
  ClassMirror cm;
  PacketInstancer (ClassMirror this.cm) {
     Map<Symbol, DeclarationMirror> declarations = cm.declarations;
     if (declarations.containsKey(const Symbol("_create"))) {
       
     }
     else {
       ServerPacket.serverPacketLogger.severe("Cannot construct PacketInstancer as packet does not have _create method.");
     }
  }
  ServerPacket getPacket (Map params) {
    
  }
}

abstract class ServerPacket {
  static Logger serverPacketLogger = new Logger("ServerPacket");
  static int ID = 0;
  ServerPacket();
  ServerPacket._create();
  void handlePacket ();
  
  static Map<int, PacketInstancer> packets = new Map<int, PacketInstancer>();
  static Future<bool> init() {
    serverPacketLogger.info("Initializing");
    MirrorSystem ms = currentMirrorSystem();
    // Allows us to refactor the name of the class and not have to update the symbol name
    TypeMirror tm = reflectType(ServerPacket);
    Symbol thisSymbol = tm.simpleName;
    Symbol packetSym = const Symbol("ID");
    ms.libraries.forEach((Uri libUri, LibraryMirror libM) { 
      libM.declarations.forEach((Symbol declarationN, DeclarationMirror dm) { 
        if (dm is ClassMirror) { 
          ClassMirror superClass = dm.superclass;
           if (superClass != null)  {
             if (superClass.simpleName == thisSymbol) {
               InstanceMirror packetField;
               try {
                  packetField = dm.getField(packetSym);
               }
               catch (E) { }
               if (packetField != null) {
                 int packetID = packetField.reflectee;
                 if (!packets.containsKey(packetID)) {
                   packets[packetID] = new PacketInstancer(dm);
                 }
                 else {
                   serverPacketLogger.severe("Could not load packet ${dm.simpleName} as its ID conflicts");
                 }
               }
               else {
                 serverPacketLogger.severe("Could not load packet ${dm.simpleName} as it does not have a packet ID");
               }
             }
           }
        }
      });
    });
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
  DisconnectServerPacket (this.reason);
  void handlePacket () {
    
  }
}

class LoggedInServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.LOGGED_IN;
  Map user;
  LoggedInServerPacket(this.user);
  void handlePacket () {
    
  }

}

class DataChangeServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DATA_CHANGE;
  int userID = 0;
  String change = "";
  int type = 0;
  String identifier = "";
  DataChangeServerPacket (this.userID, this.change, this.type, this.identifier);
  void handlePacket () {
    
  }

}

class SupplierAddServerPacket extends ServerPacket {
  static int ID  = SERVER_PACKET_IDS.SUPPLIER_ADD;
  int supplierID = 0;
  String supplierName = "";
  SupplierAddServerPacket (this.supplierID, this.supplierName);
  void handlePacket () {
    
  }

}

class CustomerAddServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.CUSTOMER_ADD;
   int customerID = 0;
   String customerName = "";
   CustomerAddServerPacket(this.customerID, this.customerName);
   void handlePacket () {
     
   }

}

class TransportAddServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.TRANSPORT_ADD;
  int transportID = 0;
  String transportName = "";
  TransportAddServerPacket(this.transportID, this.transportName);
  void handlePacket () {
    
  }

}

class ActionResponseServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.ACTION_RESPONSE;
  bool completeSucessfully = false;
  List<String> errors = new List<String>();
  ActionResponseServerPacket (this.completeSucessfully, [this.errors]);
  void handlePacket () {
    
  }

}

class PingPongServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.PING_PONG;
  bool ping;
  PingPongServerPacket (this.ping);
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
  static const int TRANSPORT_ADD = 7;
  //8
  static const int ACTION_RESPONSE = 9;
  static const int PING_PONG = 10;
}
