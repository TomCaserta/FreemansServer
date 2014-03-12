part of DataObjects;

class ProductWeight extends Syncable {
  final int type = SyncableTypes.PRODUCT_WEIGHT;
  String description;
  num kg;
  num amount;
  String get name => description;
  bool useKG = true;
  ProductWeight();
  ProductWeight.fromJson(Map jsonMap):super.fromJson(jsonMap) {

  }

  void mergeJson (Map jsonMap) {
    this.description = jsonMap["description"];
    this.kg = jsonMap["kg"];
    this.amount = jsonMap["amount"];
    super.mergeJson(jsonMap);
  }
  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({   "description": description,
        "kg": kg,
        "amount": amount
    });
  }
}