part of FreemansServer;

class Account extends SyncCachable<Account> {
  QBAccount account;
  String listID;
  List<Account> childAccounts = [];
  
  Account(String listID, [bool isNew = false]):super((isNew ? 0 : -1), listID) {
    this.listID = listID;
  }
  
  String toString () {
    return toJson().toString();
  }
  Map<String, dynamic> toJson () {
 
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
         if (a.account != null && a.account.parentRef.listID.isNotEmpty) {
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
