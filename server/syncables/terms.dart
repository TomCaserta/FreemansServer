part of FreemansServer;

class Terms extends SyncCachable<Terms> {
  DateTime timeCreated;
  DateTime timeModified;
  String editSequence;
  String name;
  bool isActive;
  String stdDueDays;
  String stdDiscountDays;
  String discountPct;
  
  Terms(String listID, [bool isNew = false]):super((isNew ? 0 : -1), listID);
  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
     if (isNew) {
       
     }
     else {
       // TODO: Account Update
       return;
     }
   }
  static Future<bool> init () {
    ffpServerLog.info("Loading Accounts list from quickbooks");
    Completer c = new Completer();
    QBAccountsList qbl = new QBAccountsList(qbHandler);
    qbl.forEach().listen((QBAccount data) { 
        Account tempAccount = new Account(data.listID);
        tempAccount.account = data;
    }, onDone: () { 
      SyncCachable.getVals(Account).forEach((Account a) {
         if (a.account != null && a.account.parentRef != null && a.account.parentRef.listID != null) {
           Account parent = SyncCachable.get(Account, a.account.parentRef.listID);
           parent.childAccounts.add(a);
         }
      });
      ffpServerLog.info("Accounts list loaded...");
      c.complete(true);
    });  
    return c.future;
  }
  
}