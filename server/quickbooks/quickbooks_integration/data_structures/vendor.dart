part of QuickbooksIntegration;

class QBVendor extends QBModifiable {
  DateTime timeCreated;
  DateTime timeModified;
  String editSequence;
  String name;
  bool isActive;
  bool isTaxAgency;
  String companyName;
  String salutation;
  String firstName;
  String middleName;
  String lastName;
  QBAddress vendorAddress;
  String phoneNumber;
  String altPhoneNumber;
  String faxNumber;
  String email;
  String contact;
  String altContact;
  String nameOnCheck;
  String accountNumber;
  String notes;
  QBRef vendorTypeRef;
  QBRef termsRef;

  num creditLimit;

  String vendorTaxIdent;

  num balance;

  num openBalance;

  DateTime openBalanceDate;

  QBRef billingRateRef;
  String externalGUID;
  QBRef salesTaxCodeRef;
  SalesTaxCountry salesTaxCountry;
  bool isSalesTaxAgency;
  QBRef salesTaxReturnRef;
  String taxRegistrationNumber;
  ReportingPeriod reportingPeriod;
  bool isTaxTrackedOnPurchases;
  QBRef taxOnPurchasesAccountRef;
  bool isTaxTrackedOnSales;
  QBRef taxOnSalesAccountRef;
  bool isTaxOnTax;
  QBRef prefillAccountRef;
  QBRef currencyRef;
  List<DataExtRet> dataExtRet = new List<DataExtRet>();


  QBVendor();

  QBVendor.parseFromListXml (XmlElement vendorData) {
    parseXML(vendorData);
  }

