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
  QBRef taxLineRef;
  CashFlowClassification cashFlowClassification;
  QBRef currencyRef;
  List<DataExtRet> dataExtRet = new List<DataExtRet>();
  
  QBAccount.parseFromListXml (XmlElement data) {
    listID = listID;
    timeCreated = DateTime.parse(getXmlElement(data, "TimeCreated").text);
    timeModified = DateTime.parse(getXmlElement(data, "TimeModified").text);
    name = getXmlElement(data, "Name").text;
    fullName = getXmlElement(data, "FullName").text;
    isActive = getXmlElement(data, "IsActive", optional: true).text.toUpperCase() == "TRUE";
    parentRef = new QBRef.parseFromListXml(getXmlElement(data, "ParentRef", optional: true));
    editSequence = getXmlElement(data, "EditSequence").text;
    subLevel = int.parse(getXmlElement(data, "SubLevel").text, onError: (e) { return 0; });
    accountType = EnumString.get(AccountType, getXmlElement(data, "AccountType").text);
    specialAccountType = EnumString.get(SpecialAccountType, getXmlElement(data, "SpecialAccountType", optional: true).text);
    isTaxAccount = getXmlElement(data, "IsTaxAccount", optional: true).text.toUpperCase() == "TRUE";
    bankNumber = getXmlElement(data, "BankNumber", optional: true).text;
    description = getXmlElement(data, "Desc").text;
    balance = num.parse(getXmlElement(data, "Balance", optional: true).text, (e) { return 0; });
    totalBalance = num.parse(getXmlElement(data, "TotalBalance", optional: true).text, (e) { return 0; });
    salesTaxCodeRef = new QBRef.parseFromListXml(getXmlElement(data, "SalesTaxCodeRef", optional: true));
    cashFlowClassification = EnumString.get(CashFlowClassification, getXmlElement(data, "CashFlowClassification", optional: true).text);
    currencyRef = new QBRef.parseFromListXml(getXmlElement(data, "CurrencyRef", optional: true));
    XmlCollection dataExtRetList = data.query("DataExtRet");
    dataExtRetList.forEach((XmlElement dataExtEl) { 
      String dataExtName = getXmlElement(dataExtEl, "DataExtName").text;
      DataExtType dataExtType = EnumString.get(DataExtType, getXmlElement(dataExtEl, "DataExtType").text);
      String dataExtValue = getXmlElement(dataExtEl, "DataExtValue").text;
      String ownerID = getXmlElement(dataExtEl, "OwnerID", optional: true).text;          
      dataExtRet.add(new DataExtRet(dataExtName, dataExtType, dataExtValue, ownerID));
    });   
  }
  
  
  Future<bool> insert(QuickbooksConnector qbc) {
    
  }
  
  Future<bool> update(QuickbooksConnector qbc) {
    
  }
}