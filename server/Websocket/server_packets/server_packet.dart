part of FreemansServer;

abstract class ServerPacket {

  Map<String, dynamic> toJsonDefault(int ID) {
    return { "ID": ID };
  }
  Map<String, dynamic> toJson();
}

/// FOR SERVER RESPONSE REQUESTS. NOT CLIENT.
abstract class ResponsePacket extends ServerPacket {
  String rID = new Uuid().v4();
  Map<String, dynamic> toJsonDefault(int ID) {
    return super.toJsonDefault(ID)..addAll({ "rID": rID });
  }
}
class InitialDataResponseServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.INITIAL_DATA_RESPONSE;
  String rID = "";
  List customerList = new List<Customer>();
  List productList = new List<Product>();
  List productWeightsList = new List<ProductWeight>();
  List productPackagingList = new List<ProductPackaging>();
  List transportList = new List<Transport>();
  List userList = new List<User>();
  InitialDataResponseServerPacket(this.rID, this.customerList, this.productList, this.productWeightsList, this.productPackagingList, this.transportList, this.userList);
  toJson () {
    return super.toJsonDefault(ID)..addAll({ "rID": rID, "customerList": customerList, "productList": productList, "productWeightsList": productWeightsList, "productPackagingList": productPackagingList, "transportList": transportList, "userList": userList });
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

class DataChangeServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DATA_CHANGE;
  int userID = 0;
  String change = "";
  int type = 0;
  String identifier = "";
  DataChangeServerPacket (this.userID, this.change, this.type, this.identifier);
  toJson () {
    return super.toJsonDefault(ID)..addAll({ "uID": userID, "type": type, "identifier": identifier, "data": change});
  }
}

class SupplierAddServerPacket extends ServerPacket {
  static int ID  = SERVER_PACKET_IDS.SUPPLIER_ADD;
  int supplierID = 0;
  String supplierName = "";
  SupplierAddServerPacket (this.supplierID, this.supplierName);
  toJson () {
    return super.toJsonDefault(ID)..addAll({ "supplierID": supplierID, "supplierName": supplierName });
  }
}

class CustomerAddServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.CUSTOMER_ADD;
   int customerID = 0;
   String customerName = "";
   CustomerAddServerPacket(this.customerID, this.customerName);
   toJson () {
     return super.toJsonDefault(ID)..addAll({ "customerID": customerID, "customerName": customerName });
   }
}

class TransportAddServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.TRANSPORT_ADD;
  int transportID = 0;
  String transportName = "";
  TransportAddServerPacket(this.transportID, this.transportName);
  toJson () {
    return super.toJsonDefault(ID)..addAll({ "transportID": transportID, "transportName": transportName });
  }
}

class ActionResponseServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.ACTION_RESPONSE;
  bool completeSucessfully = false;
  List<String> errors = new List<String>();
  String rID = "";
  ActionResponseServerPacket (this.rID, this.completeSucessfully, [this.errors]);
  toJson () {
    return super.toJsonDefault(ID)..addAll({ "rID": rID, "complete": completeSucessfully, "errors": errors });
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
}
