part of WebsocketHandler;

/// TODO: Work out a better way of doing this.
String getSymName (Symbol sym) {
  String str = sym.toString();
  return str.substring(8, str.length - 2);
}

class PacketInstancer {
  Map<String, String> positional = new Map<String, String>();
  Map<String, String> optional = new Map<String, String>();
  Map<String, String> named = new Map<String, String>();
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
            String typeName = getSymName (paramType.simpleName);
            if (typeName == "String" || typeName == "num" || typeName == "int" || typeName == "bool" || typeName == "double" || typeName == "List" || typeName == "Map") {
              if (parameter.isNamed) {
                 named[getSymName (parameter.simpleName)] = typeName;
              }
              else if (parameter.isOptional) {
                 optional[getSymName (parameter.simpleName)] = typeName;
              }
              else {
                positional[getSymName(parameter.simpleName)] = typeName;
              }
            }
            else {
              ServerPacket.serverPacketLogger.severe("Cannot construct PacketInstancer as packet uses a unsuported type: $typeName");
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
    positional.forEach((String parameterName, String paramType) { 
      if (params.containsKey(parameterName)) {
        dynamic obj = params[parameterName];
        if (compareTypes(obj, paramType)) {
          posArguments.add(obj);
        }
      }
    });
    Map<Symbol, dynamic> namedParams = new Map<Symbol, dynamic>();
    named.forEach((String parameterName, String paramType) { 
      if (params.containsKey(parameterName)) {
        dynamic obj = params[parameterName];
                
        if (compareTypes(obj, paramType)) {
          namedParams[new Symbol(parameterName)] = obj;
        }
        else {
          ServerPacket.serverPacketLogger.info("Dropping parameter $parameterName as it doesnt match type == $paramType");
        }
      }
      else {
        ServerPacket.serverPacketLogger.info("Dropping parameter $parameterName");
      }
    });
    if (posArguments.length == positional.length) {
      
      return cm.newInstance(const Symbol("create"), posArguments, namedParams).reflectee;
    }
    else {
      ServerPacket.serverPacketLogger.warning("Incorrect parameters found");
    }
    ServerPacket.serverPacketLogger.warning("Unidentified error?");
    return null;
  }
}

bool compareTypes (dynamic obj, String type) {
///TODO: PROPER REFLECTION AND NOT HARD CODED.
  String t = obj.runtimeType.toString();
  if (t == "_LinkedHashMap") { 
    t = "Map";
  }
  else if (t == "_GrowableList") {
    t = "List";
  }
  return t == type; 
}

abstract class ServerPacket {
  static Logger serverPacketLogger = new Logger("ServerPacket");
  static int ID = 0;
  ServerPacket();
  ServerPacket.create();
  void handlePacket (WebsocketHandler ws);
  
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
      serverPacketLogger.info("Fetched packet");
      return packets[packetID].getPacket(props);
    }
    else {
      serverPacketLogger.warning("Unknown packet ID $packetID received by getPacket");
    }
  }
}

class InitialDataResponseServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.INITIAL_DATA_RESPONSE;
  
  List accountList = new List();
  List customerList = new List();
  List productList = new List();
  List productWeightsList = new List();
  List productPackagingList = new List();
  List productDescriptorList = new List();
  List productCategoryList = new List();
  List transportList = new List();
  List userList = new List();
  List supplierList = new List();
  List termsList = new List();
  List locationList = new List();
  List transportHaulageCostList = new List();
  List optionsList = new List();
  
  InitialDataResponseServerPacket.create(this.accountList,
                                         this.customerList,
                                         this.productList,
                                         this.productWeightsList,
                                         this.productPackagingList,
                                         this.productDescriptorList,
                                         this.productCategoryList,
                                         this.transportList,
                                         this.userList,
                                         this.supplierList,
                                         this.termsList,
                                         this.locationList,
                                         this.transportHaulageCostList,
                                         this.optionsList);
  void handlePacket (WebsocketHandler wsh) {
    
  }
}

class DisconnectServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DISCONNECT_SERVER;
  String reason;
  DisconnectServerPacket.create (this.reason);
  void handlePacket (WebsocketHandler ws) {
    
  }
}

class LoggedInServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.LOGGED_IN;
  Map user;
  LoggedInServerPacket.create (this.user);
  void handlePacket (WebsocketHandler wsh) { 
    ServerPacket.serverPacketLogger.info("Received login information from server... Overriding login");
    wsh.ss.handleLogin(this);      
  }
}

class DataChangeServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DATA_CHANGE;
  int userID = 0;
  bool isAdd = false;
  List payload = [];
  DataChangeServerPacket.create (this.userID, this.payload, this.isAdd);
  void handlePacket (WebsocketHandler ws) {
    
  }

}


class ActionResponseServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.ACTION_RESPONSE;
  bool complete = false;
  List payload = new List();
  ActionResponseServerPacket.create (this.complete, {this.payload});
  void handlePacket (WebsocketHandler ws) {
    
  }

}

class PingPongServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.PING_PONG;
  bool ping;
  PingPongServerPacket.create (this.ping);
  void handlePacket (WebsocketHandler ws) {
    
  }

}

//{ID: 11, sessionID: 00089770-7366-4df5-bdef-529a6ba32534}
class SetSessionServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.SET_SESSION;
  String sessionID;
  SetSessionServerPacket.create (this.sessionID);
  void handlePacket (WebsocketHandler ws) {
    window.localStorage["FFPSESSID"] = sessionID;
  }
}

class DeleteSessionServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DELETE_SESSION;
  DeleteSessionServerPacket.create ();
  void handlePacket (WebsocketHandler ws) {
    window.localStorage.remove("FFPSESSID");
  }
}

class SERVER_PACKET_IDS {
  //1 - REMOVED PACKET
  //2

  static const int INITIAL_DATA_RESPONSE = 2;
  static const int DISCONNECT_SERVER = 3;
  static const int LOGGED_IN = 4;
  static const int DATA_CHANGE = 5;
  static const int ACTION_RESPONSE = 9;
  static const int PING_PONG = 10;
  static const int SET_SESSION = 11;
  static const int DELETE_SESSION = 12;
}
