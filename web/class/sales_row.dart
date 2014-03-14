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
  int productID;
  int weightID;
  int packagingID;
  int descriptorID;

  SalesRow ();

  SalesRow.fromJson(Map jsonMap):super.fromJson(jsonMap);

  void mergeJson (Map jsonMap) {
    this.amount = jsonMap["amount"];
    this.customerID = jsonMap["customerID"];
    this.transportID = jsonMap["transportID"];
    this.salePrice = jsonMap["salePrice"];
    this.deliveryCost = jsonMap["deliveryCost"];
    this.descriptorID = jsonMap["descriptorID"];
    this.produceID = jsonMap["produceID"];
    this.productID = jsonMap["productID"];
    this.weightID = jsonMap["weightID"];
    this.packagingID = jsonMap["packagingID"];
    if (jsonMap["deliveryDate"] != null) {
      this.deliveryDate = new DateTime.fromMillisecondsSinceEpoch(jsonMap["deliveryDate"], isUtc: true);
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
        "packagingID": packagingID,
        "descriptorID": descriptorID
    });
  }
  
  static List<SalesRow> processList (List data) {
    var prList = [];
    data.forEach((Map salesRowData) {
      prList.add(new PurchaseRow.fromJson(salesRowData));
    });
    return prList;
  }
  

  static Future<List<SalesRow>> searchData (WebsocketHandler wsh, {
                                                                      start,
                                                                      max,
                                                                      amount,
                                                                      amountOperator,
                                                                      salePrice,
                                                                      salePriceOperator,
                                                                      identifier,
                                                                      descriptorID,
                                                                      customerID,
                                                                      produceID,
                                                                      productID,
                                                                      weightID,
                                                                      packagingID,
                                                                      deliveryDateFrom,
                                                                      deliveryDateTo,
                                                                      deliveryCost,
                                                                      deliveryCostOperator,
                                                                      transportID,
                                                                      orderBy,
                                                                      active
                                                                     }) {
    Completer c = new Completer();
    FetchSalesRowDataClientPacket packet = new FetchSalesRowDataClientPacket(start: start,
                                                                                    max: max,
                                                                                    amount: amount,
                                                                                    amountOperator: amountOperator,
                                                                                    salePrice: salePrice,
                                                                                    salePriceOperator: salePriceOperator,
                                                                                    identifier: identifier,
                                                                                    descriptorID: descriptorID,
                                                                                    customerID: customerID,
                                                                                    produceID: produceID,
                                                                                    productID: productID,
                                                                                    weightID: weightID,
                                                                                    packagingID: packagingID,
                                                                                    deliveryDateFrom: deliveryDateFrom,
                                                                                    deliveryDateTo: deliveryDateTo,
                                                                                    deliveryCost: deliveryCost,
                                                                                    deliveryCostOperator: deliveryCostOperator,
                                                                                    transportID: transportID,
                                                                                    orderBy: orderBy,
                                                                                    active: active);
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