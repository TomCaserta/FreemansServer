part of FreemansClient;

@NgController (
  selector: "sales-confirmations",
  publishAs: "confirmations"
)
class SalesConfirmations {
  DateTime _selDate = new DateTime.now();

  String get selectedDate => new DateFormat('yyyy-MM-dd').format(_selDate);

  set selectedDate (String saleDate) {
    try {
      DateTime parseDT = new DateFormat('yyyy-MM-dd').parse(saleDate);
      _selDate = parseDT;
      getConfirmations();
    }
    catch (E) {
      // TODO: handle this error
      print("Could not parse :( $saleDate");
    }
  }

  StateService state;

  SalesConfirmations (StateService this.state) {

    getConfirmations();
  }

  List<ConfirmationContainer> confirmations = [];

  void getConfirmations() {
    if (_selDate != null) {
      int t = _selDate.toUtc().millisecondsSinceEpoch;
      int dayBegin = t - (t % 86400000) - 1;
      int dayEnd = dayBegin + 86400000 + 1;
      Future<List<SalesRow>> sr = SalesRow.searchData(state.wsh, deliveryDateFrom: dayBegin, deliveryDateTo: dayEnd);

      sr.then((List<SalesRow> sales) {
        print(sales);

        Map<Customer, List<SalesRow>> customerSales = new Map<Customer, List<SalesRow>> ();
        sales.forEach((SalesRow row) {
          print(row);
          Customer c = Syncable.get(SyncableTypes.CUSTOMER, row.customerID);
          if (!customerSales.containsKey(c)) customerSales[c] = new List<SalesRow>();
          customerSales[c].add(row);
        });
        confirmations.clear();
        customerSales.forEach((Customer c, List<SalesRow> sr)  {
          print("Added new Conf Container");
          confirmations.add(new ConfirmationContainer(c, sr, false, _selDate));
        });
      });
    }
  }
}

class ConfirmationContainer {
  Customer cust;
  List<SalesRow> sr;
  bool requireAmmendment = false;
  DateTime date;
  ConfirmationContainer(this.cust, this.sr, this.requireAmmendment, this.date);
}