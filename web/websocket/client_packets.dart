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
  bool isAdd = false;
  DataChangeClientPacket (this.change, this.type, this.identifier, this.isAdd);
  
  Map<String, dynamic>  toJson () {
    return super.toJsonDefault(ID)..addAll({ "identifier": this.identifier, "type": this.type, "change": this.change, "isAdd": isAdd });
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

class SendSessionClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.SEND_SESSION;
  String sessionID;
  SendSessionClientPacket (this.sessionID);
  
  Map<String, dynamic> toJson () {
    return super.toJsonDefault(ID)..addAll({ "sessionID": sessionID });
  }
}
class FetchSalesRowDataClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.SALES_ROW_DATA;
  int start;
  int max;
  num amount;
  String amountOperator = "=";
  num salePrice;
  String salePriceOperator = "=";
  String rID;
  String orderBy = "";
  int identifier;
  int descriptorID;
  int customerID;
  int produceID;
  int productID;
  int weightID;
  int packagingID;
  int deliveryDateFrom;
  int deliveryDateTo;
  int deliveryCost;
  String deliveryCostOperator = "=";
  int transportID;
  bool active = true;
  FetchSalesRowDataClientPacket ({this.rID,
                                           this.start,
                                           this.max,
                                           this.amount,
                                           this.amountOperator,
                                           this.salePrice,
                                           this.salePriceOperator,
                                           this.identifier,
                                           this.descriptorID,
                                           this.customerID,
                                           this.produceID,
                                           this.productID,
                                           this.weightID,
                                           this.packagingID,
                                           this.deliveryDateFrom,
                                           this.deliveryDateTo,
                                           this.deliveryCost,
                                           this.deliveryCostOperator,
                                           this.transportID,
                                           this.orderBy,
                                           this.active
                                           });

  Map<String, dynamic> toJson () {
    return super.toJsonDefault(ID)..addAll({ "start": start,
                                             "identifier": identifier,
                                             "max": max,
                                             "amount": amount,
                                             "amountOperator": amountOperator,
                                             "salePrice": salePrice,
                                             "salePriceOperator": salePriceOperator,
                                             "customerID": customerID,
                                             "productID": productID,
                                             "descriptorID": descriptorID,
                                             "weightID": weightID,
                                             "packagingID": packagingID,
                                             "produceID": produceID,
                                             "deliveryDateFrom": deliveryDateFrom,
                                             "deliveryDateTo": deliveryDateTo,
                                             "deliveryCost": deliveryCost,
                                             "deliveryCostOperator": deliveryCostOperator,
                                             "transportID": transportID,                
                                             "orderBy": orderBy,
                                             "active": active
                                          });
  }
  
}


class FetchPurchaseRowDataClientPacket extends RequireResponseClientPacket {
  static int ID = CLIENT_PACKET_IDS.PURCHASE_ROW_DATA;
  int start;
  int identifier;
  int max;
  num amount;
  String amountOperator = "=";
  num cost;
  String costOperator = "=";
  int supplierID;
  int productID;
  int weightID;
  int packagingID;
  int descriptorID;
  int collectingHaulierID;
  int purchaseTimeFrom;
  int purchaseTimeTo;
  bool getSales = false;
  String orderBy;
  bool active = true;
  FetchPurchaseRowDataClientPacket ({
                                  this.start,
                                  this.identifier,
                                  this.max,
                                  this.amount,
                                  this.amountOperator: "=",
                                  this.cost,
                                  this.costOperator: "=",
                                  this.supplierID,
                                  this.productID,
                                  this.weightID,
                                  this.packagingID,
                                  this.descriptorID,
                                  this.collectingHaulierID,
                                  this.purchaseTimeFrom,
                                  this.purchaseTimeTo,
                                  this.getSales,
                                  this.orderBy,
                                  this.active
                                  });


  Map<String, dynamic> toJson () {
    return super.toJsonDefault(ID)..addAll({ "start": start,
                                             "identifier": identifier,
                                             "max": max,
                                             "amount": amount,
                                             "amountOperator": amountOperator,
                                             "cost": cost,
                                             "costOperator": costOperator,
                                             "supplierID": supplierID,
                                             "productID": productID,
                                             "descriptorID": descriptorID,
                                             "weightID": weightID,
                                             "packagingID": packagingID,
                                             "collectingHaulierID": collectingHaulierID,
                                             "purchaseTimeFrom": purchaseTimeFrom,
                                             "purchaseTimeTo": purchaseTimeTo,
                                             "getSales": getSales,
                                             "orderBy": orderBy,
                                             "active": active
                                          });
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
  static const int PURCHASE_ROW = 12;
  static const int SALE_ROW = 13;
  static const int PRODUCT_DESCRIPTOR = 14;
}

class CLIENT_PACKET_IDS {
  static const int AUTHENTICATE = 1;
  static const int PING_PONG = 2;
  static const int INITIAL_DATA_REQUEST = 3;
  static const int SYNCABLE_MODIFY = 4;
  static const int DATA_CHANGE = 5;
  static const int SEND_SESSION = 6;
  static const int PURCHASE_ROW_DATA = 7;
  static const int SALES_ROW_DATA = 8;
}