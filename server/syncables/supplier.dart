part of FreemansServer;

class Supplier extends Syncable<Supplier> {
  int type = SyncableTypes.SUPPLIER;
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
  bool _isEmailedConfirmation;
  bool _isEmailedRemittance;

  @IncludeSchema()
  String get name => _name;
  @IncludeSchema(isOptional: true)
  String get quickbooksName => _quickbooksName;
  @IncludeSchema(isOptional: true)
  String get termsRef => _termsRef;
  @IncludeSchema(isOptional: true)
  int get terms => _terms;
  @IncludeSchema(isOptional: true)
  String get remittanceEmail => _remittanceEmail;
  @IncludeSchema(isOptional: true)
  String get confirmationEmail => _confirmationEmail;
  @IncludeSchema(isOptional: true)
  String get addressLine1 => _addressLine1;
  @IncludeSchema(isOptional: true)
  String get addressLine2 => _addressLine2;
  @IncludeSchema(isOptional: true)
  String get addressLine3 => _addressLine3;
  @IncludeSchema(isOptional: true)
  String get addressLine4 => _addressLine4;
  @IncludeSchema(isOptional: true)
  String get addressLine5 => _addressLine5;
  @IncludeSchema(isOptional: true)
  String get phoneNumber => _phoneNumber;
  @IncludeSchema(isOptional: true)
  String get faxNumber => _faxNumber;
  @IncludeSchema()
  bool get isEmailedConfirmation => _isEmailedConfirmation;
  @IncludeSchema()
  bool get isEmailedRemittance => _isEmailedRemittance;
  

