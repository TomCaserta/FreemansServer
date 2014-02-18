part of FreemansServer;

class Customer extends SyncCachable<Customer> {
  /*
   * GETTERS AND SETTERS. ANYTHING CHANGED ON THE SETTERS WILL BE REFLECTED IN THE DATABASE AUTOMATICALLY WHEN RESYNCED   
   */
  String _name;
  String _quickbooksName;
  String _billto1;
  String _billto2;
  String _billto3;
  String _billto4;
  String _billto5;
  String _shipto1;
  String _shipto2;
  String _shipto3;
  String _shipto4;
  String _shipto5;
  String _termsRef;
  int _terms;
  String _invoiceEmail;
  bool _isEmailedInvoice = true;
  String _confirmationEmail;
  bool _isEmailedConfirmation = true;
  String _faxNumber;
  String _phoneNumber;

  String get name => _name;
  String get quickbooksName => _quickbooksName;
  String get billto1 => _billto1;
  String get billto2 => _billto2;
  String get billto3 => _billto3;
  String get billto4 => _billto4;
  String get billto5 => _billto5;
  String get shipto1 => _shipto1;
  String get shipto2 => _shipto2;
  String get shipto3 => _shipto3;
  String get shipto4 => _shipto4;
  String get shipto5 => _shipto5;
  String get termsRef => _termsRef;
  int get terms => _terms;
  String get invoiceEmail => _invoiceEmail;
  bool get isEmailedInvoice => _isEmailedInvoice;
  String get confirmationEmail => _confirmationEmail;
  bool get isEmailedConfirmation => _isEmailedConfirmation;
  String get faxNumber => _faxNumber;
  String get phoneNumber => _phoneNumber;

  Map<String, dynamic> toJson () { 
          return super.toJson()..addAll({ "name": name,
                                          "quickbooksName": quickbooksName,
                                          "billto1": billto1,
                                          "billto2": billto2,
                                          "billto3": billto3,
                                          "billto4": billto4,
                                          "billto5": billto5,
                                          "shipto1": shipto1,
                                          "shipto2": shipto2,
                                          "shipto3": shipto3,
                                          "shipto4": shipto4,
                                          "shipto5": shipto5,
                                          "termsRef": termsRef,
                                          "terms": terms,
                                          "invoiceEmail": invoiceEmail,
                                          "isEmailedInvoice": isEmailedInvoice,
                                          "confirmationEmail": confirmationEmail,
                                          "isEmailedConfirmation": isEmailedConfirmation,
                                          "faxNumber": faxNumber,
                                          "phoneNumber": phoneNumber });
  }
  
  set name ( String name) {
    if (name != _name) {
      _name = name;
      requiresDatabaseSync();
    }
  }

  set quickbooksName ( String quickbooksName) {
    if (quickbooksName != _quickbooksName) {
      _quickbooksName = quickbooksName;
      requiresDatabaseSync();
    }
  }

  set billto1 ( String billto1) {
    if (billto1 != _billto1) {
      _billto1 = billto1;
      requiresDatabaseSync();
    }
  }

  set billto2 ( String billto2) {
    if (billto2 != _billto2) {
      _billto2 = billto2;
      requiresDatabaseSync();
    }
  }

  set billto3 ( String billto3) {
    if (billto3 != _billto3) {
      _billto3 = billto3;
      requiresDatabaseSync();
    }
  }

  set billto4 ( String billto4) {
    if (billto4 != _billto4) {
      _billto4 = billto4;
      requiresDatabaseSync();
    }
  }

  set billto5 ( String billto5) {
    if (billto5 != _billto5) {
      _billto5 = billto5;
      requiresDatabaseSync();
    }
  }

  set shipto1 ( String shipto1) {
    if (shipto1 != _shipto1) {
      _shipto1 = shipto1;
      requiresDatabaseSync();
    }
  }

  set shipto2 ( String shipto2) {
    if (shipto2 != _shipto2) {
      _shipto2 = shipto2;
      requiresDatabaseSync();
    }
  }

  set shipto3 ( String shipto3) {
    if (shipto3 != _shipto3) {
      _shipto3 = shipto3;
      requiresDatabaseSync();
    }
  }

  set shipto4 ( String shipto4) {
    if (shipto4 != _shipto4) {
      _shipto4 = shipto4;
      requiresDatabaseSync();
    }
  }

  set shipto5 ( String shipto5) {
    if (shipto5 != _shipto5) {
      _shipto5 = shipto5;
      requiresDatabaseSync();
    }
  }  
  set termsRef (String termsRef) {
    if (termsRef != _termsRef) {
      _termsRef = termsRef;
      requiresDatabaseSync();
    }
  }

  set terms ( int terms) {
    if (terms != _terms) {
      _terms = terms;
      requiresDatabaseSync();
    }
  }

  set invoiceEmail ( String invoiceEmail) {
    if (invoiceEmail != _invoiceEmail) {
      _invoiceEmail = invoiceEmail;
      requiresDatabaseSync();
    }
  }

  set isEmailedInvoice ( bool isEmailedInvoice) {
    if (isEmailedInvoice != _isEmailedInvoice) {
      _isEmailedInvoice = isEmailedInvoice;
      requiresDatabaseSync();
    }
  }

  set confirmationEmail ( String confirmationEmail) {
    if (confirmationEmail != _confirmationEmail) {
      _confirmationEmail = confirmationEmail;
      requiresDatabaseSync();
    }
  }

  set isEmailedConfirmation ( bool isEmailedConfirmation) {
    if (isEmailedConfirmation != _isEmailedConfirmation) {
      _isEmailedConfirmation = isEmailedConfirmation;
      requiresDatabaseSync();
    }
  }

