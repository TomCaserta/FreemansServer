part of QuickbooksIntegration;

class QBStandardTerms extends QBModifiable {
  DateTime timeCreated;
  DateTime timeModified;
  String editSequence;
  String name;
  bool isActive;
  int stdDueDays;
  int stdDiscountDays;
  QBPercent discountPct;
  

  QBStandardTerms.parseFromListXml (XmlElement termsData) {
    listID = getQbxmlContainer(termsData, "ListID").text;
    name = getQbxmlContainer(termsData, "Name").text;
    timeCreated = getQbxmlContainer(termsData, "TimeCreated").date;
    timeModified = getQbxmlContainer(termsData, "TimeModified").date;
    editSequence = getQbxmlContainer(termsData, "EditSequence").text;
    isActive = getQbxmlContainer(termsData, "IsActive", optional: true).boolean;
    stdDueDays = getQbxmlContainer(termsData, "StdDueDays", optional: true).integer;
    stdDiscountDays = getQbxmlContainer(termsData, "StdDiscountDays", optional: true).integer;
    discountPct = getQbxmlContainer(termsData, "DiscountPct", optional: true).percent;
  }

  Future<bool> insert(QuickbooksConnector qbc) {
    
  }
  
  Future<bool> update(QuickbooksConnector qbc) {
    
  }
  
  Map toJson () {
    return {  "timeCreated": timeCreated,  "timeModified": timeModified,  "editSequence": editSequence,  "name": name,  "isActive": isActive,  "stdDueDays": stdDueDays,  "stdDiscountDays": stdDiscountDays,  "discountPct": discountPct };
  }
  
  String toString () {
    return toJson().toString();
  }
}