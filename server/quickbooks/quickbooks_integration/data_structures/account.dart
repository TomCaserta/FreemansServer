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
    listID = getXmlElement(data, "ListID").text;
    isActive = getXmlElement(data, "IsActive", optional: true).text.toUpperCase() == "TRUE";
    timeCreated = DateTime.parse(getXmlElement(data, "TimeCreated").text);
    timeModified = DateTime.parse(getXmlElement(data, "TimeModified").text);
    editSequence = getXmlElement(data, "EditSequence").text;
    name = getXmlElement(data, "Name").text;
    fullName = getXmlElement(data, "FullName").text;
    parentRef = new QBRef.parseFromListXml(getXmlElement(data, "ParentRef", optional: true));
    
    subLevel = int.parse(getXmlElement(data, "SubLevel").text, onError: (e) { return null; });
    accountType = EnumString.get(AccountType, getXmlElement(data, "AccountType").text);
    specialAccountType = EnumString.get(SpecialAccountType, getXmlElement(data, "SpecialAccountType", optional: true).text);
    isTaxAccount = getXmlElement(data, "IsTaxAccount", optional: true).text.toUpperCase() == "TRUE";
    accountNumber = getXmlElement(data, "AccountNumber", optional: true).text;
    bankNumber = getXmlElement(data, "BankNumber", optional: true).text;
    salesTaxCodeRef = new QBRef.parseFromListXml(getXmlElement(data, "SalesTaxCodeRef", optional: true));
    description = getXmlElement(data, "Desc").text;
    balance = num.parse(getXmlElement(data, "Balance", optional: true).text, (e) { return null; });
    totalBalance = num.parse(getXmlElement(data, "TotalBalance", optional: true).text, (e) { return null; });
    cashFlowClassification = EnumString.get(CashFlowClassification, getXmlElement(data, "CashFlowClassification", optional: true).text);
    currencyRef = new QBRef.parseFromListXml(getXmlElement(data, "CurrencyRef", optional: true));
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