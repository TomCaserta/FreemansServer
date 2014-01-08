part of FreemansServer;


abstract class ClientPacket {
  
  static final int ID = 0;  
  
  /// If [loaded] is true then will contain all client packets that exist in the project
  static Map<int, ClassMirror> packets = new Map<int, ClassMirror>();
  
  /// Once the class has initialized will be set to true.
  static bool loaded = false;
  
  /// Initializes our packets map by filling it with all classes that extend ClientPacket
  static void initialize () {
    //  Get our current mirror system
    MirrorSystem ms = currentMirrorSystem();
    // Get the current isolate in the mirror system
    IsolateMirror im = ms.isolate;
    // Get the root library for the isolate
    LibraryMirror lm = im.rootLibrary;
    // Get the current classes in the root library
    Map<Symbol, DeclarationMirror> declorationmirrormap = lm.declarations;
    // Loop through all the classes searching for our packet ID
    declorationmirrormap.forEach((symbol, declarationMirror) { 
        if (declarationMirror is ClassMirror) {
          // Check the class has a super class (ie Packet)
          if (declarationMirror.superclass != null) {
            ClassMirror superClass = declarationMirror.superclass;
            // Check the name of the super class has the name we require
            if (superClass.simpleName == new Symbol("ClientPacket")) {
              // Get the ID of the packet from the class
              int ID = declarationMirror.getField(new Symbol("ID")).reflectee;
              // Insert all our packets into the packets map.
              packets[ID] = declarationMirror;
            }
          }
        }
    });
    loaded = true;
  }
  
  /// Constructs a client packet from just the ID and map data from the websocket
  static ClientPacket constructClientPacket (Client client, int ID, dynamic data) {
    // If we are not already loaded then we need to initialize our packets array
    if (loaded == false) initialize();
    
    // Check if our packet ID exists in the acceptable packets map.
    if (packets.containsKey(ID)) {
      // Compare our packet ID and do further validation to that 
      try {
       if (CLIENT_PACKET_IDS.AUTHENTICATE == ID) {
         // Create a new autentication packet. 
         var pkt = new AuthenticateClientPacket.create(data["crID"], data["username"], data["password"]);
         return pkt;
       }
       else if (CLIENT_PACKET_IDS.PING_PONG == ID) {
         var pkt = new PingPongClientPacket.create(data["crID"], data["ping"]);
         return pkt;
       }
       else {
         ClassMirror pck = packets[ID];
         // If its a generic packet:
         var pkt = pck.newInstance(new Symbol("create"), new List<dynamic>()).reflectee;
         pkt.client = client;
         return pkt;
       }
      }
      catch (e) {
        // TODO: PROPER ERROR HANDLING
        print("Some sort of error.");
      }
    }
    else {
      // TODO: PROPER ERROR HANDLING
      print("Unknown packet ID detected $ID");
    }
  }
  
  /// Packet
  void handlePacket (WebsocketHandler wsh, Client client) {
    
  }
}