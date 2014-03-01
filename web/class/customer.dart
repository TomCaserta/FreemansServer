part of DataObjects;

class Customer extends Syncable {
  final int type = SyncableTypes.CUSTOMER;
  String name = "";
  String quickbooksName = "";
  String billto1 = "";
  String billto2 = "";
  String billto3 = "";
  String billto4 = "";
  String billto5 = "";
  String shipto1 = "";
  String shipto2 = "";
  String shipto3 = "";
  String shipto4 = "";
  String shipto5 = "";
  String termsRef = "";
  int terms = 0;
  String invoiceEmail = "";
  bool isEmailedInvoice = true;
  String confirmationEmail = "";
  bool isEmailedConfirmation = true;
  String faxNumber = "";
  String phoneNumber = "";
  
  Customer ();
  
  Customer.fromJson (Map jsonMap):super.fromJson(jsonMap) {

  }
  
  void mergeJson (Map jsonMap) {
    this.quickbooksName = jsonMap["quickbooksName"];
    this.name = jsonMap["name"];
    this.billto1 = jsonMap["billto1"];
    this.billto2 = jsonMap["billto2"];
    this.billto3 = jsonMap["billto3"];
    this.billto4 = jsonMap["billto4"];
    this.billto5 = jsonMap["billto5"];
    this.shipto1 = jsonMap["shipto1"];
    this.shipto2 = jsonMap["shipto2"];
    this.shipto3 = jsonMap["shipto3"];
    this.shipto4 = jsonMap["shipto4"];
    this.shipto5 = jsonMap["shipto5"];
    this.termsRef = jsonMap["termsRef"];
    this.terms = jsonMap["terms"];
    this.invoiceEmail = jsonMap["invoiceEmail"];
    this.isEmailedInvoice = jsonMap["isEmailedInvoice"];
    this.confirmationEmail = jsonMap["confirmationEmail"];
    this.isEmailedConfirmation = jsonMap["isEmailedConfirmation"];
    this.faxNumber = jsonMap["faxNumber"];
    this.phoneNumber = jsonMap["phoneNumber"];
    super.mergeJson(jsonMap);
  }
  
  Map<String, dynamic> toJson () { 
    return super.toJson()..addAll({ 
      "name": name,
      "quickbooksName": quickbooksName,
      "billto1": billto1,
      "billto2": billto2,
      "billto3": billto3,
      "billto4": billto4,
      "billto5": billto5,
      "shipto1": shipto1,
      "shipto2": shipto2,
      "shipto3": shipto3,
      "shipto4": shipto4,
      "shipto5": shipto5,
      "termsRef": termsRef,
      "terms": terms,
      "invoiceEmail": invoiceEmail,
      "isEmailedInvoice": isEmailedInvoice,
      "confirmationEmail": confirmationEmail,
      "isEmailedConfirmation": isEmailedConfirmation,
      "faxNumber": faxNumber,
      "phoneNumber": phoneNumber
      });
  }
  
}