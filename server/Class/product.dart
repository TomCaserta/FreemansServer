part of FreemansServer;


class ProductWeight extends Cachable<ProductWeight>  {
  // Static
  ProductWeight._create(ID, this.description):super(ID);
  
  factory ProductWeight (int ID, String description) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new ProductWeight._create(ID, description);
  }
  static exists (int ID) => Cachable.exists(ProductWeight, ID);
  static get (int ID) => Cachable.exists(ProductWeight, ID);
  
  //TODO: Implement
  static void init() {
    
  }
  
  // Object
  
  String description;
  
  
  Future<bool> updateDatabase (DatabaseHandler dbh) {
     if (this.isNew) {
       dbh.prepareExecute("INSERT INTO productweights (description) VALUES (?)", [this.description]).then((res) { 
         
       }); 
     }
     else if (id != 0) {
       
     }
  }
}

class ProductPackaging extends Cachable<ProductPackaging>  {
  // Static
  ProductPackaging._create(ID, this.description):super(ID);
  factory ProductPackaging (int ID, String description) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new ProductPackaging._create(ID, description);
  }
  static exists (int ID) => Cachable.exists(ProductPackaging, ID);
  static get (int ID) => Cachable.exists(ProductPackaging, ID);
  
  //TODO: Implement
  static void init() {
    
  }
  
  // Object
  
  String description;
  
  
  Future<bool> updateDatabase (DatabaseHandler dbh) {
    
  }
}

class Product extends Cachable<Product> {
  // Static
  Product._create(ID, this.name, this.validWeights, this.validPackaging, this.quickbooksName):super(ID);
  
  factory Product (int ID, String name, List<int> validWeights, List<int> validPackaging, String quickbooksName) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new Product._create(ID, name, validWeights, validPackaging, quickbooksName);
  }
  
  static exists (int ID) => Cachable.exists(Product, ID);
  static get (int ID) => Cachable.exists(Product, ID);

  static void init() {
    
  }
  
  // Object
  
  String name;
  List<int> validWeights = new List<int>();
  List<int> validPackaging = new List<int>();
  String quickbooksName;
  
  
  Future<bool> updateDatabase (DatabaseHandler dbh) {
    
  }
  
}
class ProductGroup {
  String name;
  Product product;
  ProductWeight item;
  ProductPackaging packaging;
  
}