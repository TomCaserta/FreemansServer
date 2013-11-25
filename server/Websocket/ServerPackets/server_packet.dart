part of FreemansServer;

abstract class ServerPacket {
   static int ID;
   toJson();
}
abstract class ResponsePacket extends ServerPacket {
  
}


class UserPassIncorrectServerPacket extends ResponsePacket {
  static int ID = SERVER_PACKET_IDS.USER_PASS_INCORRECT_ID;
  String responseID;
  UserPassIncorrectServerPacket (this.responseID);
  
  toJson () {
    return { "ID": ID, "rID": responseID };
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

class DataChangeServerPacket extends ServerPacket {
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

class SupplierAddServerPacket extends ServerPacket {
  static int ID  = SERVER_PACKET_IDS.SUPPLIER_ADD;
  int supplierID = 0;
  String supplierName = "";
  SupplierAddServerPacket (this.supplierID, this.supplierName);
  toJson () {
    return {"ID": ID, "supplierID": supplierID, "supplierName": supplierName };
  }
}

class CustomerAddServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.CUSTOMER_ADD;
   int customerID = 0;
   String customerName = "";
   CustomerAddServerPacket(this.customerID, this.customerName);
   toJson () {
     return {"ID": ID, "customerID": customerID, "customerName": customerName };
   }
   
}

class TransportAddServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.TRANSPORT_ADD;
  int transportID = 0;
  String transportName = "";
  TransportAddServerPacket(this.transportID, this.transportName);
  toJson () {
    return {"ID": ID, "transportID": transportID, "transportName": transportName };
  }
}

class FileResponseServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.FILE_RESPONSE;
  
  String base64Data = "";
  String fileName = "";
  String responseID = "";
  FileResponseServerPacket (this.fileName, this.base64Data, this.responseID) {
    
  }
  static Future<FileResponseServerPacket> load (String fileName, String responseID) {
    Completer c = new Completer();
    File f = new File(fileName);
    f.exists().then((bool exist) { 
      if (exist) {
        f.readAsBytes().then((d) { 
          c.complete(new FileResponseServerPacket(fileName, CryptoUtils.bytesToBase64(d), responseID));         
        }).catchError((e) { 
          c.completeError(e);          
        });
      }
      else {
       c.completeError("File does not exist");
      }
    });
  }
  toJson () {
    return {"ID": ID, "rID": responseID, "data": base64Data, "filename": fileName };
  }
}

class ActionResponseServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.ACTION_RESPONSE;
  bool completeSucessfully = false;
  String responseID = "";
  ActionResponseServerPacket (this.completeSucessfully, this.responseID);
  toJson () {
    return {"ID": ID, "rID": responseID, "complete": completeSucessfully };
  }
}

class PingPongServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.PING_PONG;
  String responseID = "";
  bool ping;
  PingPongServerPacket (this.responseID, this.ping);
  toJson () {
    return { "ID": ID, "rID": responseID, "ping": ping };
  }
}

class ResponsePacketTimeoutServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.RESPONSE_PACKET_TIMEOUT;
  ResponsePacketTimeoutServerPacket ();
  toJson () {
    return { "ID": ID };
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
  static const int FILE_RESPONSE = 8;
  static const int ACTION_RESPONSE = 9;
  static const int PING_PONG = 10;
}
