part of FreemansServer;

class Supplier {
  int ID;
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
  Supplier.create (String this.name) {
    
  }
  factory Supplier (String name) {
    if (!exists(name)) {
      suppliers[name] = new Supplier.create(name);
    }
    else {
      Logger.root.severe("Duplicate Supplier Entry Found... $name");
    }
    return suppliers[name];
  }
  
  /// Returns a List containing all lines of the address for the supplier.
  List<String> getFullAddress () {
    return [addressLine1, addressLine2, addressLine3, addressLine4, addressLine5];
  }
   
  
  // Static Methods
  static Map<String, Supplier> suppliers = new Map<String, Supplier>();
  
  /// Check if the supplier already exists in the map
  static bool exists(String name) {
    return suppliers.containsKey(name);
  }
  
  /// Retreives the supplier from the map
  static Supplier get (String name) {
    return suppliers[name];
  }
  
  /// Creates a new supplier, inserting it into the database and sending it to quickbooks...
  static Future<Supplier> createNew (String name, String quickbooksName, { int terms: 42, String remittanceEmail: "", String confirmationEmail: "", String addressLine1: "", String addressLine2: "", String addressLine3: "", String addressLine4: "", String addressLine5: "", String phoneNumber: "", String faxNumber: "" }) {
    Completer c = new Completer<Supplier>();
    if (!exists(name)) {
      dbHandler.prepareExecute("INSERT INTO suppliers (supplierName, quickbooksName, terms, remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, addressLine4, addressLine5) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)", 
          [name, quickbooksName, terms, remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, addressLine4, addressLine5]).then((Results res) {
              if (res.insertId != 0) {
                Supplier sup = new Supplier(name);
                sup.ID = res.insertId;
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
                c.complete(sup);
                Logger.root.info("Created new supplier $name");
  
              }
              else {
                Logger.root.severe("Unspecified mysql error");
              }
          }).catchError((e) { 
            Logger.root.severe("Error whilst creating supplier $name :", e);
          });
    }
    else {
      c.completeError("Supplier already exists");
      Logger.root.warning("Attempt to create duplicate supplier");
    }
    return c.future;
  }
  
  /// Initializes the suppliers for use by retreiving them from the database
  static void init () {
    Logger.root.info("Loading supplier list...");
    dbHandler.query("SELECT ID, supplierName, quickbooksName, terms, remittanceEmail, confirmationEmail, phoneNumber, faxNumber, addressLine1, addressLine2, addressLine3, addressLine4, addressLine5 FROM suppliers").then((Results results){
      results.listen((Row row) { 
        Supplier sup = new Supplier(row[1]);
        sup.ID = row[0];
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
        Logger.root.info("Supplier list loaded.");
      }, 
      onError: (e) {
        Logger.root.severe("Could not load supplier list from database", e);
      });
    }).catchError((e) { 
      Logger.root.severe("Could not load supplier list from database", e);
    });
  }
}