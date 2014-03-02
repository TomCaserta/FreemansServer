part of QuickbooksIntegration;

class QBStandardTerms extends QBModifiable {
  DateTime timeCreated;
  DateTime timeModified;
  String editSequence;
  String name;
  bool isActive;
  int stdDueDays;
  int stdDiscountDays;
  QBPercent discountPct;

  QBStandardTerms();

  QBStandardTerms.parseFromListXml (XmlElement termsData) {
    parseXML(termsData);
  }

  void parseXML(XmlElement termsData) {
    listID = getQbxmlContainer(termsData, "ListID").text;
    name = getQbxmlContainer(termsData, "Name").text;
    timeCreated = getQbxmlContainer(termsData, "TimeCreated").date;
    timeModified = getQbxmlContainer(termsData, "TimeModified").date;
    editSequence = getQbxmlContainer(termsData, "EditSequence").text;
    isActive = getQbxmlContainer(termsData, "IsActive", optional: true).boolean;
    stdDueDays = getQbxmlContainer(termsData, "StdDueDays", optional: true).integer;
    stdDiscountDays = getQbxmlContainer(termsData, "StdDiscountDays", optional: true).integer;
    discountPct = getQbxmlContainer(termsData, "DiscountPct", optional: true).percent;
  }

  static Future<QBStandardTerms> fetchByID(String listID, QuickbooksConnector qbc) {
    Completer c = new Completer();
    QBStandardTermsList cl = new QBStandardTermsList(qbc, listID: listID);
    cl.forEach().listen((QBStandardTerms terms) {
      c.complete(terms);
    }, onDone: () {
      if (!c.isCompleted) {
        c.completeError("No results from query for ${listID} perhaps an outdated row?");
      }
    });
    return c.future;
  }

  Future<bool> insert(QuickbooksConnector qbc) {
    Completer c = new Completer();
    String xml = ResponseBuilder.parseFromFile("standard_terms_add", params: {
        "version": QB_VERSION
    }
      ..addAll(this.toJson()));
    qbc.processRequest(xml).then((String xmlResponse) {
      XmlElement xmlFile = XML.parse(xmlResponse);
      XmlElement response = xmlFile.query("QBXML").query("QBXMLMsgsRs").query("StandardTermsAddRs").first;
      if (response != null && response.attributes["statusCode"] == "0") {
        parseXML(response.query("StandardTermsRet").first);
        _qbLogger.fine("Created new Terms ${name}");
        c.complete(true);
      } else {
        _qbLogger.warning("Quickbooks could not process the response with the message: ${response.attributes["statusMessage"]}");
        c.completeError(new Exception("Quickbooks could not process the response with the message: ${response.attributes["statusMessage"]}"));
      }
    });
    return c.future;
  }
  
  Future<bool> update(QuickbooksConnector qbc) {
    // Fun fact, there is no way to modify terms! :D
    throw new UnimplementedError();
  }
  
  Map toJson () {
    return {  "timeCreated": timeCreated,  "timeModified": timeModified,  "editSequence": editSequence,  "name": name,  "isActive": isActive,  "stdDueDays": stdDueDays,  "stdDiscountDays": stdDiscountDays,  "discountPct": discountPct };
  }
  
  String toString () {
    return toJson().toString();
  }
}