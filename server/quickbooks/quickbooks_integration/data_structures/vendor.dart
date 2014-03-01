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
  double creditLimit;
  String vendorTaxIdent;
  double balance;
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
  
  
}