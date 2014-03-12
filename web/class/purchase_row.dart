part of DataObjects;

class PurchaseRow extends Syncable {
  int type = SyncableTypes.PURCHASE_ROW;

  num amount;
  num cost;
  int supplierID;
  int productID;
  int weightID;
  int packagingID;
  int descriptorID;
  int collectingHaulierID;

  DateTime purchaseTime = new DateTime.now().toUtc();
  String get formattedPurchaseTime => new DateFormat("dd/MM").format(purchaseTime.toLocal());

  Supplier get supplier => Syncable.get(SyncableTypes.SUPPLIER, supplierID);
  Product get product => Syncable.get(SyncableTypes.PRODUCT, productID);
  ProductWeight get weight => Syncable.get(SyncableTypes.PRODUCT_WEIGHT, weightID);
  ProductPackaging get packaging => Syncable.get(SyncableTypes.PRODUCT_PACKAGING, packagingID);
  ProductDescriptors get descriptor => Syncable.get(SyncableTypes.PRODUCT_DESCRIPTOR, descriptorID);
  Transport get collectingHaulier => Syncable.get(SyncableTypes.TRANSPORT, collectingHaulierID);

  static PurchaseRow get(int ID) => Syncable.get(SyncableTypes.PURCHASE_ROW, ID);
  static bool exists(ID) => Syncable.exists(SyncableTypes.PURCHASE_ROW, ID);



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
    this.descriptorID = jsonMap["descriptorID"];
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
        "descriptorID": descriptorID,
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

  static Future<List<PurchaseRow>> searchData (WebsocketHandler wsh, {int start, int identifier,
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
                                                int descriptorID,
                                                int collectingHaulierID,
                                                int purchaseTimeFrom,
                                                int purchaseTimeTo,
                                                bool getSales,
                                                String orderBy}) {
    Completer c = new Completer();
    FetchPurchaseRowDataClientPacket packet = new FetchPurchaseRowDataClientPacket(start: start,
                                                                                   identifier: identifier,
                                                                                   max: max,
                                                                                   groupBy: groupBy,
                                                                                   amount: amount,
                                                                                   amountOperator: amountOperator,
                                                                                   cost: cost,
                                                                                   costOperator: "=",
                                                                                   supplierID: supplierID,
                                                                                   productID: productID,
                                                                                   descriptorID: descriptorID,
                                                                                   weightID: weightID,
                                                                                   packagingID: packagingID,
                                                                                   collectingHaulierID: collectingHaulierID,
                                                                                   purchaseTimeFrom: purchaseTimeFrom,
                                                                                   purchaseTimeTo: purchaseTimeTo,
                                                                                   getSales: getSales,
                                                                                   orderBy: orderBy);
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