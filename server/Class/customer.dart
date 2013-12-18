part of FreemansServer;

class Customer extends SyncCachable<Customer> {
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
  Customer.create (int ID, String this.name, [int this.terms = 42]):super(ID);
  factory Customer (int ID, String name, [int terms = 42]) {
    if (exists(ID)) {
      return get(ID);
    }
    else Logger.root.severe("Duplicate customer Entry Found... $name");
  }
  static exists (int ID) => SyncCachable.exists(Customer, ID);
  static get (int ID) => SyncCachable.exists(Customer, ID);
  
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
    c.complete(true);
    return c.future;
  }
}