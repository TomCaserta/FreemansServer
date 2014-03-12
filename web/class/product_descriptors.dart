part of DataObjects;

class ProductDescriptors extends Syncable {
  final int type = SyncableTypes.PRODUCT_DESCRIPTOR;
  String description = "";
  String get name => description;
  ProductDescriptors();
  ProductDescriptors.fromJson(Map jsonMap):super.fromJson(jsonMap) {
  }
  void mergeJson (Map jsonMap) {
    this.description = jsonMap["description"];
    super.mergeJson(jsonMap);
  }
  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({  "description": description });
  }

}
