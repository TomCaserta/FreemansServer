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
  DateTime deliveryDate;

  SalesRow ();

  SalesRow.fromJson(Map jsonMap):super.fromJson(jsonMap);

  void mergeJson (Map jsonMap) {
    this.amount = jsonMap["amount"];
    this.cost = jsonMap["cost"];
    this.supplierID = jsonMap["supplierID"];
    this.productID = jsonMap["productID"];
    this.weightID = jsonMap["weightID"];
    this.packagingID = jsonMap["packagingID"];
    this.collectingHaulierID = jsonMap["collectingHaulierID"];
    super.mergeJson(jsonMap);
  }


  Map toJson () {
    return super.toJson()..addAll({
        "amount": amount,
        "cost": cost,
        "supplierID": supplierID,
        "productID": productID,
        "weightID": weightID,
        "packagingID": packagingID,
        "collectingHaulierID": collectingHaulierID
    });
  }
}