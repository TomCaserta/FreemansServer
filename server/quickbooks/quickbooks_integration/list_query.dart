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
  QBSimpleListQuery(this.qbc, String this.listType,  { int this.step,  bool this.useIterator: true, String this.returnName: null }) {
     
  }
  
  Future _requestNext (StreamController sc) {
    String xml = "";
    if (useIterator) { 
      if (isRequesting) { 
         xml = ResponseBuilder.parseFromFile("list_request", params: { "version": "11.0", "listType": listType, "iterator": "Continue", "iteratorID": iteratorID, "maxReturned": (step != null ? step.toString() : null) } );
      }    
      else {
        xml = ResponseBuilder.parseFromFile("list_request", params: { "version": "11.0", "listType": listType, "iterator": "Start", "maxReturned": (step != null ? step.toString() : null) } );  
      }
    }
    else  xml = ResponseBuilder.parseFromFile("list_request", params: { "version": "11.0", "listType": listType, "maxReturned": (step != null ? step.toString() : null) } );  
  
    qbc.processRequest(xml).then((String resp) {
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
              if (maxItems > 0) { 
                currentRecord += step;
                _requestNext(sc);
              }
              else {
                sc.close();
              }
            }
            else sc.close();
          }
          else sc.addError("Response from Quickbooks gave an invalid status: ${queryResponse.attributes["statusMessage"]}");
        }
        else sc.addError("Quickbooks sent an invalid response to the query.");
      }
      else sc.addError("Got no response from Quickbooks.");
    });
   //qbc.processRequest(ticket, ); 
  }
  
  Stream<XmlElement> forEachRaw () {
    StreamController<XmlElement> sc = new StreamController<XmlElement>();
    _requestNext(sc);
    // qbc.processRequest(ticket, );
    return sc.stream;
  }
  
  Stream forEach () {
    return forEachRaw();
  }
}

class QBSupplierList extends QBSimpleListQuery {
  QBSupplierList (qbc, step):super(qbc, "Supplier", step: step);
}

class QBAccountsList extends QBSimpleListQuery {
  QBAccountsList (qbc):super(qbc, "Account", useIterator: false);
  Stream<QBAccount> forEach () {
    StreamController<XmlElement> sc = new StreamController<XmlElement>();
    StreamController<QBAccount> accountStream = new StreamController<QBAccount>();
    _requestNext(sc);
    
    sc.stream.listen((XmlElement data) { 
         String listID = getXmlElement(data, "ListID").text;
         QBAccount currAccount = new QBAccount.parseFromListXml(data);
         accountStream.add(currAccount);
    },
    onDone: () { 
      accountStream.close();
    });  
    return accountStream.stream;
  }
}


class QBCustomerList extends QBSimpleListQuery {
  QBCustomerList (qbc, step):super(qbc, "Customer", step: step);
  Stream<QBCustomer> forEach () {
      StreamController<XmlElement> sc = new StreamController<XmlElement>();
      StreamController<QBCustomer> customerStream = new StreamController<QBCustomer>();
      _requestNext(sc);
      
      sc.stream.listen((XmlElement data) { 
           String listID = getXmlElement(data, "ListID").text;
           QBCustomer currCustomer = new QBCustomer.parseFromListXml(data);
           customerStream.add(currCustomer);
      },
      onDone: () { 
        customerStream.close();
      });  
      return customerStream.stream;
    }
}

class QBTermsList extends QBSimpleListQuery {
  QBTermsList (qbc):super(qbc, "Terms", useIterator: false, returnName: "StandardTermsRet");
}

class QBItemsList extends QBSimpleListQuery {
  QBItemsList (qbc, step):super(qbc, "ItemInventory", step: step, returnName: "ItemInventoryRet");
}