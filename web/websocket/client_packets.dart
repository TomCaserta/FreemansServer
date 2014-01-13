part of FreemansClient;



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

class DataChangeClientPacket extends ClientPacket {
  static final int ID = CLIENT_PACKET_IDS.DATA_CHANGE;
  String change = "";
  int type = 0;
  String identifier = "";
  DataChangeClientPacket (this.change, this.type, this.identifier);
  
  Map<String, dynamic>  toJson () {
    return super.toJsonDefault(ID)..addAll({ "identifier": this.identifier, "type": this.type, "change": this.change });
  }
}

class SupplierAddClientPacket extends RequireResponseClientPacket {
  static final int ID = CLIENT_PACKET_IDS.SUPPLIER_ADD;
  String supplierName = "";
  SupplierAddClientPacket (this.supplierName);
  Map<String, dynamic>  toJson () {
    return super.toJsonDefault(ID)..addAll({ "supplierName": this.supplierName });
  }
}

class CustomerAddClientPacket extends RequireResponseClientPacket {
  static final int ID = CLIENT_PACKET_IDS.CUSTOMER_ADD;
  String customerName = "";
  CustomerAddClientPacket (this.customerName);
  Map<String, dynamic>  toJson () {
    return super.toJsonDefault(ID)..addAll({ "customerName": this.customerName });
  }
}


class TransportAddClientPacket extends RequireResponseClientPacket {
  static final int ID = CLIENT_PACKET_IDS.TRANSPORT_ADD;
  String transportName = "";
  TransportAddClientPacket (this.transportName);   
  Map<String, dynamic>  toJson () {
    return super.toJsonDefault(ID)..addAll({ "transportName": this.transportName });
  }
}


class CLIENT_PACKET_IDS {
  static const int AUTHENTICATE = 1;
  static const int PING_PONG = 2;
  static const int INITIAL_DATA_REQUEST = 3;
  
  static const int DATA_CHANGE = 5;
  static const int SUPPLIER_ADD = 6;
  static const int CUSTOMER_ADD = 7;
  static const int TRANSPORT_ADD = 8;
}