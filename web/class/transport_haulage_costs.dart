part of DataObjects;

class TransportHaulageCost extends Syncable {
  final int type = SyncableTypes.TRANSPORT_HAULAGE_COST;  
  
  int transportID;
  int locationID;
  num cost;
  bool canDeliver;
  
  TransportHaulageCost();
  
  TransportHaulageCost.fromJson(Map jsonMap):super.fromJson(jsonMap);
  
  void mergeJson (Map jsonMap) {
    this.transportID = jsonMap["transportID"];
    this.locationID = jsonMap["locationID"];
    this.cost = jsonMap["cost"];
    this.canDeliver = jsonMap["canDeliver"];
    super.mergeJson(jsonMap);
  }
  
  
  Map toJson () {
    return super.toJson()..addAll({ "transportID": transportID, "locationID": locationID, "cost": cost, "canDeliver": canDeliver });
  }
}