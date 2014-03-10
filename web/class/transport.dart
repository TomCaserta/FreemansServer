part of DataObjects;

class Surcharge {
  DateTime dateBefore;
  num surcharge;
  Surcharge (DateTime this.dateBefore, this.surcharge);
  Surcharge.parse(String dateBefore, String surcharge) {
    print("$dateBefore $surcharge");
      this.surcharge = num.parse(surcharge, (e) {
        print("Could not parse surcharge");
      });
      this.dateBefore = FFPDToDate(dateBefore);
   }

  toString () {
    return "${dateToFFPD(dateBefore)}:$surcharge";
  }
  List toJson () { 
          return [dateBefore.toUtc().millisecondsSinceEpoch, surcharge];
  }
}


class Transport extends Syncable {
  final int type = SyncableTypes.TRANSPORT;
  List<Surcharge> surcharges = new List<Surcharge>();
  List<List> get surchargesArray => surcharges.map((e) => [new DateFormat("dd/MM/yy").format(e.dateBefore), e.surcharge]).toList();
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
    if (jsonMap["surcharges"] != null && jsonMap["surcharges"] is String && jsonMap["surcharges"].isNotEmpty) {
      String surchargeStr = jsonMap["surcharges"];
      List<String> splitS = surchargeStr.split(",");
      surcharges.clear();
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
  num applySurcharge (num value, DateTime t) {
    if (surcharges != null) {
      num oput = value;
      surcharges.sort((Surcharge a, Surcharge b) => a.dateBefore.compareTo(b.dateBefore));
      surcharges.forEach((Surcharge s) {
        if (s.dateBefore.compareTo(t) < 0) {
          print(((value / 100) * s.surcharge));
          oput = value + ((value / 100) * s.surcharge);
        }
      });
      return oput;
    }
    return value;
  }
  num removeSurcharge (num value, DateTime t) {
    if (surcharges != null) {
      num oput = value;
      surcharges.sort((Surcharge a, Surcharge b) => a.dateBefore.compareTo(b.dateBefore));
      surcharges.forEach((Surcharge s) {
        if (s.dateBefore.compareTo(t) < 0) {
          oput = value /  ((s.surcharge / 100) + 1);
        }
      });
      return oput;
    }
    return value;
  }
  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({
      "surcharges": surcharges.join(","),
      "name": name,
      "quickbooksName": quickbooksName,
      "transportSheetEmail": transportSheetEmail,
      "remittanceEmail": (remittanceEmail != null ? remittanceEmail : "")
    });
  }
}