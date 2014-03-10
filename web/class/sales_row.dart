part of DataObjects;

//
//Map toJson () {
//  return super.toJson()..addAll({ "customerID": (customer != null ? customer.ID : null), "transportID": (transport != null ? transport.ID : null), "amount": amount, "salePrice": salePrice, "deliveryDate": deliveryDate.millisecondsSinceEpoch });
//}

class SalesRow extends Syncable {
  int type = SyncableTypes.SALE_ROW;

  int customerID;
  int transportID;
  num amount;
  num salePrice;
  num deliveryCost;
  DateTime deliveryDate;

  int produceID;
  //or
  int productID;
  int weightID;
  int packagingID;

  SalesRow ();

  SalesRow.fromJson(Map jsonMap):super.fromJson(jsonMap);

  void mergeJson (Map jsonMap) {
    this.amount = jsonMap["amount"];
    this.customerID = jsonMap["customerID"];
    this.transportID = jsonMap["transportID"];
    this.salePrice = jsonMap["salePrice"];
    this.deliveryCost = jsonMap["deliveryCost"];

    if (jsonMap["deliveryDate"] != null) {
      this.deliveryDate = new DateTime.millisecondsSinceEpoch(jsonMap["deliveryDate"], isUtc: true);
    }
    super.mergeJson(jsonMap);
  }


  Map toJson () {
    return super.toJson()..addAll({
        "amount": amount,
        "customerID": customerID,
        "transportID": transportID,
        "salePrice": salePrice,
        "deliveryDate": (deliveryDate != null ? deliveryDate.millisecondsSinceEpoch : null),
        "deliveryCost": deliveryCost,
        "produceID": produceID,
        "productID": productID,
        "weightID": weightID,
        "packagingID": packagingID
    });
  }
}