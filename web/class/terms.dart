part of DataObjects;

class Terms extends Syncable {
  final int type = SyncableTypes.TERMS;  
  DateTime timeCreated;
  DateTime timeModified;
  String name;
  int stdDueDays;
  int stdDiscountDays;
  num discountPct;
  Terms();
  
  Terms.fromJson(Map jsonMap):super.fromJson(jsonMap);
  
  void mergeJson (Map jsonMap) {
    this.timeCreated = new DateTime.fromMillisecondsSinceEpoch(jsonMap["timeCreated"], isUtc: true);
    this.timeModified = new DateTime.fromMillisecondsSinceEpoch(jsonMap["timeModified"], isUtc: true);
    this.name = jsonMap["name"];
    this.stdDueDays = jsonMap["stdDueDays"];
    this.stdDiscountDays = jsonMap["stdDiscountDays"];
    this.discountPct = jsonMap["discountPct"];
    super.mergeJson(jsonMap);
  }
  
  
  Map toJson () {
    return super.toJson()..addAll({  
                                    "timeCreated": timeCreated.millisecondsSinceEpoch, 
                                    "timeModified": timeModified.millisecondsSinceEpoch,  
                                    "name": name,  
                                    "stdDueDays": stdDueDays,  
                                    "stdDiscountDays": stdDiscountDays,  
                                    "discountPct": discountPct 
                                  });
  }
}