part of FreemansServer;

class Customer {
  String name;
  String quickbooksName;
  String billto1;
  String billto2;
  String billto3;
  String billto4;
  String billto5;
  String shipto1;
  String shipto2;
  String shipto3;
  String shipto4;
  String shipto5;
  int terms;
  String invoiceEmail;
  bool isEmailedInvoice;
  String confirmationEmail;
  bool isEmailedConfirmation;
  String faxNumber;
  String phoneNumber;
  Customer.create (String this.name, [int this.terms = 42]) {
    
  }
  factory Customer (String name, [int terms = 42]) {
    if (!exists(name)) {
      customers[name] = new Customer.create(name);
    }
    else {
      Logger.root.severe("Duplicate customer Entry Found... $name");
    }
    return customers[name];
  }
  
  
  
  /// Returns a List containing all lines of the billing address for the scustomer
  List<String> getFullBillingAddress () {
    return [billto1, billto2, billto3, billto4, billto5];
  }
  
  /// Returns a List containing all lines of the shipping address for the scustomer
  List<String> getFullShippingAddress () {
    return [shipto1, shipto2, shipto3, shipto4, shipto5];
  }
  
  // Static Methods
  static Map<String, Customer> customers = new Map<String, Customer>();
  
  /// Check if the customer already exists in the map
  static bool exists(String name) {
    return customers.containsKey(name);
  }
  
  /// Retreives the customer from the map
  static Customer get (String name) {
    return customers[name];
  }
  
  
  /// Initializes the customers for use by retreiving them from the database
  static void init () {
    Logger.root.info("Loading customer list...");
  }
}