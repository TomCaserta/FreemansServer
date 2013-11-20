part of FreemansClient;

@NgComponent(
    selector: 'transport',
    templateUrl: '/views/transport/transport.html',
    cssUrl: '/views/transport/transport.css',
    publishAs: 'ctrl'
)
class CashbookSheets {
 List<CashbookPayments> payments = new List<CashbookPayments>();
  
}


class CashbookCustomer {  
  
    List<CashbookCustomerEntry> customers = new List<CashbookCustomerEntry> ();
    
    CashbookCustomer (this.customers);
    
    onClick() {
              
    }
}

class CashbookCustomerEntry {
  String date = "";
  String customer = "";
  num amount = 0;
  num allowance = 0;
  num partpaid = 0;
  num balance = 0;
  num detail = 0;
  num invnumber = 0;
  num total = 0;
  num banked = 0;
  
  CashbookCustomerEntry (this.date, this.customer, this.amount, this.allowance, this.partpaid, this.balance, this.detail, this.invnumber, this.total, this.banked);
}