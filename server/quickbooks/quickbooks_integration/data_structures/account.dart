part of QuickbooksIntegration;

class QBAccount extends QBModifiable {
  bool isActive;
  DateTime timeCreated;
  DateTime timeModified;
  String name;
  String parentID;  
  String fullName;
  String editSequence;
  int subLevel;
  AccountType accountType;
  bool isTaxAccount;
  String accountNumber;
  SpecialAccountType specialAccountType;
  String bankNumber;
  String salesTaxCodeRefId;
  String description;
  num balance;
  num totalBalance;
  String taxLineID;
  CashFlowClassification cashFlowClassification;
  String currencyRef;
  List<DataExtRet> dataExtRet = new List<DataExtRet>();
  
  Future<bool> insert(QuickbooksConnector qbc) {
    
  }
  
  Future<bool> update(QuickbooksConnector qbc) {
    
  }
}