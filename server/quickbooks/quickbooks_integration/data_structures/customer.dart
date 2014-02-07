part of QuickbooksIntegration;

class QBCustomer extends QBModifiable {
  DateTime timeCreated;
  DateTime timeModified;
  String editSquence;
  String name;
  String fullName;
  bool isActive;
  String parentID;
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
  String customerTypeRefId;
  String termsRefId;
  String salesRepRefId;
  
  num balance;
  num totalBalance;
  
  String salesTaxCodeRefId;
  SalesTaxCountry salesTaxCountry;
  
  String resaleNumber;
  String accountNumber;
  
  num creditLimit;
  
  String preferredPaymentMethodRefId;
  QBCreditCardInfo creditCardInfo;
  
  JobStatus jobStatus;
  DateTime jobStartDate;
  DateTime jobPorjectedEndDate;
  DateTime jobEndDate;
  String jobDescription;
  String jobTypeRefId;
  
  String notes;
  String priceLevelRefId;
  String externalGUID;
  String taxRegistrationNumber;
  String currencyRef;
  
  List<DataExtRet> dataExtRet = new List<DataExtRet>();

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
}

class QBAddress {
  List<String> lines = new List<String>(5);
  String city;
  String state;
  String postalCode;
  String country;
  String note;
  QBAddress addressBlock;//?
}
