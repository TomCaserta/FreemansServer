part of FreemansServer;

@NgController(
  selector: "[salesinput]",
  publishAs: "sales"
)
class SalesController {
  Scope s;
  StateService state;
  
  List get productList {
    return this.state.productList.where((e) => e.isActive).map((e) => e.name).toList();
  }
  
  List get weightList {
    return this.state.productWeightsList.where((e) => e.isActive).map((e) => e.name).toList();
  }
  
  List get packagingList {
    return this.state.productPackagingList.where((e) => e.isActive).map((e) => e.name).toList();
  }
  
  SalesController (Scope this.s, StateService this.state) {
print(weightList);
  }
}