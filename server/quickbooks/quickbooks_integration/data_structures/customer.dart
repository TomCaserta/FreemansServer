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
  
  num openBalance;
  DateTime openBalanceDate;
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
  
  QBCustomer();

  QBCustomer.parseFromListXml (XmlElement customerData) {
    parseXML(customerData);
  }
  void parseXML (XmlElement customerData) {
    listID = getQbxmlContainer(customerData, "ListID").text;
    timeCreated = getQbxmlContainer(customerData, "TimeCreated").date;
    timeModified = getQbxmlContainer(customerData, "TimeModified").date;
    editSequence = getQbxmlContainer(customerData, "EditSequence").text;
    name = getQbxmlContainer(customerData, "Name").text;
    fullName = getQbxmlContainer(customerData, "FullName").text;
    isActive = getQbxmlContainer(customerData, "IsActive", optional: true).boolean;
    parentRef = new QBRef.parseFromListXml(getQbxmlContainer(customerData, "ParentRef", optional: true));
    subLevel = getQbxmlContainer(customerData, "Sublevel").integer;
    companyName = getQbxmlContainer(customerData, "CompanyName", optional: true).text;
    salutation = getQbxmlContainer(customerData, "Salutation", optional: true).text;
    firstName = getQbxmlContainer(customerData, "FirstName", optional: true).text;
    middleName = getQbxmlContainer(customerData, "MiddleName", optional: true).text;
    lastName = getQbxmlContainer(customerData, "LastName", optional: true).text;
    billAddress = new QBAddress.parseFromListXml(getQbxmlContainer(customerData, "BillAddress", optional: true), getQbxmlContainer(customerData, "BillAddressBlock", optional: true));
    shipAddress = new QBAddress.parseFromListXml(getQbxmlContainer(customerData, "ShipAddress", optional: true), getQbxmlContainer(customerData, "ShipAddressBlock", optional: true));
    phoneNumber = getQbxmlContainer(customerData, "Phone", optional: true).text;
    altPhoneNumber = getQbxmlContainer(customerData, "AltPhone", optional: true).text;
    faxNumber = getQbxmlContainer(customerData, "Fax", optional: true).text;
    email = getQbxmlContainer(customerData, "Email", optional: true).text;
    contact = getQbxmlContainer(customerData, "Contact", optional: true).text;
    altContact = getQbxmlContainer(customerData, "AltContact", optional: true).text;
    customerTypeRef = new QBRef.parseFromListXml(getQbxmlContainer(customerData, "CustomerTypeRef", optional: true));
    termsRef = new QBRef.parseFromListXml(getQbxmlContainer(customerData, "TermsRef", optional: true));
    salesRepRef = new QBRef.parseFromListXml(getQbxmlContainer(customerData, "SalesRepRef", optional: true));
    openBalance = getQbxmlContainer(customerData, "Balance", optional: true).number;
    totalBalance = getQbxmlContainer(customerData, "TotalBalance", optional: true).number;
    salesTaxCodeRef = new QBRef.parseFromListXml(getQbxmlContainer(customerData, "SalesTaxCodeRef", optional: true));
    salesTaxCountry = EnumString.get(SalesTaxCountry, getQbxmlContainer(customerData, "SalesTaxCountry", optional: true).text);
    resaleNumber = getQbxmlContainer(customerData, "ResaleNumber", optional: true).text;
    accountNumber = getQbxmlContainer(customerData, "AccountNumber", optional: true).text;
    creditLimit = getQbxmlContainer(customerData, "CreditLimit", optional: true).number;
    preferredPaymentMethodRef = new QBRef.parseFromListXml(getQbxmlContainer(customerData, "PreferredPaymentMethodRef", optional: true));
    creditCardInfo = new QBCreditCardInfo.parseFromListXml(getQbxmlContainer(customerData, "CreditCardInfo", optional: true));
    jobStatus = EnumString.get(JobStatus, getQbxmlContainer(customerData, "JobStatus", optional: true).text);
    jobStartDate = getQbxmlContainer(customerData, "JobStartDate", optional: true).date;
    jobProjectedEndDate = getQbxmlContainer(customerData, "JobProjectedEndDate", optional: true).date;
    jobEndDate = getQbxmlContainer(customerData, "JobEndDate", optional: true).date;
    jobDescription = getQbxmlContainer(customerData, "JobDesc", optional: true).text;
    jobTypeRef = new QBRef.parseFromListXml(getQbxmlContainer(customerData, "JobTypeRef", optional: true));
    notes = getQbxmlContainer(customerData, "Notes", optional: true).text;
    priceLevelRef = new QBRef.parseFromListXml(getQbxmlContainer(customerData, "PriceLevelRef", optional: true));
    externalGUID = getQbxmlContainer(customerData, "ExternalGUID", optional: true).text;
    taxRegistrationNumber = getQbxmlContainer(customerData, "TaxRegistrationNumber", optional: true).text;
    currencyRef = new QBRef.parseFromListXml(getQbxmlContainer(customerData, "CurrencyRef", optional: true));
    XmlCollection dataExtRetList = customerData.query("DataExtRet");
        dataExtRetList.forEach((XmlElement dataExtEl) {          
          dataExtRet.add(new DataExtRet.parseFromListXml(dataExtEl));
    }); 
  }
  
  Future<bool> insert(QuickbooksConnector qbc) {
    Completer c = new Completer();
    String xml = ResponseBuilder.parseFromFile("customer_add", params: { "version": QB_VERSION }..addAll(this.toJson()) );  
    qbc.processRequest(xml).then((String xmlResponse) { 
      XmlElement xmlFile = XML.parse(xmlResponse);
      XmlElement response = xmlFile.query("QBXML").query("QBXMLMsgsRs").query("CustomerAddRs").first;
      if (response != null && response.attributes["statusCode"] == "0") {
        parseXML(response);
        c.complete(true);
      }
      else {
        c.completeError(new Exception("Quickbooks could not process the response with the message: ${response.attributes["statusMessage"]}"));
      }
    });
    return c.future;
  }
    
  Future<bool> update(QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (listID != null && editSequence != null) {
      String xml = ResponseBuilder.parseFromFile("customer_mod", params: { "version": QB_VERSION }..addAll(this.toJson()) );  
      print(xml);
      qbc.processRequest(xml).then((String xmlResponse) { 
        XmlElement xmlFile = XML.parse(xmlResponse);
        XmlElement response = xmlFile.query("QBXML").query("QBXMLMsgsRs").query("CustomerModRs").first;
        if (response != null && response.attributes["statusCode"] == "0") {
          parseXML(response);
          c.complete(true);
        }
        else {
          c.completeError(new Exception("Quickbooks could not process the response with the message: ${response.attributes["statusMessage"]}"));
        }
      });
    }
    else {
      c.completeError(new ArgumentError("You tried to update an object with quickbooks which has not got a listID or editSequence. The request would be rejected by quickbooks if this was sent."));
    }
    return c.future;
  }
  
  Map toJson () {
    return { "listID": listID, "timeCreated": timeCreated.millisecondsSinceEpoch,  "timeModified": timeModified.millisecondsSinceEpoch,  "editSequence": editSequence,  "name": name,  "fullName": fullName,  "isActive": isActive,  "parentRef": parentRef,  "subLevel": subLevel,  "companyName": companyName,  "salutation": salutation,  "firstName": firstName,  "middleName": middleName,  "lastName": lastName,  "billAddress": billAddress,  "shipAddress": shipAddress,  "phoneNumber": phoneNumber,  "altPhoneNumber": altPhoneNumber,  "faxNumber": faxNumber,  "email": email,  "contact": contact,  "altContact": altContact,  "customerTypeRef": customerTypeRef,  "termsRef": termsRef,  "salesRepRef": salesRepRef,  "openBalance": openBalance, "openBalanceDate": openBalanceDate,  "totalBalance": totalBalance,  "salesTaxCodeRef": salesTaxCodeRef,  "salesTaxCountry": salesTaxCountry,  "resaleNumber": resaleNumber,  "accountNumber": accountNumber,  "creditLimit": creditLimit,  "preferredPaymentMethodRef": preferredPaymentMethodRef,  "creditCardInfo": creditCardInfo,  "jobStatus": jobStatus,  "jobStartDate": jobStartDate,  "jobProjectedEndDate": jobProjectedEndDate,  "jobEndDate": jobEndDate,  "jobDescription": jobDescription,  "jobTypeRef": jobTypeRef,  "notes": notes,  "priceLevelRef": priceLevelRef,  "externalGUID": externalGUID,  "taxRegistrationNumber": taxRegistrationNumber,  "currencyRef": currencyRef, "dataExtRet": dataExtRet };
  }
  
  String toString () {
    return toJson().toString();
  }
}

