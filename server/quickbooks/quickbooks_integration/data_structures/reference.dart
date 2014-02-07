part of QuickbooksIntegration;

class QBRef {
  String fullName; 
  String listID;
  QBRef.parseFromListXml(XmlElement ref) { 
    fullName = getXmlElement(ref, "FullName", optional: true).text;
    listID = getXmlElement(ref, "ListID", optional: true).text;
  }
}