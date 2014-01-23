part of FreemansClient;


class Customer {
  String UUID = "";
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
  int terms = 0;
  String invoiceEmail = "";
  bool isEmailedInvoice = true;
  String confirmationEmail = "";
  bool isEmailedConfirmation = true;
  String faxNumber = "";
  String phoneNumber = "";
  Map<String, dynamic> toJson () { 
    return { 
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
      "terms": terms,
      "invoiceEmail": invoiceEmail,
      "isEmailedInvoice": isEmailedInvoice,
      "confirmationEmail": confirmationEmail,
      "isEmailedConfirmation": isEmailedConfirmation,
      "faxNumber": faxNumber,
      "phoneNumber": phoneNumber
      };
  }
  
}