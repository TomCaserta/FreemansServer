part of DataObjects;

class Surcharge {
  DateTime dateBefore;
  int surcharge;
  Surcharge (DateTime this.dateBefore, this.surcharge);
  Surcharge.parse(String dateBefore, String surcharge) {
      this.surcharge = int.parse(surcharge, onError: (e) {
        print("Could not parse surcharge");
      });
      this.dateBefore = FFPDToDate(dateBefore);
   }
  
  List toJson () { 
          return [dateBefore.toUtc().millisecondsSinceEpoch, surcharge];
  }
}


class Transport extends Syncable {
  final int type = SyncableTypes.TRANSPORT;
  List<Surcharge> surcharges = new List<Surcharge>();
  String name = "";
  String quickbooksName = "";
  String transportSheetEmail = "";
  String remittanceEmail = "";
  int terms;
  String termsRef;
  
  Transport();
  Transport.fromJson (Map jsonMap):super.fromJson(jsonMap) {
        
  }
  void mergeJson(Map jsonMap) {
    if (jsonMap["surcharges"] != null && jsonMap["surcharges"] is String) {
      String surchargeStr = jsonMap["surcharges"];
      List<String> splitS = surchargeStr.split(",");
      splitS.forEach((String sur) {
       List<String> splitSur = sur.split(":");
       surcharges.add(new Surcharge.parse(splitSur[0], splitSur[1]));
     });
    }
    this.name = jsonMap["name"];
    this.quickbooksName = jsonMap["quickbooksName"];
    this.transportSheetEmail = jsonMap["transportSheetEmail"];
    this.remittanceEmail = jsonMap["remittanceEmail"];
    this.terms = jsonMap["terms"];
    this.termsRef = jsonMap["termsRef"];
    super.mergeJson(jsonMap);
  }
  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({
      "surcharges": surcharges, 
      "name": name,
      "quickbooksName": quickbooksName,
      "transportSheetEmail": transportSheetEmail,
      "remittanceEmail": remittanceEmail,
      "terms": terms,
      "termsRef": termsRef
    });
  }
}