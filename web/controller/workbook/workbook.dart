part of FreemansClient;

@NgController(
    selector: '[workbook]',
    publishAs: 'workbook'
)
class Workbook {
  List<WorkbookDaySheet> loadedDays = new List<WorkbookDaySheet>();
  int _weekStartTime;
  
  Workbook (StateService service) {
    if (service.checkLogin()) {
      loadedDays.add(new WorkbookDaySheet());
      loadedDays.add(new WorkbookDaySheet()..sheetDay = new DateTime.now().add(new Duration(days: 1)));
      loadedDays.add(new WorkbookDaySheet()..sheetDay = new DateTime.now().add(new Duration(days: 2)));
      loadedDays.add(new WorkbookDaySheet()..sheetDay = new DateTime.now().add(new Duration(days: 3)));
      loadedDays.add(new WorkbookDaySheet()..sheetDay = new DateTime.now().add(new Duration(days: 4)));
      loadedDays.add(new WorkbookDaySheet()..sheetDay = new DateTime.now().add(new Duration(days: 5)));
      loadedDays.add(new WorkbookDaySheet()..sheetDay = new DateTime.now().add(new Duration(days: 6)));
      loadedDays.add(new WorkbookDaySheet()..sheetDay = new DateTime.now().add(new Duration(days: 7)));
    }
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
  DateTime _sheetDay = new DateTime.now();
  String  formattedDate = "";
  bool active = false;
  set sheetDay (DateTime t) {
    formattedDate = longDateFormat(t);
    _sheetDay = t;
  }
  
  DateTime get sheetDay {
    return _sheetDay;
  }
  WorkbookDaySheet () {
    formattedDate = longDateFormat(sheetDay);
    for (int x = 0; x <= 40; x++) {
    produce.add(new WorkbookProduceLine()..refID = "$x"
                                        ..supplier="Test Supplier"
                                        ..supplierQuantity=500
                                        ..item="CARROT X 10 KG NET"
                                        ..costPrice=3
                                        ..transport="PEARSONS"
                                        ..transportCost = 34.10
                                        ..customer = "Test Customer"
                                        ..deliveryDate = "01/12"
                                        ..customerQuantity = 500
                                        ..salePrice = 4
                                        ..invoiceNumber = 12387
                                        );
    }
                                         
  }
  void select () {
    produce.forEach((E) => E.select());
  }
  void toggleDay () {
    active = !active;
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
  bool selected = false;
  void select () {
    selected = !selected;
  }
  void edit() {

    // TODO: Implement workbook edit
  }
  
  
}