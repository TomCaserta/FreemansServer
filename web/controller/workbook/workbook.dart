part of FreemansClient;

@NgComponent(
    selector: 'workbook',
    templateUrl: '/views/workbook/overview.html',
    cssUrl: '/views/workbook/overview.css',
    publishAs: 'ctrl'
)
class Workbook {
  List<WorkbookDaySheet> currentWeek = new List<WorkbookDaySheet>();
  int _weekStartTime;
  
  Workbook () {
    
  }
  
  
  void loadPreviousWeek() {
      //Load one week exactly from the week start date
      loadWeek(_weekStartTime - 604800);
  }
  
  void loadNextWeek() {
    //Load one week exactly after the week start date
    loadWeek(_weekStartTime + 604800);
  }
  
  void loadWeek (int wST) {
    this._weekStartTime = wST;

    // TODO: Implement load week
  }
}

class WorkbookDaySheet {
  List<WorkbookProduceLine> produce = new List<WorkbookProduceLine>();
  void toggleDay () {
    // TODO: Implement toggle day
  }
}


class WorkbookProduceLine {
  String refID = "";
  String supplier = "";
  num supplierQuantity = 0;
  String item = "";
  num costPrice = 0.00;
  String transport = "";
  num transportCost = 0.00;
  String customer = "";
  String deliveryDate = "";
  num customerQuantity = 0;
  num salePrice = 0.00;
  num invoiceNumber = 0;
  
  void edit() {

    // TODO: Implement workbook edit
  }
  
  
}