  void mergeJson (Map jsonMap) {
    this.name = jsonMap["name"];
    this.quickbooksName = jsonMap["quickbooksName"];
    this.termsRef = jsonMap["termsRef"];
    this.terms = jsonMap["terms"];
    this.remittanceEmail = jsonMap["remittanceEmail"];
    this.confirmationEmail = jsonMap["confirmationEmail"];
    this.addressLine1 = jsonMap["addressLine1"];
    this.addressLine2 = jsonMap["addressLine2"];
    this.addressLine3 = jsonMap["addressLine3"];
    this.addressLine4 = jsonMap["addressLine4"];
    this.addressLine5 = jsonMap["addressLine5"];
    this.phoneNumber = jsonMap["phoneNumber"];
    this.faxNumber = jsonMap["faxNumber"];
    this.isEmailedConfirmation = jsonMap["isEmailedConfirmation"];
    this.isEmailedRemittance = jsonMap["isEmailedRemittance"];
    super.mergeJson(jsonMap);
  }

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
                                          "phoneNumber": phoneNumber,
                                          "isEmailedConfirmation": isEmailedConfirmation,
                                          "isEmailedRemittance": isEmailedRemittance });
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
  
  set isEmailedRemittance (bool t) { 
    if (t != _isEmailedRemittance) {
      _isEmailedRemittance = t;
      requiresDatabaseSync();
    }
  }
  set isEmailedConfirmation (bool t) { 
    if (t != _isEmailedConfirmation) {
      _isEmailedConfirmation = t;
      requiresDatabaseSync();
    }
  }
  
  Supplier._create (int ID, String name):super(ID, name) {
    this.name = name;
  }
  Supplier.fromJson (Map params):super.fromJson(params);


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


  Future<List<bool>> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer<bool>();

    List<Future> waitingFor = new List<Future>();
    waitingFor.add(c.future);
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO suppliers (supplierName, quickbooksName, termsRef, terms,"
                         "remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1,"
                         "addressLine2, addressLine3, addressLine4, addressLine5, isEmailedRemittance, isEmailedConfirmation, active)"
                         "VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                          [name, quickbooksName, termsRef, terms,
                           remittanceEmail, confirmationEmail, phoneNumber, faxNumber,
                           addressLine1, addressLine2, addressLine3, addressLine4, addressLine5,
                           isEmailedRemittance ? 1 : 0, isEmailedConfirmation ? 1 : 0, isActive ? 1 : 0]).then((Results res) {
              if (res.insertId != 0) {
                c.complete(true);
                this._firstInsert(res.insertId);
                ffpServerLog.info("Created new supplier $name");

              }
              else {
                c.completeError("Unspecified mysql error");
                ffpServerLog.warning("Unspecified mysql error");
              }
          }).catchError((e) {
            c.completeError(e);

            ffpServerLog.warning("Unspecified mysql $e");
          });
    }
    else {
      dbh.prepareExecute("UPDATE suppliers SET supplierName=?, quickbooksName=?, termsRef=?, terms=?, remittanceEmail=?, " 
                         "confirmationEmail=?, phoneNumber=?, faxNumber=?, addressLine1=?, addressLine2=?, addressLine3=?, "
                         "addressLine4=?, addressLine5=?, isEmailedRemittance=?, isEmailedConfirmation=?, active=? WHERE ID=?",
                          [name, quickbooksName, termsRef, terms, remittanceEmail,
                           confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, 
                           addressLine4, addressLine5, isEmailedRemittance ? 1 : 0, isEmailedConfirmation ? 1 : 0, isActive ? 1 : 0, ID]).then((Results res) {
            if (res.affectedRows <= 1) {
              this.synced();
               c.complete(true);
            }
            else {
              c.completeError("Tried updating supplier however ${res.affectedRows} rows affected does not equal one.");
            }
          }).catchError((e) {
            c.completeError(e);

            ffpServerLog.warning("Unspecified mysql $e");
          });
    }
    

    Completer quickbooksInt = new Completer();
    if (this.quickbooksName == null || this.quickbooksName.isEmpty) {
      ffpServerLog.info("Inserting supplier into quickbooks..."); 
      QBVendor qbv = new QBVendor();
      qbv.name = this.name;
      qbv.email = this.remittanceEmail;
      qbv.phoneNumber = this.phoneNumber;
      qbv.faxNumber = this.faxNumber;
      qbv.vendorAddress = new QBAddress();
      qbv.vendorAddress.lines[0] = this.addressLine1;
      qbv.vendorAddress.lines[1] = this.addressLine2;
      qbv.vendorAddress.lines[2] = this.addressLine3;
      qbv.vendorAddress.lines[3] = this.addressLine4;
      qbv.vendorAddress.lines[4] = this.addressLine5;
      qbv.vendorAddress.city = "";
      qbv.vendorAddress.country = "";
      qbv.vendorAddress.note = "";
      qbv.vendorAddress.postalCode = "";
      qbv.vendorAddress.state = "";
      qbv.isActive = isActive;
      qbv.insert(qbc).then((e) {
        if (e) {
            this.quickbooksName = qbv.listID;

            quickbooksInt.complete(true);
          }
          else quickbooksInt.complete(false);
        }).catchError((error) => quickbooksInt.completeError(error));
    }
    else {
      ffpServerLog.info("Updating supplier in quickbooks");
      QBVendor.fetchByID(this.quickbooksName, qbc).then((QBVendor qbv)  {
        qbv.name = this.name;
              qbv.email = this.remittanceEmail;
              qbv.phoneNumber = this.phoneNumber;
              qbv.faxNumber = this.faxNumber;
              qbv.vendorAddress = new QBAddress();
              qbv.vendorAddress.lines[0] = this.addressLine1;
              qbv.vendorAddress.lines[1] = this.addressLine2;
              qbv.vendorAddress.lines[2] = this.addressLine3;
              qbv.vendorAddress.lines[3] = this.addressLine4;
              qbv.vendorAddress.lines[4] = this.addressLine5;
              qbv.vendorAddress.city = "";
              qbv.vendorAddress.country = "";
              qbv.vendorAddress.note = "";
              qbv.vendorAddress.postalCode = "";
              qbv.vendorAddress.state = "";
              qbv.isActive = isActive;
        qbv.update(qbc).then((e) {
          if (e) {
            quickbooksInt.complete(true);
          }
          else quickbooksInt.complete(false);
        }).catchError((error) => quickbooksInt.completeError(error));
      });
    }
    waitingFor.add(quickbooksInt.future);
    return Future.wait(waitingFor);
  }

  static exists (String name) => Syncable.exists(Supplier, name);
  static get (String name) => Syncable.get(Supplier, name);


  /// Initializes the suppliers for use by retreiving them from the database
  static Future<bool> init () {
    Completer c = new Completer();
    ffpServerLog.info("Loading supplier list...");
    dbHandler.query("SELECT ID, supplierName, quickbooksName, terms, remittanceEmail,"
                    "confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, "
                    "addressLine3, addressLine4, addressLine5, termsRef, isEmailedRemittance, isEmailedConfirmation, active FROM suppliers").then((Results results){
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
        sup._isEmailedRemittance = row[14] == 1;
        sup._isEmailedConfirmation = row[15] == 1;
        sup._isActive = row[16] == 1;
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