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
    try {
      DateTime parseDT = new DateFormat('yyyy-MM-dd').parse(purchaseDate);
      _purchaseTime = parseDT;
      refreshPurchases();
    }
    catch (E) {
      // TODO: handle this error
      print("Could not parse :( $purchaseDate");
    }
  }
  Supplier _activeSupplier;
  Supplier get activeSupplier => _activeSupplier;
  set activeSupplier (Supplier activeSupplier) {
    _activeSupplier = activeSupplier;
    refreshPurchases();
  }

  int ID;
  String Uuid;
  ProductWeight activeWeight;
  Product activeProduct;
  ProductPackaging activePackaging;
  Transport activeTransport;
  List<PurchaseRow> previousPurchases = [];
  num cost;
  num qty;

  List<String> notifications = new List<String>();
  bool isError = false;
  bool isAdd = true;
  
  PurchasesController (Scope this.s, StateService this.state) {
    refreshPurchases ();
  }
  
  void addPurchase () {
    if (activeSupplier != null && activeProduct != null) {
      isError = false;
      PurchaseRow nPurRow = new PurchaseRow();
      nPurRow.supplierID = activeSupplier.ID;
      nPurRow.cost = cost;
      nPurRow.amount = qty;
      nPurRow.isActive = true;
      nPurRow.productID = activeProduct.ID;
      if (activeTransport != null) nPurRow.collectingHaulierID = activeTransport.ID;
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
            this.refreshPurchases();
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
      else {
        nPurRow.ID = this.ID;
        nPurRow.Uuid = this.Uuid;
        nPurRow.update(state.wsh).then((ActionResponseServerPacket response) {
          if (response.complete == true) {
            notifications.clear();
            isError = false;
            notifications.add("Updated purchase row");
            this.activeWeight = null;
            this.activeProduct = null;
            this.activePackaging = null;
            this.cost = null;
            this.qty = null;
            this.ID = null;
            this.Uuid = null;
            nPurRow.mergeJson(response.payload[0]);
            this.refreshPurchases();
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
        if (activeSupplier == null) notifications.add("You need to provide a supplier.");
        if (activeProduct == null) notifications.add("You need to provide a product");
        isError = true;
      }
  }

  void clear () {
    isAdd = true;
    _purchaseTime = new DateTime.now();
    this.activeSupplier = null;
    this.activeTransport = null;
    this.activeWeight = null;
    this.activeProduct = null;
    this.activePackaging = null;
    this.cost = null;
    this.qty = null;
    this.Uuid = null;
    this.ID = null;
    isError = false;
    notifications.clear();
  }

  void editPreviousPurchase (PurchaseRow row) {
    isAdd = false;
    activeSupplier = row.supplier;
    activeWeight = row.weight;
    activeProduct = row.product;
    activePackaging = row.packaging;
    activeTransport = row.collectingHaulier;
    cost = row.cost;
    qty = row.amount;
    _purchaseTime = row.purchaseTime.toLocal();
    ID = row.ID;
    Uuid = row.Uuid;
    isError = false;
    notifications.clear();
  }

  void refreshPurchases () {
    if (_purchaseTime != null) {
      int t = _purchaseTime.millisecondsSinceEpoch;
      print(t);
      int dayBegin = t - (t % 86400000) - 1;
      int dayEnd = dayBegin + 86400000 + 1;

      PurchaseRow.searchData(this.state.wsh, supplierID: (this.activeSupplier != null ? this.activeSupplier.ID : null), purchaseTimeFrom: dayBegin, purchaseTimeTo: dayEnd).then((List<PurchaseRow> data) {
        previousPurchases.clear();
        previousPurchases.addAll(data);
      });
    }
  }

}