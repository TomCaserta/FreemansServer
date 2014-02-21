part of QuickbooksIntegration;

class QBCustomerAddQuery {
  QBCustomer customer;
  QBCustomerAddQuery(QBCustomer this.customer) {
    
  }
  
  Future<bool> execute (QuickbooksConnector qbc) { 
    String xml = ResponseBuilder.parseFromFile("customer_add", params: { "version": QB_VERSION }..addAll(customer.toJson()) );
    print(xml);
  }
}