  void parseXML(XmlElement vendorData) {
    listID = getQbxmlContainer(vendorData, "ListID").text;
    name = getQbxmlContainer(vendorData, "Name").text;
    timeCreated = getQbxmlContainer(vendorData, "TimeCreated").date;
    timeModified = getQbxmlContainer(vendorData, "TimeModified").date;
    editSequence = getQbxmlContainer(vendorData, "EditSequence").text;
    isActive = getQbxmlContainer(vendorData, "IsActive", optional: true).boolean;
    isTaxAgency = getQbxmlContainer(vendorData, "IsTaxAgency", optional: true).boolean;
    companyName = getQbxmlContainer(vendorData, "CompanyName", optional: true).text;
    salutation = getQbxmlContainer(vendorData, "Salutation", optional: true).text;
    firstName = getQbxmlContainer(vendorData, "FirstName", optional: true).text;
    middleName = getQbxmlContainer(vendorData, "MiddleName", optional: true).text;
    lastName = getQbxmlContainer(vendorData, "LastName", optional: true).text;
    vendorAddress = new QBAddress.parseFromListXml(getQbxmlContainer(vendorData, "VendorAddress", optional: true), getQbxmlContainer(vendorData, "VendorAddressBlock", optional: true));
    phoneNumber = getQbxmlContainer(vendorData, "Phone", optional: true).text;
    altPhoneNumber = getQbxmlContainer(vendorData, "AltPhone", optional: true).text;
    faxNumber = getQbxmlContainer(vendorData, "Fax", optional: true).text;
    email = getQbxmlContainer(vendorData, "Email", optional: true).text;
    contact = getQbxmlContainer(vendorData, "Contact", optional: true).text;
    altContact = getQbxmlContainer(vendorData, "AltContact", optional: true).text;
    nameOnCheck = getQbxmlContainer(vendorData, "NameOnCheck", optional: true).text;
    accountNumber = getQbxmlContainer(vendorData, "AccountNumber", optional: true).text;
    notes = getQbxmlContainer(vendorData, "Notes", optional: true).text;
    vendorTypeRef = new QBRef.parseFromListXml(getQbxmlContainer(vendorData, "VendorTypeRef", optional: true));
    termsRef = new QBRef.parseFromListXml(getQbxmlContainer(vendorData, "TermsRef", optional: true));
    creditLimit = getQbxmlContainer(vendorData, "CreditLimit", optional: true).number;
    vendorTaxIdent = getQbxmlContainer(vendorData, "VendorTaxIdent", optional: true).text;
    balance = getQbxmlContainer(vendorData, "Balance", optional: true).number;
    billingRateRef = new QBRef.parseFromListXml(getQbxmlContainer(vendorData, "BillingRateRef", optional: true));
    externalGUID = getQbxmlContainer(vendorData, "ExternalGUID", optional: true).text;
    salesTaxCodeRef = new QBRef.parseFromListXml(getQbxmlContainer(vendorData, "SalesTaxCodeRef", optional: true));
    salesTaxCountry = EnumString.get(SalesTaxCountry, getQbxmlContainer(vendorData, "SalesTaxCountry", optional: true).text);
    isSalesTaxAgency = getQbxmlContainer(vendorData, "IsSalesTaxAgency", optional: true).boolean;
    salesTaxReturnRef = new QBRef.parseFromListXml(getQbxmlContainer(vendorData, "SalesTaxReturnRef", optional: true));
    taxRegistrationNumber = getQbxmlContainer(vendorData, "TaxRegistrationNumber", optional: true).text;
    reportingPeriod = EnumString.get(ReportingPeriod, getQbxmlContainer(vendorData, "ReportingPeriod", optional: true).text);
    isTaxTrackedOnPurchases = getQbxmlContainer(vendorData, "IsTaxTrackedOnPurchases", optional: true).boolean;
    taxOnPurchasesAccountRef = new QBRef.parseFromListXml(getQbxmlContainer(vendorData, "TaxOnPurchasesAccountRef", optional: true));
    isTaxTrackedOnSales = getQbxmlContainer(vendorData, "IsTaxTrackedOnSales", optional: true).boolean;
    taxOnSalesAccountRef = new QBRef.parseFromListXml(getQbxmlContainer(vendorData, "TaxOnSalesAccountRef", optional: true));
    isTaxOnTax = getQbxmlContainer(vendorData, "IsTaxOnTax", optional: true).boolean;
    prefillAccountRef = new QBRef.parseFromListXml(getQbxmlContainer(vendorData, "PrefillAccountRef", optional: true));
    currencyRef = new QBRef.parseFromListXml(getQbxmlContainer(vendorData, "CurrencyRef", optional: true));
    XmlCollection dataExtRetList = vendorData.query("DataExtRet");
    dataExtRetList.forEach((XmlElement dataExtEl) {
      dataExtRet.add(new DataExtRet.parseFromListXml(dataExtEl));
    });
    openBalance = getQbxmlContainer(vendorData, "OpenBalance", optional: true).number;
    openBalanceDate = getQbxmlContainer(vendorData, "OpenBalanceDate", optional: true).date;
  }


  static Future fetchByID(String listID, QuickbooksConnector qbc) {
    Completer c = new Completer();
    QBVendorList cl = new QBVendorList(qbc, 1, listID: listID);
    cl.forEach().listen((QBVendor vendor) {
      c.complete(vendor);
    }, onDone: () {
      if (!c.isCompleted) {
        c.completeError("No results from query for ${listID} perhaps an outdated row?");
      }
    });
    return c.future;
  }

  Future<bool> insert(QuickbooksConnector qbc) {
    Completer c = new Completer();
    String xml = ResponseBuilder.parseFromFile("vendor_add", params: {
        "version": QB_VERSION
    }
      ..addAll(this.toJson()));
    qbc.processRequest(xml).then((String xmlResponse) {
      XmlElement xmlFile = XML.parse(xmlResponse);
      XmlElement response = xmlFile.query("QBXML").query("QBXMLMsgsRs").query("VendorAddRs").first;
      if (response != null && response.attributes["statusCode"] == "0") {
        parseXML(response.query("VendorRet").first);
        _qbLogger.fine("Created new Vendor ${name}");
        c.complete(true);
      } else {
        _qbLogger.warning("Quickbooks could not process the response with the message: ${response.attributes["statusMessage"]}");
        c.completeError(new Exception("Quickbooks could not process the response with the message: ${response.attributes["statusMessage"]}"));
      }
    });
    return c.future;
  }

