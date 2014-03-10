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

  /// Does not sync with server. For ease of selecting only!
  List<SalesRow> salesRow = [];

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

    if (jsonMap["salesRow"] != null && jsonMap["salesRow"] is List) {
      salesRow.clear();
      jsonMap["salesRow"].forEach((Map srData) {
        salesRow.add(new SalesRow.fromJson(srData));
      });
    }

    if (jsonMap["purchaseTime"] != null) {
      this.purchaseTime = new DateTime.fromMillisecondsSinceEpoch(jsonMap["purchaseTime"], isUtc: true);
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

  static List<PurchaseRow> processList (List data) {
    var prList = [];
    data.forEach((Map purchaseRowData) {
      prList.add(new PurchaseRow.fromJson(purchaseRowData));
    });
    return prList;
  }

  static Future<List<PurchaseRow>> searchData (WebsocketHandler wsh, {int start,
                                                int max,
                                                String groupBy,
                                                int amount,
                                                String amountOperator: "=",
                                                int cost,
                                                String costOperator: "=",
                                                int supplierID,
                                                int productID,
                                                int weightID,
                                                int packagingID,
                                                int collectingHaulierID,
                                                int purchaseTimeFrom,
                                                int purchaseTimeTo,
                                                bool getSales}) {
    Completer c = new Completer();
    FetchPurchaseRowDataClientPacket packet = new FetchPurchaseRowDataClientPacket(start: start,
                                                                                   max: max,
                                                                                   groupBy: groupBy,
                                                                                   amount: amount,
                                                                                   amountOperator: amountOperator,
                                                                                   cost: cost,
                                                                                   costOperator: "=",
                                                                                   supplierID: supplierID,
                                                                                   productID: productID,
                                                                                   weightID: weightID,
                                                                                   packagingID: packagingID,
                                                                                   collectingHaulierID: collectingHaulierID,
                                                                                   purchaseTimeFrom: purchaseTimeFrom,
                                                                                   purchaseTimeTo: purchaseTimeTo,
                                                                                   getSales: getSales);
    wsh.sendGetResponse(packet).then((ActionResponseServerPacket resp) {
      if (resp.complete == true) {
        c.complete(processList(resp.payload));
      }
      else {
        c.completeError(resp.payload);
      }
    });
    return c.future;
  }
}