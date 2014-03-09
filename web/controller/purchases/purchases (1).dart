part of FreemansClient;

@NgController(
  selector: "[purchases]",
  publishAs: "purchases"
)
class PurchasesController {
  Scope s;
  StateService state;

  DateTime _purchaseTime = new DateTime.now();
  String get purDate => new DateFormat('yyyy-MM-dd').format(_purchaseTime);
  set purDate (String purchaseDate) {
    print("parsing date $purchaseDate");
    if (purchaseDate != null && purchaseDate.isNotEmpty) {
    try {
      DateTime parseDT = DateTime.parse(purchaseDate);
      _purchaseTime = parseDT;
    }
    catch (E) {
      print("Date conversion error occured");
      // TODO: handle this error
    }
    }
  }
  Supplier activeSupplier;
  ProductWeight activeWeight;
  Product activeProduct;
  ProductPackaging activePackaging;
  num cost;
  num qty;

  List<String> notifications = new List<String>();
  bool isError = false;
  bool isAdd = true;
  
  PurchasesController (Scope this.s, StateService this.state) {

  }
  
  void addPurchase () {
    print("Attempting add");
    print(activeSupplier);
    print(activeProduct);
    if (activeSupplier != null && activeProduct != null) {
      PurchaseRow nPurRow = new PurchaseRow();
      nPurRow.supplierID = activeSupplier.ID;
      nPurRow.cost = cost;
      nPurRow.amount = qty;
      nPurRow.productID = activeProduct.ID;
      nPurRow.purchaseTime = _purchaseTime.toUtc();
      if (activeWeight != null) nPurRow.weightID = activeWeight.ID;
      if (activePackaging != null) nPurRow.packagingID = activePackaging.ID;
      if (isAdd) {
        nPurRow.insert(this.state.wsh).then((ActionResponseServerPacket response) {
          if (response.complete == true) {
            notifications.clear();
            isError = false;
            notifications.add("Inserted new purchase");
            // Remove everything but supplier
            this.activeWeight = null;
            this.activeProduct = null;
            this.activePackaging = null;
            this.cost = null;
            this.qty = null;
            nPurRow.mergeJson(response.payload[0]);
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

    void refreshPurchases ([DateTime date, Supplier supplierName]) {

    }
  }
}