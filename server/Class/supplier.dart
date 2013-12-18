part of FreemansServer;

class Supplier extends SyncCachable<Supplier> {
  String name;
  String quickbooksName;
  int terms;
  String remittanceEmail;
  String confirmationEmail;
  String addressLine1;
  String addressLine2;
  String addressLine3;
  String addressLine4;
  String addressLine5;
  String phoneNumber;
  String faxNumber;
  Supplier._create (int ID, String name):super(ID, name) {
    this.name = name;
  }
  
  factory Supplier (int ID, String name) {
    if (!exists(name)) {
      return new Supplier._create(ID, name);
    }
    else {
      Logger.root.severe("Duplicate Supplier Entry Found... $name");
      return get(name);
    }
  }
  
  /// Returns a List containing all lines of the address for the supplier.
  List<String> getFullAddress () {
    return [addressLine1, addressLine2, addressLine3, addressLine4, addressLine5];
  }
   

  Future<bool> updateDatabase(DatabaseHandler dbh) {
    Completer c = new Completer<bool>();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO suppliers (supplierName, quickbooksName, terms, remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, addressLine4, addressLine5) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", 
          [name, quickbooksName, terms, remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, addressLine4, addressLine5]).then((Results res) {
              if (res.insertId != 0) {
                c.complete(true);
                Logger.root.info("Created new supplier $name");
  
              }
              else {
                c.completeError("Unspecified mysql error");
                Logger.root.severe("Unspecified mysql error");
              }
          }).catchError((e) { 
            c.completeError(e);
            Logger.root.severe("Error whilst creating supplier $name :", e);
          });
    }
    else {
      
    }
    return c.future;
  }
  
  static exists (String name) => SyncCachable.exists(Supplier, name);
  static get (String name) => SyncCachable.exists(Supplier, name);
  
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
    sup.updateDatabase(dbHandler).then((bool done) {
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
    Logger.root.info("Loading supplier list...");
    dbHandler.query("SELECT ID, supplierName, quickbooksName, terms, remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, addressLine4, addressLine5 FROM suppliers").then((Results results){
      results.listen((Row row) { 
        Supplier sup = new Supplier(row[0], row[1]);
        sup.quickbooksName = row[2];
        sup.terms = row[3];
        sup.remittanceEmail = row[4];
        sup.confirmationEmail = row[5];
        sup.phoneNumber = row[6];
        sup.faxNumber = row[7];
        sup.addressLine1 = row[8];
        sup.addressLine2 = row[9];
        sup.addressLine3 = row[10];
        sup.addressLine4 = row[11];
        sup.addressLine5 = row[12];
      },
      onDone: () { 
        c.complete(true);
        Logger.root.info("Supplier list loaded.");
      }, 
      onError: (e) {
        c.completeError("Could not load supplier list from database: $e");
        Logger.root.severe("Could not load supplier list from database", e);
      });
    }).catchError((e) { 
      c.completeError("Could not load supplier list from database: $e");
      Logger.root.severe("Could not load supplier list from database", e);
    });
    return c.future;
  }
}