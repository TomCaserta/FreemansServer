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
  ProductWeight activeWeight;
  Product activeProduct;
  ProductPackaging activePackaging;
  Transport activeTransport;
  num cost;
  num qty;
  num haulageCost;

  List<String> notifications = new List<String>();
  bool isError = false;
  bool isAdd = true;
  bool get isFromPurchaseRow => purchaseRowID == null;


  SalesController (Scope this.s, StateService this.state) {
    
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

}