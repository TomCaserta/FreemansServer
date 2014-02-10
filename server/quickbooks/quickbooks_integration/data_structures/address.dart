part of QuickbooksIntegration;

class QBAddress {
  List<String> lines = new List<String>(5);
  String city;
  String state;
  String postalCode;
  String country;
  String note;
  QBAddress addressBlock;//?
  
  QBAddress.parseFromListXml (XmlElement addressData, [XmlElement blockData]) {
    lines[0] = getXmlElement(addressData, "Addr1", optional: true).text;
    lines[1] = getXmlElement(addressData, "Addr2", optional: true).text;
    lines[2] = getXmlElement(addressData, "Addr3", optional: true).text;
    lines[3] = getXmlElement(addressData, "Addr4", optional: true).text;
    lines[4] = getXmlElement(addressData, "Addr5", optional: true).text;
    city = getXmlElement(addressData, "City", optional:true).text;
    state = getXmlElement(addressData, "State", optional:true).text;
    postalCode = getXmlElement(addressData, "postalCode", optional:true).text;
    country = getXmlElement(addressData, "Country", optional:true).text;
    note = getXmlElement(addressData, "Note", optional:true).text;   
    if (blockData != null) {
      addressBlock = new QBAddress.parseFromListXml(blockData);
    }
  }
  
  Map toJson () {
    return { "lines": lines, "city": city, "state": state, "postalCode": postalCode, "country": country, "note": note, "addressBlock": addressBlock };
  }
  
  String toString () {
    return toJson().toString();
  }
}
