part of FreemansClient;

@NgController(
  selector: "[salesinput]",
  publishAs: "sales"
)
class SalesController {
  Scope s;
  StateService state;

   DateTime deliveryDate = new DateTime.now();
  int purchaseRowID;
  Customer activeCustomer;
  ProductWeight _activeWeight;
  ProductWeight get activeWeight => _activeWeight;
  set activeWeight (ProductWeight activeWeight) {
    _activeWeight = activeWeight;
    getMatchingPurchases ();
  }


  Product _activeProduct;
  Product get activeProduct => _activeProduct;
  set activeProduct (Product activeProduct) {
    _activeProduct = activeProduct;
    getMatchingPurchases ();
  }


  ProductPackaging _activePackaging;
  ProductPackaging get activePackaging => _activePackaging;
  set activePackaging (ProductPackaging activePackaging) {
    _activePackaging = activePackaging;
    getMatchingPurchases ();
  }

  Transport activeTransport;
  num cost;
  num qty;
  num haulageCost;

  List<String> notifications = new List<String>();
  bool isError = false;
  bool isAdd = true;
  bool get isFromPurchaseRow => purchaseRowID == null;

  List<PurchaseRow> purchaseList = [];

  SalesController (Scope this.s, StateService this.state) {

    getMatchingPurchases ();
  }

  void removeSurcharge () {
    if (activeTransport != null && haulageCost != null) {
      print("Removing surcharge amt");
      haulageCost = (activeTransport.removeSurcharge(haulageCost, deliveryDate) * 100).round() / 100;
    }
  }

  void addSurcharge () {

     if (activeTransport != null && haulageCost != null) {
       print("Adding surcharge amt");
       haulageCost = (activeTransport.applySurcharge(haulageCost, deliveryDate) * 100).round() / 100;
     }
  }

  void addSale () {
    if (activeCustomer != null) {
      isError = false;
      SalesRow nSalesRow = new SalesRow();
      nSalesRow.customerID = activeCustomer.ID;
      nSalesRow.salePrice = cost;
      nSalesRow.deliveryCost = haulageCost;
      nSalesRow.amount = qty;
      if (activeProduct  != null) nSalesRow.productID = activeProduct.ID;
      if (activeTransport != null) nSalesRow.transportID = activeTransport.ID;
      nSalesRow.deliveryDate = deliveryDate.toUtc();
      if (activeWeight != null) nSalesRow.weightID = activeWeight.ID;
      if (activePackaging != null) nSalesRow.packagingID = activePackaging.ID;
      nSalesRow.produceID = purchaseRowID;
      nSalesRow.isActive = true;
      if (isAdd) {
        nSalesRow.insert(this.state.wsh).then((ActionResponseServerPacket response) {
          if (response.complete == true) {
            notifications.clear();
            isError = false;
            notifications.add("Inserted new sale");
            // Remove everything but supplier
            this.activeWeight = null;
            this.activeProduct = null;
            this.activePackaging = null;
            this.haulageCost = null;
            this.cost = null;
            this.qty = null;
            this.purchaseRowID = null;
            nSalesRow.mergeJson(response.payload[0]);
          }
          else {
            isError = true;
            notifications.clear();
            response.payload.forEach((v) {
              if (v is String) {
                notifications.add(v);
              }
            });
          }
        });
      }
    }
      else {
        notifications.clear();
        if (activeCustomer == null) notifications.add("You need to provide a customer.");
        isError = true;
      }
  }

   void setParent (PurchaseRow parent) {
     this.purchaseRowID = parent.ID;
     this.activeProduct = parent.product;
     this.activeWeight = parent.weight;
     this.activePackaging = parent.packaging;
   }
  void getMatchingPurchases ([int pageNum = 0]) {
      int productID;
      if (activeProduct !=null) productID = activeProduct.ID;
      int weightID;
      if (activeWeight !=null) weightID = activeWeight.ID;
      int packagingID;
      if (activePackaging !=null) packagingID = activePackaging.ID;
      List<PurchaseRow> matchingPurchases = [];
      PurchaseRow.searchData(this.state.wsh, orderBy: "ID DESC", start: (200 * pageNum), max: ((200 * pageNum) + 200), productID: productID, weightID: weightID, packagingID: packagingID, getSales: true).then((List<PurchaseRow> data) {
        data.forEach((PurchaseRow row) {
          num totalQty = 0;
          row.salesRow.forEach((SalesRow r) {
            totalQty += r.amount != null ? r.amount : 0;
          });
          if (row.amount > totalQty) {
            matchingPurchases.add(row);
          }
        });
      });
      this.purchaseList = matchingPurchases;
  }

}