class QBCreditCardInfo {
  String cardNumber;
  int expirationMonth;
  int expirationYear;
  String nameOnCard;
  String creditCardAddress;
  String creditCardPostalCode;
  QBCreditCardInfo();
  factory QBCreditCardInfo.parseFromListXml (QBXmlContainer credInfo) {
    if (credInfo.exists) { 
      QBCreditCardInfo card = new QBCreditCardInfo();
      card.cardNumber = getQbxmlContainer(credInfo, "CreditCardNumber", optional: true).text;
      card.expirationMonth = getQbxmlContainer(credInfo, "ExpirationMonth", optional: true).integer;
      card.expirationYear = getQbxmlContainer(credInfo, "ExpirationYear", optional: true).integer;
      card.nameOnCard = getQbxmlContainer(credInfo, "NameOnCard", optional: true).text;
      card.creditCardAddress = getQbxmlContainer(credInfo, "CreditCardAddress", optional: true).text;
      card.creditCardPostalCode = getQbxmlContainer(credInfo, "CreditCardPostalCode", optional: true).text;
      return card;
    }
  }
  
 Map toJson () {
   return { "cardNumber": cardNumber,  "expirationMonth": expirationMonth,  "expirationYear": expirationYear,  "nameOnCard": nameOnCard,  "creditCardAddress": creditCardAddress,  "creditCardPostalCode": creditCardPostalCode};
 }
 String toString() {
   return toJson().toString();
 }
}
