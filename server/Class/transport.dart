part of FreemansServer;

class Surcharge {
  DateTime dateBefore;
  int surcharge;
  Surcharge (DateTime this.dateBefore, this.surcharge);
  Surcharge.parse(String dateBefore, String surcharge) {
     this.surcharge = int.parse(surcharge, onError: (e) { 
       Logger.root.severe("Could not parse surcharge $surcharge", e);
     });
     this.dateBefore = FFPDToDate(dateBefore);
  }
  toString () {
    return "${dateToFFPD(dateBefore)}:$surcharge";
  }
}

class Transport {
  List<Surcharge> surcharges = new List<Surcharge>();
  int ID = 0;
  String name = "";
  String quickbooksName = "";
  String transportSheetEmail = "";
  String remittanceEmail = "";
  Transport (this.ID, this.name, this.quickbooksName, this.surcharges, this.transportSheetEmail, this.remittanceEmail) {
    if (!exists(this.name)) {
      transportCompanies[name] = this;
    }
    else {
      Logger.root.severe("Duplicate Transport entry for $name");
    }
  }
  
  
  static Map<String, Transport> transportCompanies = new Map<String, Transport>();
  
  static bool exists(String name) {
    return transportCompanies.containsKey(name);
  }
  
  static Transport getTransport (String name) {
    if (exists(name)) {
      return transportCompanies[name];
    }
  }
  
  static Future<bool> init () {
    Completer c = new Completer();
    dbHandler.query("SELECT ID, name, remittanceEmail, transportSheetEmail, surcharges, quickbooksName FROM transport").then((Results res) {
       res.listen((Row data) {
         int ID = data[0];
         String name = data[1];
         String remittanceEmail = data[2];
         String transportSheetEmail = data[3];
         String surchargeL = data[4].toString();
         String quickbooksName = data[5];
         
         List<String> surchargeList = surchargeL.split(",");
         List<Surcharge> surcharges = new List<Surcharge>();
         surchargeList.forEach((String sur) {
           List<String> splitSur = sur.split(":");
           surcharges.add(new Surcharge.parse(splitSur[0], splitSur[1]));
         });
         
         
       }, 
       onDone: () { 
         Logger.root.info("Loaded transport list");
         c.complete(true);
       },
       onError: (e) { 
         c.completeError("Error whilst querying Transport list: $e");
         Logger.root.severe("Error whilst querying Transport list", e);
       });      
    }).catchError((e) { 
      c.completeError("Error whilst loading Transport list: $e");
      Logger.root.severe("Error whilst loading Transport list", e);
    });   
    return c.future;
  }
  
}