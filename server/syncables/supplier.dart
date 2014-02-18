part of FreemansServer;

class Supplier extends SyncCachable<Supplier> {
  String _name;
  String _quickbooksName;
  String _termsRef;
  int _terms;
  String _remittanceEmail;
  String _confirmationEmail;
  String _addressLine1;
  String _addressLine2;
  String _addressLine3;
  String _addressLine4;
  String _addressLine5;
  String _phoneNumber;
  String _faxNumber;
  
  String get name => _name;
  String get quickbooksName => _quickbooksName;
  String get termsRef => _termsRef;
  int get terms => _terms;
  String get remittanceEmail => _remittanceEmail;
  String get confirmationEmail => _confirmationEmail;
  String get addressLine1 => _addressLine1;
  String get addressLine2 => _addressLine2;
  String get addressLine3 => _addressLine3;
  String get addressLine4 => _addressLine4;
  String get addressLine5 => _addressLine5;
  String get phoneNumber => _phoneNumber;
  String get faxNumber => _faxNumber;

  Map<String, dynamic> toJson () { 
          return super.toJson()..addAll({ "name": name,
                                          "quickbooksName": quickbooksName,
                                          "addressLine1": addressLine1,
                                          "addressLine2": addressLine2,
                                          "addressLine3": addressLine3,
                                          "addressLine4": addressLine4,
                                          "addressLine5": addressLine5,
                                          "termsRef": termsRef,
                                          "terms": terms,
                                          "remittanceEmail": remittanceEmail,
                                          "confirmationEmail": confirmationEmail,
                                          "faxNumber": faxNumber,
                                          "phoneNumber": phoneNumber });
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
  set termsRef (String termsRef) {
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
  set remittanceEmail (String remittanceEmail) {
    if (remittanceEmail != _remittanceEmail) {
      _remittanceEmail = remittanceEmail;
      requiresDatabaseSync();
    }
  }
  set confirmationEmail (String confirmationEmail) {
    if (confirmationEmail != _confirmationEmail) {
      _confirmationEmail = confirmationEmail;
      requiresDatabaseSync();
    }
  }
  set addressLine1 (String addressLine1) {
    if (addressLine1 != _addressLine1) {
      _addressLine1 = addressLine1;
      requiresDatabaseSync();
    }
  }
  set addressLine2 (String addressLine2) {
    if (addressLine2 != _addressLine2) {
      _addressLine2 = addressLine2;
      requiresDatabaseSync();
    }
  }
  set addressLine3 (String addressLine3) {
    if (addressLine3 != _addressLine3) {
      _addressLine3 = addressLine3;
      requiresDatabaseSync();
    }
  }
  set addressLine4 (String addressLine4) {
    if (addressLine4 != _addressLine4) {
      _addressLine4 = addressLine4;
      requiresDatabaseSync();
    }
  }
  set addressLine5 (String addressLine5) {
    if (addressLine5 != _addressLine5) {
      _addressLine5 = addressLine5;
      requiresDatabaseSync();
    }
  }
  set phoneNumber (String phoneNumber) {
    if (phoneNumber != _phoneNumber) {
      _phoneNumber = phoneNumber;
      requiresDatabaseSync();
    }
  }
  set faxNumber (String faxNumber) {
    if (faxNumber != _faxNumber) {
      _faxNumber = faxNumber;
      requiresDatabaseSync();
    }
  }
  
  Supplier._create (int ID, String name):super(ID, name) {
    this.name = name;
  }

  factory Supplier (int ID, String name) {
    if (!exists(name)) {
      return new Supplier._create(ID, name);
    }
    else {
      ffpServerLog.severe("Duplicate Supplier Entry Found... $name");
      return get(name);
    }
  }

  /// Returns a List containing all lines of the address for the supplier.
  List<String> getFullAddress () {
    return [addressLine1, addressLine2, addressLine3, addressLine4, addressLine5];
  }


  Future<bool> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer<bool>();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO suppliers (supplierName, quickbooksName, termsRef, terms, remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, addressLine4, addressLine5) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)",
          [name, quickbooksName, termsRef, terms, remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, addressLine4, addressLine5]).then((Results res) {
              if (res.insertId != 0) {
                c.complete(true);
                this._firstInsert(res.insertId);
                ffpServerLog.info("Created new supplier $name");

              }
              else {
                c.completeError("Unspecified mysql error");
                ffpServerLog.severe("Unspecified mysql error");
              }
          }).catchError((e) {
            c.completeError(e);
            ffpServerLog.severe("Error whilst creating supplier $name :", e);
          });
    }
    else {
      dbh.prepareExecute("UPDATE suppliers SET supplierName=?, quickbooksName=?, termsRef=?, terms=?, remittanceEmail=?, confirmationEmail=?, phoneNumber=?, faxNumber=?, addressLine1=?, addressLine2=?, addressLine3=?, addressLine4=?, addressLine5=? WHERE ID=?",
          [name, quickbooksName, termsRef, terms, remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, addressLine4, addressLine5, ID]).then((Results res) {
            if (res.affectedRows <= 1) {
              this.synced();
               c.complete(true);
            }
            else {
              c.completeError("Tried updating supplier however ${res.affectedRows} rows affected does not equal one.");
            }
          }).catchError((e) {
            c.completeError(e);
          });
    }
    return c.future;
  }

  static exists (String name) => SyncCachable.exists(Supplier, name);
  static get (String name) => SyncCachable.get(Supplier, name);

  /// Creates a new supplier, inserting it into the database and sending it to quickbooks...
  static Future<Supplier> createNew (String name, String quickbooksName, { int terms: 42, String remittanceEmail: "", String confirmationEmail: "", String addressLine1: "", String addressLine2: "", String addressLine3: "", String addressLine4: "", String addressLine5: "", String phoneNumber: "", String faxNumber: "" }) {
    Completer c = new Completer<Supplier>();
    Supplier sup = new Supplier(0, name);
    sup.quickbooksName = quickbooksName;
    sup.terms = terms;
    sup.remittanceEmail = remittanceEmail;
    sup.confirmationEmail = confirmationEmail;
    sup.phoneNumber = phoneNumber;
    sup.faxNumber = faxNumber;
    sup.addressLine1 = addressLine1;
    sup.addressLine2 = addressLine2;
    sup.addressLine3 = addressLine3;
    sup.addressLine4 = addressLine4;
    sup.addressLine5 = addressLine5;
    sup.updateDatabase(dbHandler, qbHandler).then((bool done) {
      if (done == true) {
        c.complete(sup);
      }
      else c.completeError("Unspecified error");
    }).catchError((e) => c.completeError(e));
    return c.future;
  }


  /// Initializes the suppliers for use by retreiving them from the database
  static Future<bool> init () {
    Completer c = new Completer();
    ffpServerLog.info("Loading supplier list...");
    dbHandler.query("SELECT ID, supplierName, quickbooksName, terms, remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, addressLine4, addressLine5, termsRef FROM suppliers").then((Results results){
      results.listen((Row row) {
        Supplier sup = new Supplier(row[0], row[1]);
        sup._quickbooksName = row[2];
        sup._terms = row[3];
        sup._remittanceEmail = row[4];
        sup._confirmationEmail = row[5];
        sup._phoneNumber = row[6];
        sup._faxNumber = row[7];
        sup._addressLine1 = row[8];
        sup._addressLine2 = row[9];
        sup._addressLine3 = row[10];
        sup._addressLine4 = row[11];
        sup._addressLine5 = row[12];
        sup._termsRef = row[13];
      },
      onDone: () {
        c.complete(true);
        ffpServerLog.info("Supplier list loaded.");
      },
      onError: (e) {
        c.completeError("Could not load supplier list from database: $e");
        ffpServerLog.severe("Could not load supplier list from database", e);
      });
    }).catchError((e) {
      c.completeError("Could not load supplier list from database: $e");
      ffpServerLog.severe("Could not load supplier list from database", e);
    });
    return c.future;
  }
}