part of FreemansServer;

class Supplier {
  String name;
  String quickbooksName;
  int terms;
  String customerEmail;
  String addressLine1;
  String addressLine2;
  String addressLine3;
  String addressLine4;
  String addressLine5;
  String phoneNumber;
  String faxNumber;
  Supplier.create (String name, [int terms = 42]) {
    
  }
  factory Supplier (String name, [int terms = 42]) {
    if (!exists(name)) {
      suppliers[name] = new Supplier.create(name);
    }
    else {
      Logger.root.log(Level.SEVERE,"Duplicate Supplier Entry Found... $name");
    }
    return suppliers[name];
  }
  
  
  List<String> getFullAddress () {
    return [addressLine1,addressLine2,addressLine3,addressLine4,addressLine5];
  }
   
  
  // Static Methods
  static Map<String, Supplier> suppliers = new Map<String, Supplier>();
  
  static bool exists(String name) {
    return suppliers.containsKey(name);
  }
  
  static Supplier get (String name) {
    return suppliers[name];
  }
  
  static void init () {
    Logger.root.log(Level.INFO, "Loading supplier list...");
    
  }
}