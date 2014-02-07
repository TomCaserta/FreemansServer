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
    lines.add(getXmlElement(addressData, "Addr1", optional: true).text);
    lines.add(getXmlElement(addressData, "Addr2", optional: true).text);
    lines.add(getXmlElement(addressData, "Addr3", optional: true).text);
    lines.add(getXmlElement(addressData, "Addr4", optional: true).text);
    lines.add(getXmlElement(addressData, "Addr5", optional: true).text);
    city = getXmlElement(addressData, "City", optional:true).text;
    state = getXmlElement(addressData, "State", optional:true).text;
    postalCode = getXmlElement(addressData, "postalCode", optional:true).text;
    country = getXmlElement(addressData, "Country", optional:true).text;
    note = getXmlElement(addressData, "Note", optional:true).text;   
    if (blockData != null) {
      addressBlock = new QBAddress.parseFromListXml(blockData);
    }
  }
}