  set faxNumber ( String faxNumber) {
    if (faxNumber != _faxNumber) {
      _faxNumber = faxNumber;
      requiresDatabaseSync();
    }
  }

  set phoneNumber ( String phoneNumber) {
    if (phoneNumber != _phoneNumber) {
      _phoneNumber = phoneNumber;
      requiresDatabaseSync();
    }
  }
  
  /// Constructor for a new Customer if it doesnt already exist
  Customer._create (int ID, String name, [int this._terms = 42]):super(ID, name) {
      this._name = name;
  }

  /// Factory constructor checks if a customer name already exists, if it doesnt it returns a new Customer object.
  factory Customer (int ID, String name, [int terms = 42]) {
    if (exists(name)) {
      ffpServerLog.severe("Duplicate customer Entry Found... $name");
      return get(name);
    }
    else {
      return new Customer._create(ID, name, terms);
    }
  }
  
  /// Checks if the customer name already exists in the program
  static exists (String name) => SyncCachable.exists(Customer, name);
  
  /// Retreives a Customer object from the database by the name
  static get (String name) => SyncCachable.get(Customer, name);

  /// Returns a List containing all lines of the billing address for the scustomer
  List<String> getFullBillingAddress () {
    return [billto1, billto2, billto3, billto4, billto5];
  }

  /// Returns a List containing all lines of the shipping address for the scustomer
  List<String> getFullShippingAddress () {
    return [shipto1, shipto2, shipto3, shipto4, shipto5];
  }


  /// Syncs any changes made to the fields.
  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
     if (this.isNew) {
        dbh.prepareExecute("INSERT INTO customers (customerName, invoiceEmail, confirmationEmail, quickbooksName, billto1, billto2, billto3, billto4, billto5, shipto1, shipto2,"
                            "shipto3, shipto4, shipto5, termsRef, terms, faxNumber, phoneNumber, isEmailedInvoice, isEmailedConfirmation, active) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)",
                            [name, invoiceEmail, confirmationEmail, quickbooksName, billto1, billto2, billto3, billto4, billto5, shipto1, shipto2, shipto3, shipto4, shipto5, termsRef,
                             terms, faxNumber, phoneNumber, (isEmailedInvoice ? 1 : 0), (isEmailedConfirmation ? 1 : 0), (isActive ? 1 : 0)])
           .then((Results res) {
             if (res.insertId != 0) {
               _firstInsert(res.insertId);
               c.complete(true);
             }
             else {
               c.completeError("Unspecified mysql error");
             }
           }).catchError((e) => c.completeError(e));
     }
     else {
       dbh.prepareExecute("UPDATE customers SET customerName=?, invoiceEmail=?, confirmationEmail=?, quickbooksName=?, billto1=?, billto2=?, billto3=?, billto4=?, billto5=?, shipto1=?, shipto2=?,"
           "shipto3=?, shipto4=?, shipto5=?, termsRef=?, terms=?, faxNumber=?, phoneNumber=?, isEmailedInvoice=?, isEmailedConfirmation=?, active=? WHERE ID=?",
           [name, invoiceEmail, confirmationEmail, quickbooksName, billto1, billto2, billto3, billto4, billto5, shipto1, shipto2, shipto3, shipto4, shipto5, termsRef,
            terms, faxNumber, phoneNumber, (isEmailedInvoice ? 1 : 0), (isEmailedConfirmation ? 1 : 0), (isActive ? 1 : 0), ID])
           .then((Results res) { 
             if (res.affectedRows <= 1) {
               synced();
               c.complete(true);
             }
             else {
               c.completeError("Query affected ${res.affectedRows} instead of just one.");
             }
           })
           .catchError((err) => c.completeError(err));
     }
     return c.future;
  }


  /// Initializes the customers for use by retreiving them from the database
  static Future<bool> init () {
    Completer c = new Completer();
    ffpServerLog.info("Loading customer list...");
    dbHandler.query("SELECT ID, customerName, invoiceEmail, confirmationEmail, quickbooksName, billto1, billto2, billto3, billto4, billto5, shipto1, shipto2, shipto3, shipto4, shipto5, terms, faxNumber, phoneNumber, isEmailedInvoice, isEmailedConfirmation, active, termsRef FROM customers").then((Results results){
      results.listen((Row row) {
        Customer cust = new Customer(row[0], row[1], row[15]);
        cust._invoiceEmail = row[2];
        cust._confirmationEmail = row[3];
        cust._quickbooksName = row[4];
        cust._billto1 = row[5];
        cust._billto2 = row[6];
        cust._billto3 = row[7];
        cust._billto4 = row[8];
        cust._billto5 = row[9];
        cust._shipto1 = row[10];
        cust._shipto2 = row[11];
        cust._shipto3 = row[12];
        cust._shipto4 = row[13];
        cust._shipto5 = row[14];
        cust._faxNumber = row[16];
        cust._phoneNumber = row[17];
        cust._isEmailedInvoice = (row[18] != 0 ? true : false);
        cust._isEmailedConfirmation = (row[19] != 0 ? true : false);
        cust._isActive = (row[20] != 0 ? true : false);
        cust._termsRef = row[21];
      },
      onDone: () {
        c.complete(true);
        ffpServerLog.info("Customer list loaded.");
      },
      onError: (e) {
        c.completeError("Could not load customer list from database: $e");
        ffpServerLog.severe("Could not load customer list from database", e);
      });
    }).catchError((e) {
      c.completeError("Could not load customer list from database: $e");
      ffpServerLog.severe("Could not load customer list from database", e);
    });
    return c.future;
  }
}