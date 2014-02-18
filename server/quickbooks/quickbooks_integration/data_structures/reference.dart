part of QuickbooksIntegration;

class QBRef {
  String fullName; 
  String listID;
  QBRef ();
  factory QBRef.parseFromListXml(QBXmlContainer ref) {
    if (ref.exists) {
      QBRef refer = new QBRef();
      refer.fullName = getQbxmlContainer(ref, "FullName", optional: true).text;
      refer.listID = getQbxmlContainer(ref, "ListID", optional: true).text;
    }
  }
  Map toJson () {
    return (fullName != null || listID != null ? { "fullName": fullName, "listID": listID } : null);
  }
  String toString () {
    return toJson().toString();
  }
}