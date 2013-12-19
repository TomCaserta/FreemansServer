part of FreemansServer;

class Customer extends SyncCachable<Customer> {
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
  int _terms;
  String _invoiceEmail;
  bool _isEmailedInvoice;
  String _confirmationEmail;
  bool _isEmailedConfirmation;
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
  int get terms => _terms;
  String get invoiceEmail => _invoiceEmail;
  bool get isEmailedInvoice => _isEmailedInvoice;
  String get confirmationEmail => _confirmationEmail;
  bool get isEmailedConfirmation => _isEmailedConfirmation;
  String get faxNumber => _faxNumber;
  String get phoneNumber => _phoneNumber;

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


  Customer.create (int ID, String name, [int this._terms = 42]):super(ID, name) {
      this._name = name;
  }

  factory Customer (int ID, String name, [int terms = 42]) {
    if (exists(name)) {
      return get(name);
    }
    else Logger.root.severe("Duplicate customer Entry Found... $name");
  }
  static exists (String name) => SyncCachable.exists(Customer, name);
  static get (String name) => SyncCachable.get(Customer, name);

  /// Returns a List containing all lines of the billing address for the scustomer
  List<String> getFullBillingAddress () {
    return [billto1, billto2, billto3, billto4, billto5];
  }

  /// Returns a List containing all lines of the shipping address for the scustomer
  List<String> getFullShippingAddress () {
    return [shipto1, shipto2, shipto3, shipto4, shipto5];
  }

  // Static Methods

  /// Initializes the customers for use by retreiving them from the database
  static Future<bool> init () {
    Completer c = new Completer();
    Logger.root.info("Loading customer list...");
    dbHandler.query("SELECT ID, customerName, invoiceEmail, confirmationEmail, quickbooksName, billto1, billto2, billto3, billto4, billto5, shipto1, shipto2, shipto3, shipto4, shipto5, terms, faxNumber, phoneNumber FROM customers").then((Results results){
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
      },
      onDone: () {
        c.complete(true);
        Logger.root.info("Customer list loaded.");
      },
      onError: (e) {
        c.completeError("Could not load customer list from database: $e");
        Logger.root.severe("Could not load customer list from database", e);
      });
    }).catchError((e) {
      c.completeError("Could not load customer list from database: $e");
      Logger.root.severe("Could not load customer list from database", e);
    });
    return c.future;
  }
}