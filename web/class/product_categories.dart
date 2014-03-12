part of DataObjects;

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
