part of DataObjects;

class ProductWeight extends Syncable {
  final int type = SyncableTypes.PRODUCT_WEIGHT;
  String description;
  int kg;
  String get name => description;
  ProductWeight();
  ProductWeight.fromJson(Map jsonMap):super.fromJson(jsonMap) {

  }
  
  void mergeJson (Map jsonMap) {
    this.description = jsonMap["description"];
    this.kg = jsonMap["kg"];
    super.mergeJson(jsonMap);
  }
  Map<String, dynamic> toJson () { 
          return super.toJson()..addAll({   "description": description,
                                            "kg": kg
                                         });
  }
}

class ProductPackaging extends Syncable {
  final int type = SyncableTypes.PRODUCT_PACKAGING;
  String description;
  String get name => description;
  ProductPackaging ();
  ProductPackaging.fromJson(Map jsonMap):super.fromJson(jsonMap) {
  } 
  void mergeJson (Map jsonMap) {
    this.description = jsonMap["description"];
    super.mergeJson(jsonMap);
  }
  
  Map<String, dynamic> toJson () { 
          return super.toJson()..addAll({ "description": description });
  }
  
}


class ProductCategory extends Syncable {
  final int type = SyncableTypes.PRODUCT_CATEGORY;
  String categoryName = "";
  String categoryColour = "#FFFFFF";
  String get name => categoryName;
  ProductCategory();
  ProductCategory.fromJson(Map jsonMap):super.fromJson(jsonMap) {
  }
  void mergeJson (Map jsonMap) {
    this.categoryName = jsonMap["categoryName"];
    this.categoryColour = jsonMap["categoryColour"];
    super.mergeJson(jsonMap);    
  }
  Map<String, dynamic> toJson () { 
    return super.toJson()..addAll({  "categoryName": categoryName,
                                     "categoryColour": categoryColour });
  }
 
}

class Product extends Syncable {
  final int type = SyncableTypes.PRODUCT;
  String name;
  List<int> validWeights = new List<int>();
  List<int> validPackaging = new List<int>();
  String quickbooksName;
  int category;
  Product();
  Product.fromJson (Map jsonMap):super.fromJson(jsonMap) {
  }
  void mergeJson (Map jsonMap) {
    this.name = jsonMap["name"];
    this.validWeights = jsonMap["validWeights"];
    this.validPackaging = jsonMap["validPackaging"];
    this.quickbooksName = jsonMap["quickbooksName"];
    this.category = jsonMap["category"];
    super.mergeJson(jsonMap);    
  }
  Map<String, dynamic> toJson () { 
          return super.toJson()..addAll({ "name": name,
                                          "quickbooksName": quickbooksName,
                                          "validWeights":   validWeights,
                                          "validPackaging": validPackaging,
                                          "category": category });
  }
}


class ProductGroup {
  Product product;
  ProductWeight item;
  ProductPackaging packaging;
  ProductGroup(this.product, this.item, this.packaging) {
    
  }
  
  
} 