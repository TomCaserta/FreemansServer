part of QuickbooksIntegration;

class QBAddress {
  List<String> lines = new List<String>(5);
  String city;
  String state;
  String postalCode;
  String country;
  String note;
  QBAddress addressBlock;//?
  QBAddress();
  factory QBAddress.parseFromListXml (QBXmlContainer addressData, [QBXmlContainer blockData]) {
    if (addressData.exists) { 
      QBAddress address = new QBAddress();
      address.lines[0] = getQbxmlContainer(addressData, "Addr1", optional: true).text;
      address.lines[1] = getQbxmlContainer(addressData, "Addr2", optional: true).text;
      address.lines[2] = getQbxmlContainer(addressData, "Addr3", optional: true).text;
      address.lines[3] = getQbxmlContainer(addressData, "Addr4", optional: true).text;
      address.lines[4] = getQbxmlContainer(addressData, "Addr5", optional: true).text;
      address.city = getQbxmlContainer(addressData, "City", optional:true).text;
      address.state = getQbxmlContainer(addressData, "State", optional:true).text;
      address.postalCode = getQbxmlContainer(addressData, "postalCode", optional:true).text;
      address.country = getQbxmlContainer(addressData, "Country", optional:true).text;
      address.note = getQbxmlContainer(addressData, "Note", optional:true).text;   
      if (blockData != null) {
        address.addressBlock = new QBAddress.parseFromListXml(blockData);
      } 
      return address;
    }
    else {
      return null;
    }
  }
  
  Map toJson () {
    return { "line1": lines[0], "line2": lines[1], "line3": lines[2], "line4": lines[3], "line5": lines[4], "city": city, "state": state, "postalCode": postalCode, "country": country, "note": note, "addressBlock": addressBlock };
  }
  
  String toString () {
    return toJson().toString();
  }
}