  Future<bool> update(QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (listID != null && editSequence != null) {
      String xml = ResponseBuilder.parseFromFile("vendor_mod", params: {
          "version": QB_VERSION
      }
        ..addAll(this.toJson()));
      qbc.processRequest(xml).then((String xmlResponse) {
        XmlElement xmlFile = XML.parse(xmlResponse);
        XmlElement response = xmlFile.query("QBXML").query("QBXMLMsgsRs").query("VendorModRs").first;
        if (response != null && response.attributes["statusCode"] == "0") {
          parseXML(response.query("VendorRet").first);
          _qbLogger.fine("Updated the Vendor ${name}");
          c.complete(true);

        } else {
          _qbLogger.warning("Quickbooks could not process the response with the message: ${response.attributes["statusMessage"]}");
          c.completeError(new Exception("Quickbooks could not process the response with the message: ${response.attributes["statusMessage"]}"));
        }
      });
    } else if (listID != null && listID.isNotEmpty) {
      _qbLogger.info("Requested an update on a Vendor with no editSequence. Going to try to search for the item on quickbooks... This object and its references will be overwritten..");
      return QBVendor.fetchByID(listID, qbc).then((QBVendor qbv) {
        qbv.mergeWith(this);
        return qbv.update(qbc);
      });
    } else {
      _qbLogger.warning("Attempt to update an object which hasn't got an edit sequence or listID");
      c.completeError(new ArgumentError("You tried to update an object with quickbooks which has not got a listID or editSequence. The request would be rejected by quickbooks if this was sent."));
    }
    return c.future;
  }

  Map toJson() {
    return {
        "listID": listID, "timeCreated": (timeCreated != null ? timeCreated.millisecondsSinceEpoch : null), "timeModified":  (timeModified!= null ? timeModified.millisecondsSinceEpoch : null), "editSequence": editSequence, "name": name, "isActive": isActive, "isTaxAgency": isTaxAgency, "companyName": companyName, "salutation": salutation, "firstName": firstName, "middleName": middleName, "lastName": lastName, "vendorAddress": vendorAddress, "phoneNumber": phoneNumber, "altPhoneNumber": altPhoneNumber, "faxNumber": faxNumber, "email": email, "contact": contact, "altContact": altContact, "nameOnCheck": nameOnCheck, "accountNumber": accountNumber, "notes": notes, "vendorTypeRef": vendorTypeRef, "termsRef": termsRef, "creditLimit": creditLimit, "vendorTaxIdent": vendorTaxIdent, "balance": balance, "openBalance": openBalance, "openBalanceDate": (openBalanceDate != null ? openBalanceDate.millisecondsSinceEpoch : null), "billingRateRef": billingRateRef, "externalGUID": externalGUID, "salesTaxCodeRef": salesTaxCodeRef, "salesTaxCountry": salesTaxCountry, "isSalesTaxAgency": isSalesTaxAgency, "salesTaxReturnRef": salesTaxReturnRef, "taxRegistrationNumber": taxRegistrationNumber, "reportingPeriod": reportingPeriod, "isTaxTrackedOnPurchases": isTaxTrackedOnPurchases, "taxOnPurchasesAccountRef": taxOnPurchasesAccountRef, "isTaxTrackedOnSales": isTaxTrackedOnSales, "taxOnSalesAccountRef": taxOnSalesAccountRef, "isTaxOnTax": isTaxOnTax, "prefillAccountRef": prefillAccountRef, "currencyRef": currencyRef, "dataExtRet": dataExtRet
    };
  }
}