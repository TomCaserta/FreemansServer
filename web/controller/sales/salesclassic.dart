part of FreemansClient;

@NgController(
  selector: "[sales-classic]",
  publishAs: "productlist"
)
class SalesClassicController {
  Scope s;
  StateService state;
  
    
  SalesClassicController (Scope this.s, StateService this.state) {
    
  }
}

class CategoryController {
  ProductCategory cat;
  String get name => cat.categoryName;  
  
  List<ProductGroupController> products = new List<ProductGroupController>();
  
  CategoryController (this.cat) {
    
  }
  
}

class ProductGroupController {
  ProductGroup productGroup;
  String get fullName => "${productGroup.product.name} ${productGroup.item.name} ${productGroup.packaging.name}";
  
  ProductGroupController (this.productGroup);
  
  bool active = false;
  
  void toggleView () {
    active = !active;
  }
}