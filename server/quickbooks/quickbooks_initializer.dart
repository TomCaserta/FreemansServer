part of FreemansServer;


class QuickbooksInitializer {
  
  static Future<bool> _initializeSuppliers () {
    
  }

  static Future<bool> _initializeCustomers () {
    
  }

  static Future<bool> _initializeItems () {
    
  }
  
  static Future<bool> init () {
    Completer c = new Completer();
    qbHandler.openConnection(GLOBAL_CONFIG["qb_app_ID"], GLOBAL_CONFIG["qb_app_name"]).then((bool connected) {
      if (connected) {
        String companyFileName = ""; // Empty string specifies current open file.
        qbHandler.beginSession(companyFileName, QBFileMode.doNotCare).then((String ticketID) {
          c.complete(true);
          
        });
      }
    });
    return c.future;
  }
  
}