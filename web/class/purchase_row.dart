part of DataObjects;

class PurchaseRow extends Syncable {
  int type = SyncableTypes.PURCHASE_ROW;

  num amount;
  num cost;
  int supplierID;
  int productID;
  int weightID;
  int packagingID;
  int collectingHaulierID;
  DateTime purchaseTime = new DateTime.now().toUtc();

  PurchaseRow ();

  PurchaseRow.fromJson(Map jsonMap):super.fromJson(jsonMap);

  void mergeJson (Map jsonMap) {
    this.amount = jsonMap["amount"];
    this.cost = jsonMap["cost"];
    this.supplierID = jsonMap["supplierID"];
    this.productID = jsonMap["productID"];
    this.weightID = jsonMap["weightID"];
    this.packagingID = jsonMap["packagingID"];
    this.collectingHaulierID = jsonMap["collectingHaulierID"];
    if (jsonMap["purchaseTime"] != null) {
      this.purchaseTime = new DateTime.millisecondsSinceEpoch(jsonMap["purchaseTime"], isUtc: true);
    }
    else purchaseTime = new DateTime.now().toUtc();
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
       "collectingHaulierID": collectingHaulierID,
       "purchaseTime": purchaseTime.millisecondsSinceEpoch
    });
  }
}