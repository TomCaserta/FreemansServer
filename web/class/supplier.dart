part of FreemansClient;


class Supplier {
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
  
  Map<String, dynamic> toJson () {
    return {
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
      "faxNumber": faxNumber
    };
  }
  
}