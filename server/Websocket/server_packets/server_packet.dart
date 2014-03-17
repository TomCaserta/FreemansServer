part of FreemansServer;

abstract class ServerPacket {

  Map<String, dynamic> toJsonDefault(int ID) {
    return { "ID": ID };
  }
  Map<String, dynamic> toJson();
}

/// FOR SERVER RESPONSE REQUESTS. NOT CLIENT.
abstract class ResponsePacket extends ServerPacket {
  String rID = new uuid.Uuid().v4();
  Map<String, dynamic> toJsonDefault(int ID) {
    return super.toJsonDefault(ID)..addAll({ "rID": rID });
  }
}
class InitialDataResponseServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.INITIAL_DATA_RESPONSE;
  String rID = "";

  List accountList = new List<Account>();
  List customerList = new List<Customer>();
  List productList = new List<Product>();
  List productWeightsList = new List<ProductWeight>();
  List productPackagingList = new List<ProductPackaging>();
  List productDescriptorList = new List<ProductDescriptor>();
  List productCategoryList = new List<ProductCategory>();
  List transportList = new List<Transport>();
  List userList = new List<User>();
  List supplierList = new List<Supplier>();
  List termsList = new List<Terms>();
  List locationList = new List<Location>();
  List transportHaulageCostList = new List<TransportHaulageCost>();
  List optionsList = new List<Options>();
  
  InitialDataResponseServerPacket(
                                  this.rID,
                                  this.accountList,
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
                                  this.optionsList
                                 );
  
  Map toJson () {
    return super.toJsonDefault(ID)..addAll({  "rID": rID,
                                              "accountList": accountList,
                                              "customerList": customerList,
                                              "productList": productList,
                                              "productWeightsList": productWeightsList,
                                              "productPackagingList": productPackagingList,
                                              "productDescriptorList": productDescriptorList,
                                              "productCategoryList": productCategoryList,
                                              "transportList": transportList,
                                              "userList": userList,
                                              "supplierList": supplierList,
                                              "termsList": termsList,
                                              "locationList": locationList,
                                              "transportHaulageCostList": transportHaulageCostList,
                                              "optionsList": optionsList
                                            });
  }
}

class DisconnectServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DISCONNECT_SERVER;
  String reason;
  DisconnectServerPacket(this.reason);
  toJson () {
    return super.toJsonDefault(ID)..addAll({ "reason": reason });
  }
}

class LoggedInServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.LOGGED_IN;
  User user;
  String rID;
  LoggedInServerPacket(this.rID, this.user);
  toJson () {
    return super.toJsonDefault(ID)..addAll({ "user": user, "rID": rID });
  }
}

class DataChangeTypes {
  static const int PURCHASE = 0;
  static const int SALE = 1;
}

class DataChangeServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DATA_CHANGE;
  int userID = 0;
  String change = "";
  int type = 0;
  String identifier = "";
  bool isAdd = false;
  DataChangeServerPacket (this.userID, this.change, this.type, this.identifier, this.isAdd);
  toJson () {
    return super.toJsonDefault(ID)..addAll({ "uID": userID, "type": type, "identifier": identifier, "data": change, "isAdd": isAdd });
  }
}

class ActionResponseServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.ACTION_RESPONSE;
  bool completeSucessfully = false;
  List payload = new List();
  String rID = "";
  ActionResponseServerPacket (this.rID, this.completeSucessfully, [this.payload]);
  toJson () {
    return super.toJsonDefault(ID)..addAll({ "rID": rID, "complete": completeSucessfully, "payload": payload });
  }
}

class PingPongServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.PING_PONG;
  String rID = "";
  bool ping;
  PingPongServerPacket (this.rID, this.ping);
  toJson () {
    return toJsonDefault(ID)..addAll({ "rID": rID, "ping": ping });
  }
}

/*
class ResponsePacketTimeoutServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.RESPONSE_PACKET_TIMEOUT;
  ResponsePacketTimeoutServerPacket ();
  toJson () {
    return { "ID": ID };
  }
}
*/

class SetSessionServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.SET_SESSION;
  String sessionID;
  SetSessionServerPacket (this.sessionID);
  
  toJson () {
    return toJsonDefault(ID)..addAll({ "sessionID": sessionID });    
  }
}

class DeleteSessionServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DELETE_SESSION;
  DeleteSessionServerPacket ();
  
  toJson() {
    return toJsonDefault(ID);
  }
}

class SERVER_PACKET_IDS {
  //1 - REMOVED PACKET
  //2
  static const int INITIAL_DATA_RESPONSE = 2;
  static const int DISCONNECT_SERVER = 3;
  static const int LOGGED_IN = 4;
  static const int DATA_CHANGE = 5;
  static const int SUPPLIER_ADD = 6;
  static const int CUSTOMER_ADD = 7;
  static const int TRANSPORT_ADD = 8;
  static const int ACTION_RESPONSE = 9;
  static const int PING_PONG = 10;
  static const int SET_SESSION = 11;
  static const int DELETE_SESSION = 12;
}
