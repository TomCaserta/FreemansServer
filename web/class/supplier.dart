part of DataObjects;


class Supplier extends Syncable {
  final int type = SyncableTypes.SUPPLIER;
  String name;
  String quickbooksName;
  String termsRef;
  int terms;
  String remittanceEmail;
  String confirmationEmail;
  String addressLine1;
  String addressLine2;
  String addressLine3;
  String addressLine4;
  String addressLine5;
  String phoneNumber;
  String faxNumber;
  bool isEmailedRemittance = true;
  bool isEmailedConfirmation = true;
  
  Supplier();
  
  Supplier.fromJson(Map jsonMap):super.fromJson(jsonMap) {
  }
  void mergeJson (Map jsonMap) {
    this.name = jsonMap["name"];
    this.quickbooksName = jsonMap["quickbooksName"];
    this.termsRef = jsonMap["termsRef"];
    this.terms = jsonMap["terms"];
    this.remittanceEmail = jsonMap["remittanceEmail"];
    this.confirmationEmail = jsonMap["confirmationEmail"];
    this.addressLine1 = jsonMap["addressLine1"];
    this.addressLine2 = jsonMap["addressLine2"];
    this.addressLine3 = jsonMap["addressLine3"];
    this.addressLine4 = jsonMap["addressLine4"];
    this.addressLine5 = jsonMap["addressLine5"];
    this.phoneNumber = jsonMap["phoneNumber"];
    this.faxNumber = jsonMap["faxNumber"];
    this.isEmailedRemittance = jsonMap["isEmailedRemittance"];
    this.isEmailedConfirmation = jsonMap["isEmailedConfirmation"];
    super.mergeJson(jsonMap);    
  }
  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({
      "name": name,
      "quickbooksName": quickbooksName,
      "termsRef": termsRef,
      "terms": terms,
      "remittanceEmail": remittanceEmail,
      "confirmationEmail": confirmationEmail,
      "addressLine1": addressLine1,
      "addressLine2": addressLine2,
      "addressLine3": addressLine3,
      "addressLine4": addressLine4,
      "addressLine5": addressLine5,
      "phoneNumber": phoneNumber,
      "faxNumber": faxNumber,
      "isEmailedRemittance": isEmailedRemittance,
      "isEmailedConfirmation": isEmailedConfirmation
    });
  }
  
}