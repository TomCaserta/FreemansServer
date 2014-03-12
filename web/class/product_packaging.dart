part of DataObjects;

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