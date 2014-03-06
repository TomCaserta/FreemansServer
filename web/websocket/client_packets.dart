part of WebsocketHandler;



abstract class ClientPacket {
  Map<String, dynamic> toJsonDefault(int ID) {
    return { "ID": ID };
  }
  Map<String, dynamic> toJson();
}

abstract class RequireResponseClientPacket extends ClientPacket {
  String rID = new Uuid().v4();
  Map<String, dynamic> toJsonDefault(int ID) {
    return super.toJsonDefault(ID)..addAll({ "rID": this.rID });
  }
}

class AuthenticateClientPacket extends RequireResponseClientPacket {
  static final int ID = CLIENT_PACKET_IDS.AUTHENTICATE;
  String username;
  String password;
  AuthenticateClientPacket(this.username, this.password);
  
  Map<String, dynamic>  toJson () {
    return super.toJsonDefault(ID)..addAll({ "username": this.username, "password": this.password });
  }
}
class InitialDataRequestClientPacket extends RequireResponseClientPacket {
  static final int ID = CLIENT_PACKET_IDS.INITIAL_DATA_REQUEST;
  InitialDataRequestClientPacket();
  
  Map<String, dynamic>  toJson () {
    return super.toJsonDefault(ID);
  }
}

class PingPongClientPacket extends RequireResponseClientPacket {
  static final int ID = CLIENT_PACKET_IDS.PING_PONG;
  bool ping;
  PingPongClientPacket (this.ping);
  
  Map<String, dynamic> toJson () {
    return super.toJsonDefault(ID)..addAll({ "ping": this.ping });
  }
}

class DataChangeClientPacket extends RequireResponseClientPacket {
  static final int ID = CLIENT_PACKET_IDS.DATA_CHANGE;
  String change = "";
  int type = 0;
  String identifier = "";
  DataChangeClientPacket (this.change, this.type, this.identifier);
  
  Map<String, dynamic>  toJson () {
    return super.toJsonDefault(ID)..addAll({ "identifier": this.identifier, "type": this.type, "change": this.change });
  }
}



class SyncableModifyClientPacket extends RequireResponseClientPacket {
  static int ID = CLIENT_PACKET_IDS.SYNCABLE_MODIFY;

  bool add;
  int type;
  Map payload;
  
  SyncableModifyClientPacket (this.add, this.type, this.payload);  
  Map<String, dynamic>  toJson () {
    return super.toJsonDefault(ID)..addAll({ "add": add, "type": type, "payload": payload });
  }

}

class SyncableTypes {
  static const int CUSTOMER = 1;
  static const int SUPPLIER = 2;
  static const int PRODUCT_WEIGHT = 3;
  static const int PRODUCT_PACKAGING = 4;
  static const int PRODUCT_CATEGORY = 5;
  static const int PRODUCT = 6;
  static const int TRANSPORT = 7;
  static const int USER = 8;
  static const int TERMS = 9;
  static const int LOCATION = 10;
  static const int TRANSPORT_HAULAGE_COST = 11;
}

class CLIENT_PACKET_IDS {
  static const int AUTHENTICATE = 1;
  static const int PING_PONG = 2;
  static const int INITIAL_DATA_REQUEST = 3;
  static const int SYNCABLE_MODIFY = 4;
  static const int DATA_CHANGE = 5;
}