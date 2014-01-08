part of FreemansClient;

abstract class ServerPacket {
  static Logger serverPacketLogger = new Logger("ServerPacket");
  static int ID = 0;
  ServerPacket();
  ServerPacket._create();
  void handlePacket ();
  
  static Map<int, ClassMirror> packets = new Map<int, ClassMirror>();
  static Future<bool> init() {
    serverPacketLogger.info("Initializing");
    MirrorSystem ms = currentMirrorSystem();
    // Allows us to refactor the name of the class and not have to update the symbol name
    Type s = ServerPacket;
    Symbol thisSymbol = new Symbol(s.toString());
    Symbol packetSym = new Symbol("ID");
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
                   packets[packetID] = dm;
                 }
                 else {
                   serverPacketLogger.severe("Could not load packet ${dm.simpleName} as its ID conflicts with ${packets[packetID].simpleName}");
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
  
  static ServerPacket getPacket (int packetID) {
    if (packets.containsKey(packetID)) {
      return packets[packetID].newInstance(new Symbol("_create"), []).reflectee;
    }
    else {
      serverPacketLogger.warning("Unknown packet ID $packetID received by getPacket");
    }
  }
}

class DataPacket extends ServerPacket {
  static int ID = 0;
  DataPacket._create() {
    
  }
  void handlePacket () {
    
  }
}