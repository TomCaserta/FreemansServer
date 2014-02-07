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
  
  Stream forEach () {
    StreamController<XmlElement> sc = new StreamController<XmlElement>();
    _requestNext(sc);
    // qbc.processRequest(ticket, );
    return sc.stream;
  }
}

class QBSupplierList extends QBSimpleListQuery {
  QBSupplierList (qbc, step):super(qbc, "Supplier", step: step);
}

class QBAccountsList extends QBSimpleListQuery {
  QBAccountsList (qbc):super(qbc, "Account", useIterator: false);
  Stream forEach () {
    StreamController<XmlElement> sc = new StreamController<XmlElement>();
    StreamController<QBAccount> accountStream = new StreamController<QBAccount>();
    _requestNext(sc);
    
    sc.stream.listen((XmlElement data) { 
         String listID = getXmlElement(data, "ListID").text;
         QBAccount currAccount = new QBAccount();
         currAccount.listID = listID;
         currAccount.timeCreated = DateTime.parse(getXmlElement(data, "TimeCreated").text);
         currAccount.timeModified = DateTime.parse(getXmlElement(data, "TimeModified").text);
         currAccount.name = getXmlElement(data, "Name").text;
         currAccount.fullName = getXmlElement(data, "FullName").text;
         currAccount.isActive = getXmlElement(data, "IsActive", optional: true).text.toUpperCase() == "TRUE";
         currAccount.parentID = getXmlElement(getXmlElement(data, "ParentRef", optional: true), "ListID", optional: true).text;
         currAccount.editSequence = getXmlElement(data, "EditSequence").text;
         currAccount.subLevel = int.parse(getXmlElement(data, "SubLevel").text, onError: (e) { return 0; });
         currAccount.accountType = EnumString.get(AccountType, getXmlElement(data, "AccountType").text);
         currAccount.specialAccountType = EnumString.get(SpecialAccountType, getXmlElement(data, "SpecialAccountType", optional: true).text);
         currAccount.isTaxAccount = getXmlElement(data, "IsTaxAccount", optional: true).text.toUpperCase() == "TRUE";
         currAccount.bankNumber = getXmlElement(data, "BankNumber", optional: true).text;
         currAccount.description = getXmlElement(data, "Desc").text;
         currAccount.balance = num.parse(getXmlElement(data, "Balance", optional: true).text, (e) { return 0; });
         currAccount.totalBalance = num.parse(getXmlElement(data, "TotalBalance", optional: true).text, (e) { return 0; });
         currAccount.salesTaxCodeRefId = getXmlElement(getXmlElement(data, "SalesTaxCodeRef", optional: true), "ListID", optional: true).text;
         currAccount.cashFlowClassification = EnumString.get(CashFlowClassification, getXmlElement(data, "CashFlowClassification", optional: true).text);
         currAccount.currencyRef = getXmlElement(getXmlElement(data, "CurrencyRef", optional: true), "ListID", optional: true).text;
         XmlCollection dataExtRetList = data.query("DataExtRet");
         dataExtRetList.forEach((XmlElement dataExtEl) { 
           String dataExtName = getXmlElement(dataExtEl, "DataExtName").text;
           DataExtType dataExtType = EnumString.get(DataExtType, getXmlElement(dataExtEl, "DataExtType").text);
           String dataExtValue = getXmlElement(dataExtEl, "DataExtValue").text;
           String ownerID = getXmlElement(dataExtEl, "OwnerID", optional: true).text;          
           currAccount.dataExtRet.add(new DataExtRet(dataExtName, dataExtType, dataExtValue, ownerID));
         });   
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
}

class QBTermsList extends QBSimpleListQuery {
  QBTermsList (qbc):super(qbc, "Terms", useIterator: false, returnName: "StandardTermsRet");
}

class QBItemsList extends QBSimpleListQuery {
  QBItemsList (qbc, step):super(qbc, "ItemInventory", step: step, returnName: "ItemInventoryRet");
}