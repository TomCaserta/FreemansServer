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

class Transport extends SyncCachable<Transport> {
  List<Surcharge> surcharges = new List<Surcharge>();
  String name = "";
  String quickbooksName = "";
  String transportSheetEmail = "";
  String remittanceEmail = "";
  Transport._create (int ID, String name, this.quickbooksName, this.surcharges, this.transportSheetEmail, this.remittanceEmail):super(ID, name) {
    this.name = name;
  }

  factory Transport (int ID, String name, String quickbooksName, List<Surcharge> surcharges, String transportSheetEmail, String remittanceEmail) {
    if (!exists(name)) {
      return new Transport._create(ID, name, quickbooksName, surcharges, transportSheetEmail, remittanceEmail);
    }
    else return get(name);
  }


  Future<bool> updateDatabase (DatabaseHandler dbh) {
    Completer c = new Completer();
    String surchargesString = surcharges.join(",");
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO transport (name, remittanceEmail, transportSheetEmail, surcharges, quickbooksName) VALUES (?,?,?,?,?)", [name, remittanceEmail,  transportSheetEmail, surchargesString.toString(), quickbooksName])
         .then((Results res) {
            if (res.insertId != 0) {
               this._firstInsert(res.insertId);
               c.complete(true);
            }
            else {
              c.completeError("Unspecified mysql error");
            }
          })
         .catchError((e) => c.completeError(e));
    }
    else {
      dbh.prepareExecute("UPDATE transport SET name=?, remittanceEmail=?, transportSheetEmail=?, surcharges=?, quickbooksName=? WHERE ID=?", [name, remittanceEmail, transportSheetEmail, surchargesString.toString(), quickbooksName, id])
         .then((Results res) {
            if (res.affectedRows <= 1) {
              this.synced();
               c.complete(true);
            }
            else {
              c.completeError("Tried updating transport however ${res.affectedRows} rows affected does not equal one.");
            }
         })
         .catchError((e) => c.completeError(e));
    }
    return c.future;
  }

  static bool exists(String name) => SyncCachable.exists(Transport, name);
  static Transport get (String name) => SyncCachable.get(Transport, name);

  static Future<bool> init () {
    Completer c = new Completer();
    Logger.root.info("Loading transport list...");
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