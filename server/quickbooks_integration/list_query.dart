part of QuickbooksIntegration;

class QBSimpleListQuery {
  String listType = "";
  int step = 0;
  int currentRecord = 0;
  int maxItems = 0;
  String iteratorID;
  QuickbooksConnector qbc;
  String ticket;
  bool isRequesting = false;
  // Constructs a simple list query with "step" specifying how many objects to request at a time.
  QBSimpleListQuery(this.qbc, this.ticket, String this.listType, int step) {
    
  }
  
  Future _requestNext (StreamController sc) {
    String xml = "";
    if (isRequesting) { 
       xml = ResponseBuilder.parseFromFile("list_request", params: { "listType": listType, "iterator": "Continue", "iteratorID": iteratorID } );
       qbc.processRequest(ticket, xml).then((String resp) { 
         print(resp);
       });
    }
    else {
      xml = ResponseBuilder.parseFromFile("list_request");
    }
   //qbc.processRequest(ticket, ); 
  }
  
  Stream<List<Map<String, String>>> forEach () {
    StreamController<List<Map<String, String>>> sc = new StreamController<List<Map<String, String>>>();
    _requestNext(sc);
   // qbc.processRequest(ticket, );
    return sc.stream;
  }
}