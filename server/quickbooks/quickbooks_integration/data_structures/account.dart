part of QuickbooksIntegration;

class QBAccount extends QBModifiable {
  bool isActive;
  DateTime timeCreated;
  DateTime timeModified;
  String editSequence;
  String name;  
  String fullName;
  QBRef parentRef;
  int subLevel;
  AccountType accountType;
  SpecialAccountType specialAccountType;
  bool isTaxAccount;
  String accountNumber;
  String bankNumber;
  QBRef salesTaxCodeRef;
  String description;
  num balance;
  num totalBalance;
  CashFlowClassification cashFlowClassification;
  QBRef currencyRef;
  List<DataExtRet> dataExtRet = new List<DataExtRet>();
  
  Map toJson () { 
    return { "listID": listID, "isActive": isActive,  "timeCreated": timeCreated.millisecondsSinceEpoch,  "timeModified": timeModified.millisecondsSinceEpoch,  "editSequence": editSequence, "name": name, "fullName": fullName,  "parentRef": parentRef,  "subLevel": subLevel,  "accountType": accountType,  "specialAccountType": specialAccountType,  "isTaxAccount": isTaxAccount,  "accountNumber": accountNumber,  "bankNumber": bankNumber,  "salesTaxCodeRef": salesTaxCodeRef,  "description": description,  "balance": balance,  "totalBalance": totalBalance, "cashFlowClassification": cashFlowClassification,  "currencyRef": currencyRef };
  }
  String toString () {
    return toJson().toString();
  }
  
  QBAccount.parseFromListXml (XmlElement data) {
    listID = getQbxmlContainer(data, "ListID").text;
    isActive = getQbxmlContainer(data, "IsActive", optional: true).boolean;
    timeCreated = getQbxmlContainer(data, "TimeCreated").date;
    timeModified = getQbxmlContainer(data, "TimeModified").date;
    editSequence = getQbxmlContainer(data, "EditSequence").text;
    name = getQbxmlContainer(data, "Name").text;
    fullName = getQbxmlContainer(data, "FullName").text;
    parentRef = new QBRef.parseFromListXml(getQbxmlContainer(data, "ParentRef", optional: true));
    subLevel = getQbxmlContainer(data, "SubLevel").integer;
    accountType = EnumString.get(AccountType, getQbxmlContainer(data, "AccountType").text);
    specialAccountType = EnumString.get(SpecialAccountType, getQbxmlContainer(data, "SpecialAccountType", optional: true).text);
    isTaxAccount = getQbxmlContainer(data, "IsTaxAccount", optional: true).boolean;
    accountNumber = getQbxmlContainer(data, "AccountNumber", optional: true).text;
    bankNumber = getQbxmlContainer(data, "BankNumber", optional: true).text;
    salesTaxCodeRef = new QBRef.parseFromListXml(getQbxmlContainer(data, "SalesTaxCodeRef", optional: true));
    description = getQbxmlContainer(data, "Desc").text;
    balance = getQbxmlContainer(data, "Balance", optional: true).number;
    totalBalance = getQbxmlContainer(data, "TotalBalance", optional: true).number;
    cashFlowClassification = EnumString.get(CashFlowClassification, getQbxmlContainer(data, "CashFlowClassification", optional: true).text);
    currencyRef = new QBRef.parseFromListXml(getQbxmlContainer(data, "CurrencyRef", optional: true));
    XmlCollection dataExtRetList = data.query("DataExtRet");
    dataExtRetList.forEach((XmlElement dataExtEl) {          
      dataExtRet.add(new DataExtRet.parseFromListXml(dataExtEl));
    });   
  }
  
  
  Future<bool> insert(QuickbooksConnector qbc) {
    
  }
  
  Future<bool> update(QuickbooksConnector qbc) {
    
  }
}