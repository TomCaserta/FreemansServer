part of QuickbooksIntegration;

class QBSimpleListQuery {
  String listType = "";
  int step = 0;
  int currentRecord = 0;
  int maxItems = 0;
  String iteratorID;
  QuickbooksConnector qbc;
  String ticket;
  bool useIterator = true;
  String returnName;
  bool isRequesting = false;
  // Constructs a simple list query with "step" specifying how many objects to request at a time.
  QBSimpleListQuery(this.qbc, this.ticket, String this.listType, int this.step, { bool this.useIterator: true, String this.returnName: null }) {
     
  }
  
  Future _requestNext (StreamController sc) {
    String xml = "";
    if (useIterator) { 
      if (isRequesting) { 
         xml = ResponseBuilder.parseFromFile("list_request", params: { "version": "11.0", "listType": listType, "iterator": "Continue", "iteratorID": iteratorID, "maxReturned": step.toString()  } );
      }    
      else {
        xml = ResponseBuilder.parseFromFile("list_request", params: { "version": "11.0", "listType": listType, "iterator": "Start", "maxReturned": step.toString() } );  
      }
    }
    else  xml = ResponseBuilder.parseFromFile("list_request", params: { "version": "11.0", "listType": listType, "maxReturned": step.toString() } );  
    print(xml);
    qbc.processRequest(ticket, xml).then((String resp) {
      if (resp != null && resp is String) {
        XmlElement xmlFile = XML.parse(resp);
        XmlElement queryResponse = xmlFile.query("QBXML").query("QBXMLMsgsRs").query("${listType}QueryRs").first;
        if (queryResponse != null) {
          if (queryResponse.attributes.containsKey("statusCode") && queryResponse.attributes["statusCode"] == "0") {
 
            queryResponse.queryAll((returnName != null ? returnName : "${listType}Ret")).forEach((XmlElement el) { 
              sc.add(el);
            });
            if (useIterator) { 
              iteratorID = queryResponse.attributes["iteratorID"];
              isRequesting = true;
              maxItems = int.parse(queryResponse.attributes["iteratorRemainingCount"]);
              print(maxItems);
              if (maxItems > 0) { 
                currentRecord += step;
                _requestNext(sc);
              }
            }
          }
          else sc.addError("Response from Quickbooks gave an invalid status: ${queryResponse.attributes["statusMessage"]}");
        }
        else sc.addError("Quickbooks sent an invalid response to the query.");
      }
      else sc.addError("Got no response from Quickbooks.");
    });
   //qbc.processRequest(ticket, ); 
  }
  
  Stream<XmlElement> forEach () {
    StreamController<XmlElement> sc = new StreamController<XmlElement>();
    _requestNext(sc);
    // qbc.processRequest(ticket, );
    return sc.stream;
  }
}

class QBSupplierList extends QBSimpleListQuery {
  QBSupplierList (qbc, ticket, step):super(qbc, ticket, "Suppliers", step);
}

class QBCustomerList extends QBSimpleListQuery {
  QBCustomerList (qbc, ticket, step):super(qbc, ticket, "Customers", step);
}

class QBTermsList extends QBSimpleListQuery {
  QBTermsList (qbc, ticket, step):super(qbc, ticket, "Terms", step, useIterator: false, returnName: "StandardTermsRet");
}