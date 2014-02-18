part of FreemansServer;

class Surcharge {
  DateTime dateBefore;
  int surcharge;
  Surcharge (DateTime this.dateBefore, this.surcharge);
  Surcharge.parse(String dateBefore, String surcharge) {
     this.surcharge = int.parse(surcharge, onError: (e) {
       ffpServerLog.severe("Could not parse surcharge $surcharge", e);
     });
     this.dateBefore = FFPDToDate(dateBefore);
  }
  toString () {
    return "${dateToFFPD(dateBefore)}:$surcharge";
  }
  List toJson () { 
          return [dateBefore.millisecondsSinceEpoch, surcharge];
  }
  
}

class Transport extends SyncCachable<Transport> {
  List<Surcharge> _surcharges = new List<Surcharge>();
  String _name = "";
  String _quickbooksName = "";
  String _transportSheetEmail = "";
  String _remittanceEmail = "";
  String _termsRef;  
  int _terms;

  String get name => _name;
  String get quickbooksName => _quickbooksName;
  String get transportSheetEmail => _transportSheetEmail;
  String get remittanceEmail => _remittanceEmail;
  String get termsRef => _termsRef;
  int get terms => _terms;
  
  Map<String, dynamic> toJson () { 
          return super.toJson()..addAll({ "name": name,
                                          "quickbooksName": quickbooksName,
                                          "transportSheetEmail": transportSheetEmail,
                                          "remittanceEmail": remittanceEmail,
                                          "termsRef": termsRef,
                                          "terms": terms
                                          });
  }
  
  
  set name (String name) {
    if (name != _name) {
      _name = name;
      requiresDatabaseSync();
    }
  }
  set quickbooksName (String quickbooksName) {
    if (quickbooksName != _quickbooksName) {
      _quickbooksName = quickbooksName;
      requiresDatabaseSync();
    }
  }
  set transportSheetEmail (String transportSheetEmail) {
    if (transportSheetEmail != _transportSheetEmail) {
      _transportSheetEmail = transportSheetEmail;
      requiresDatabaseSync();
    }
  }
  set remittanceEmail (String remittanceEmail) {
    if (remittanceEmail != _remittanceEmail) {
      _remittanceEmail = remittanceEmail;
      requiresDatabaseSync();
    }
  }

  set termsRef (  String termsRef) {
    if (termsRef != _termsRef) {
      _termsRef = termsRef;
      requiresDatabaseSync();
    }
  }
  
  set terms (int terms) {
    if (terms != _terms) {
      _terms = terms;
      requiresDatabaseSync();
    }
  }
  
  Transport._create (int ID, String name, this._quickbooksName, this._surcharges, this._transportSheetEmail, this._remittanceEmail, this._termsRef, this._terms):super(ID, name) {
    this._name = name;
  }

  factory Transport (int ID, String name, String quickbooksName, List<Surcharge> surcharges, String transportSheetEmail, String remittanceEmail, String termsRef, int terms) {
    if (!exists(name)) {
      return new Transport._create(ID, name, quickbooksName, surcharges, transportSheetEmail, remittanceEmail, termsRef, terms);
    }
    else return get(name);
  }


  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    String surchargesString = _surcharges.join(",");
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO transport (name, remittanceEmail, transportSheetEmail, surcharges, quickbooksName, termsRef, terms) VALUES (?,?,?,?,?,?,?)", [name, remittanceEmail,  transportSheetEmail, surchargesString.toString(), quickbooksName, termsRef, terms])
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
      dbh.prepareExecute("UPDATE transport SET name=?, remittanceEmail=?, transportSheetEmail=?, surcharges=?, quickbooksName=?, termsRef=?, terms=? WHERE ID=?", [name, remittanceEmail, transportSheetEmail, surchargesString.toString(), quickbooksName, ID, termsRef, terms])
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
    ffpServerLog.info("Loading transport list...");
    dbHandler.query("SELECT ID, name, remittanceEmail, transportSheetEmail, surcharges, quickbooksName, termsRef, terms FROM transport").then((Results res) {
       res.listen((Row data) {
         int ID = data[0];
         String name = data[1];
         String remittanceEmail = data[2];
         String transportSheetEmail = data[3];
         String surchargeL = data[4].toString();
         String quickbooksName = data[5];
         String termsRef = data[6];
         int terms = data[7];
         List<String> surchargeList = surchargeL.split(",");
         List<Surcharge> surcharges = new List<Surcharge>();
         surchargeList.forEach((String sur) {
           List<String> splitSur = sur.split(":");
           surcharges.add(new Surcharge.parse(splitSur[0], splitSur[1]));
         });
         new Transport(ID, name, quickbooksName, surcharges,  transportSheetEmail, remittanceEmail, termsRef, terms);
       },
       onDone: () {
         ffpServerLog.info("Loaded transport list");
         c.complete(true);
       },
       onError: (e) {
         c.completeError("Error whilst querying Transport list: $e");
         ffpServerLog.severe("Error whilst querying Transport list", e);
       });
    }).catchError((e) {
      c.completeError("Error whilst loading Transport list: $e");
      ffpServerLog.severe("Error whilst loading Transport list", e);
    });
    return c.future;
  }

}