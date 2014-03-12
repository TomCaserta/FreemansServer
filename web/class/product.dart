part of DataObjects;



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