part of DataObjects;

class Options extends Syncable {
  final int type = SyncableTypes.OPTION;
  String name;
  String option;
  Options();

  Options.fromJson(Map jsonMap):super.fromJson(jsonMap);

  void mergeJson (Map jsonMap) {
    this.name = jsonMap["name"];
    this.option = jsonMap["option"];
    super.mergeJson(jsonMap);
  }


  Map toJson () {
    return super.toJson()..addAll({
      "name": name,
      "option": option
    });
  }
}