part of QuickbooksIntegration;

class QBCustomer extends QBModifiable {
  DateTime timeCreated;
  DateTime timeModified;
  String editSequence;
  String name;
  String fullName;
  bool isActive;
  QBRef parentRef;
  int subLevel;
  
  String companyName;
  String salutation;
  String firstName;
  String middleName;
  String lastName;
  
  QBAddress billAddress;
  QBAddress shipAddress;
  String phoneNumber;
  String altPhoneNumber;
  String faxNumber;
  String email;
  String contact;
  String altContact;
  QBRef customerTypeRef;
  QBRef termsRef;
  QBRef salesRepRef;
  
  num balance;
  num totalBalance;
  
  QBRef salesTaxCodeRef;
  SalesTaxCountry salesTaxCountry;
  
  String resaleNumber;
  String accountNumber;
  
  num creditLimit;
  
  QBRef preferredPaymentMethodRef;
  QBCreditCardInfo creditCardInfo;
  
  JobStatus jobStatus;
  DateTime jobStartDate;
  DateTime jobProjectedEndDate;
  DateTime jobEndDate;
  String jobDescription;
  QBRef jobTypeRef;
  
  String notes;
  QBRef priceLevelRef;
  String externalGUID;
  String taxRegistrationNumber;
  QBRef currencyRef;
  
  List<DataExtRet> dataExtRet = new List<DataExtRet>();

  QBCustomer.parseFromListXml (XmlElement customerData) {
    listID = getXmlElement(customerData, "ListID").text;
    timeCreated = DateTime.parse(getXmlElement(customerData, "TimeCreated").text);
    timeModified = DateTime.parse(getXmlElement(customerData, "TimeModified").text);
    editSequence = getXmlElement(customerData, "editSequence").text;
    name = getXmlElement(customerData, "Name").text;
    fullName = getXmlElement(customerData, "FullName").text;
    isActive = getXmlElement(customerData, "IsActive").text == "TRUE";
    parentRef = new QBRef.parseFromListXml(getXmlElement(customerData, "ParentRef", optional: true));
    subLevel = int.parse(getXmlElement(customerData, "SubLevel").text);
    companyName = getXmlElement(customerData, "CompanyName", optional: true).text;
    salutation = getXmlElement(customerData, "Salutation", optional: true).text;
    firstName = getXmlElement(customerData, "FirstName", optional: true).text;
    middleName = getXmlElement(customerData, "MiddleName", optional: true).text;
    lastName = getXmlElement(customerData, "LastName", optional: true).text;
    billAddress = new QBAddress.parseFromListXml(getXmlElement(customerData, "BillAddress", optional: true), getXmlElement(customerData, "BillAddressBlock", optional: true));
    shipAddress = new QBAddress.parseFromListXml(getXmlElement(customerData, "ShipAddress", optional: true), getXmlElement(customerData, "ShipAddressBlock", optional: true));
    phoneNumber = getXmlElement(customerData, "Phone", optional: true).text;
    altPhoneNumber = getXmlElement(customerData, "AltPhone", optional: true).text;
    faxNumber = getXmlElement(customerData, "Fax", optional: true).text;
    email = getXmlElement(customerData, "Email", optional: true).text;
    contact = getXmlElement(customerData, "Contact", optional: true).text;
    altContact = getXmlElement(customerData, "AltContact", optional: true).text;
    customerTypeRef = new QBRef.parseFromListXml(getXmlElement(customerData, "CustomerTypeRef", optional: true));
    termsRef = new QBRef.parseFromListXml(getXmlElement(customerData, "TermsRef", optional: true));
    salesRepRef = new QBRef.parseFromListXml(getXmlElement(customerData, "SalesRepRef", optional: true));
    balance = num.parse(getXmlElement(customerData, "Balance", optional: true).text, (e) { return 0; });
    totalBalance = num.parse(getXmlElement(customerData, "TotalBalance", optional: true).text, (e) { return 0; });
    salesTaxCodeRef = new QBRef.parseFromListXml(getXmlElement(customerData, "SalesTaxCodeRef", optional: true));
    salesTaxCountry = EnumString.get(SalesTaxCountry, getXmlElement(customerData, "SalesTaxCountry", optional: true).text);
    resaleNumber = getXmlElement(customerData, "ResaleNumber", optional: true).text;
    accountNumber = getXmlElement(customerData, "AccountNumber", optional: true).text;
    creditLimit = num.parse(getXmlElement(customerData, "CreditLimit", optional: true).text, (e) { return 0; });
    preferredPaymentMethodRef = new QBRef.parseFromListXml(getXmlElement(customerData, "PreferredPaymentMethodRef", optional: true));
    creditCardInfo = new QBCreditCardInfo.parseFromListXml(getXmlElement(customerData, "CreditCardInfo", optional: true));
    jobStatus = EnumString.get(JobStatus, getXmlElement(customerData, "JobStatus", optional: true).text);
    jobStartDate = DateTime.parse(getXmlElement(customerData, "JobStartDate", optional: true).text);
    jobProjectedEndDate = DateTime.parse(getXmlElement(customerData, "JobProjectedEndDate", optional: true).text);
    jobEndDate = DateTime.parse(getXmlElement(customerData, "JobEndDate", optional: true).text);
    jobDescription = getXmlElement(customerData, "JobDesc", optional: true).text;
    jobTypeRef = new QBRef.parseFromListXml(getXmlElement(customerData, "JobTypeRef", optional: true));
    notes = getXmlElement(customerData, "Notes", optional: true).text;
    priceLevelRef = new QBRef.parseFromListXml(getXmlElement(customerData, "PriceLevelRef", optional: true));
    externalGUID = getXmlElement(customerData, "ExternalGUID", optional: true).text;
    taxRegistrationNumber = getXmlElement(customerData, "TaxRegistrationNumber", optional: true).text;
    currencyRef = new QBRef.parseFromListXml(getXmlElement(customerData, "CurrencyRef", optional: true));
    
  }
  
  Future<bool> insert(QuickbooksConnector qbc) {
    
  }
  
  Future<bool> update(QuickbooksConnector qbc) {
    
  }
}

class QBCreditCardInfo {
  String cardNumber;
  int expirationMonth;
  int expirationYear;
  String nameOnCard;
  String creditCardAddress;
  String creditCardPostalCode;
  QBCreditCardInfo.parseFromListXml (XmlElement credInfo) {
    cardNumber = getXmlElement(credInfo, "CreditCardNumber", optional: true).text;
    expirationMonth = int.parse(getXmlElement(credInfo, "ExpirationMonth", optional: true).text, onError: (e) { return 0; });
    expirationYear = int.parse(getXmlElement(credInfo, "ExpirationYear", optional: true).text, onError: (e) { return 0; });
    nameOnCard = getXmlElement(credInfo, "NameOnCard", optional: true).text;
    creditCardAddress = getXmlElement(credInfo, "CreditCardAddress", optional: true).text;
    creditCardPostalCode = getXmlElement(credInfo, "CreditCardPostalCode", optional: true).text;
  }
}
