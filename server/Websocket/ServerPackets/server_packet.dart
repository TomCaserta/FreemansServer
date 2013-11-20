part of FreemansServer;

abstract class ServerPacket {
   static int ID;
   toJson();
}
abstract class ResponsePacket extends ServerPacket {
  
}


class UserPassIncorrectServerPacket extends ResponsePacket {
  static int ID = SERVER_PACKET_IDS.USER_PASS_INCORRECT_ID;
  String RID;
  UserPassIncorrectServerPacket (this.RID);
  
  toJson () {
    return { "ID": ID, "RID": RID };
  }
}


class DisconnectServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DISCONNECT_SERVER;
  
  String reason;
  DisconnectServerPacket(this.reason);
  toJson () {
    return { "ID": ID, "reason": reason };
  }
}

class LoggedInServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.LOGGED_IN;
  LoggedInServerPacket();
  //TODO: Send connection and negotiate information
  toJson () {
    return { "ID": ID };
  }
}

class DataChangeServerPacket {
  static int ID = SERVER_PACKET_IDS.DATA_CHANGE;
  int userID = 0;
  String change = "";
  int type = 0;
  String identifier = "";
  DataChangeServerPacket (this.userID, this.change, this.type, this.identifier);
  toJson () {
    return {"ID": ID, "uID": userID, "type": type, "identifier": identifier, "data": change};
  }
}

class SupplierAddServerPacket {
  static int ID  = SERVER_PACKET_IDS.SUPPLIER_ADD;
  int supplierID = 0;
  String supplierName = "";
  SupplierAddServerPacket (this.supplierID, this.supplierName);
  toJson () {
    return {"ID": ID, "supplierID": supplierID, "supplierName": supplierName };
  }
}

class CustomerAddServerPacket {
  static int ID = SERVER_PACKET_IDS.CUSTOMER_ADD;
   int customerID = 0;
   String customerName = "";
   CustomerAddServerPacket(this.customerID, this.customerName);
   toJson () {
     return {"ID": ID, "customerID": customerID, "customerName": customerName };
   }
   
}

class TransportAddServerPacket {
  static int ID = SERVER_PACKET_IDS.TRANSPORT_ADD;
  int transportID = 0;
  String transportName = "";
  TransportAddServerPacket(this.transportID, this.transportName);
  toJson () {
    return {"ID": ID, "transportID": transportID, "transportName": transportName };
  }
}


class SERVER_PACKET_IDS {
  static const int USER_PASS_INCORRECT_ID = 1;
  static const int RESPONSE_PACKET_TIMEOUT = 2;
  static const int DISCONNECT_SERVER = 3;
  static const int LOGGED_IN = 4;
  static const int DATA_CHANGE = 5;
  static const int SUPPLIER_ADD = 6;
  static const int CUSTOMER_ADD = 7;
  static const int TRANSPORT_ADD = 7;
}
