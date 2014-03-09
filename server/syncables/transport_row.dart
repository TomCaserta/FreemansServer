part of FreemansServer;



class TransportRow extends Syncable<TransportRow> {
  /*
   * CONSTRUCTOR
   */

  TransportRow._createNew (int id, Transport this._company, num this._deliveryCost):super(id);

  factory TransportRow (int id, Transport company, num deliveryCost) {
    if (exists(id) && id != 0) {
      return get(id);
    } else return new TransportRow._createNew(id, company, deliveryCost);
  }

  static exists(int ID) => Syncable.exists(TransportRow, ID);

  static get(int ID) => Syncable.get(TransportRow, ID);

  /*
   * TRANSPORT ROW
   */

  Transport _company;

  num _deliveryCost;

  Transport get company => _company;

  num get deliveryCost => _deliveryCost;

  /*
   * SETTERS
   */

  set company(Transport company) {
    if (company != _company) {
      _company = company;
      requiresDatabaseSync();
    }
  }

  set deliveryCost(num cost) {
    if (_deliveryCost != cost) {
      _deliveryCost = cost;
      if (_parent != null) _parent.requiresDatabaseSync();
    }
  }

  Future<bool> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    ffpServerLog.severe("Transport row does not have its own database table");
  }
}

class WorkbookRow extends Syncable<WorkbookRow> {
  /*
   * CONSTRUCTOR
   */


  WorkbookRow._createNew (int id, PurchaseRow this._purchase):super(id);

  factory WorkbookRow (int id, PurchaseRow purchaseRow) {
    if (exists(id) && id != 0) {
      return get(id);
    } else return new WorkbookRow._createNew(id, purchaseRow);
  }

  static exists(int ID) => Syncable.exists(WorkbookRow, ID);

  static get(int ID) => Syncable.get(WorkbookRow, ID);

  /*
   *  WORKBOOK ROW
   */

  PurchaseRow _purchase;

  get purchaseData => _purchase;


  Future<bool> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    return _purchase.updateDatabase(dbh, qbc);
  }
}