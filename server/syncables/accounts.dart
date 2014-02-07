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
    return { "listID": this.account.listID, "timeCreated": this.account.timeCreated, "timeModified": this.account.timeModified, "name": this.account.name, "parentID": this.account.parentID, "fullName": this.account.fullName, "editSequence": this.account.editSequence, "subLevel": this.account.subLevel, "accountType": this.account.accountType, "isTaxAccount": this.account.isTaxAccount, "accountNumber": this.account.accountNumber, "specialAccountType": this.account.specialAccountType, "bankNumber": this.account.bankNumber, "salesTaxCodeRefId": this.account.salesTaxCodeRefId, "description": this.account.description, "balance": this.account.balance, "totalBalance": this.account.totalBalance, "taxLineID": this.account.taxLineID, "cashFlowClassification": this.account.cashFlowClassification, "currencyRef": this.account.currencyRef, "dataExtRet": this.account.dataExtRet, "childAccounts": this.childAccounts};
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
         if (a.account != null && a.account.parentID.isNotEmpty) {
           Account parent = SyncCachable.get(Account, a.account.parentID);
           parent.childAccounts.add(a);
         }
      });
      ffpServerLog.info("Accounts list loaded...");
      c.complete(true);
    });  
    return c.future;
  }
}
