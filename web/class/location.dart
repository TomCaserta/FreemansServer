part of DataObjects;

class Locations extends Syncable {
  final int type = SyncableTypes.LOCATION;  
  String locationName;
  String get name => locationName;
  Locations();
  
  Locations.fromJson(Map jsonMap):super.fromJson(jsonMap);
  
  void mergeJson (Map jsonMap) {
    this.locationName = jsonMap["locationName"];
    super.mergeJson(jsonMap);
  }
  
  
  Map toJson () {
    return super.toJson()..addAll({  
                                    "locationName": locationName
                                  });
  }
}