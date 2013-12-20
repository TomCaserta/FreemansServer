part of FreemansServer;


class SalesRow extends SyncCachable<SalesRow> {

  /*
   * CONSTRUCTOR
   */

  SalesRow._createNew (int id, TransportRow this._transport, Customer this._cust):super(id) {
    _transport.addParent(this);
    _cust.addParent(this);
  }

  /// Factory constructor for the SalesRow to avoid duplicate objects in memory. If it already exists it will use the old object.
  factory SalesRow (int id,  TransportRow transport, Customer cust) {
    if (exists(id) && id != 0) {
      return get(id);
    }
    else return new SalesRow._createNew(id, transport, cust);
  }
  static exists (int ID) => SyncCachable.exists(SalesRow, ID);
  static get (int ID) => SyncCachable.get(SalesRow, ID);

  /*
   * SALES ROW
   */

  TransportRow _transport;
  Customer _cust;
  
  TransportRow get transport => _transport;
  Customer get customer => _cust;
  
  set customer (Customer cust) {
     if (cust != _cust) {
       _cust.detatchParent();
       _cust = cust;
       cust.addParent(this);
      requiresDatabaseSync();
    }
  }

  set transport (TransportRow transport) {
    if (transport != _transport) {
      _transport.detatchParent();
      _transport = transport;
      transport.addParent(this);
      requiresDatabaseSync();
    }
  }
  
  Future<bool> updateDatabase (DatabaseHandler dbh) {
    Completer c = new Completer();
    if (this.isNew) {
      
    }
    else {
      
    }
    return c.future;
  }
}

class PurchaseRow extends SyncCachable<PurchaseRow> {

  /*
   * CONSTRUCTOR
   */
  PurchaseRow._createNew (int id, num this._amount, String this._productName, num this._cost, DateTime this._purchaseTime, ProductWeight this._weight, ProductPackaging this._packaging, Supplier this._supplier, List<SalesRow> this._sales):super(id);

  factory PurchaseRow (int id,  num amount, String productName, num cost, DateTime purchaseTime, ProductWeight weight, ProductPackaging packaging, Supplier supplier, List<SalesRow> sales) {
    if (exists(id) && id != 0) {
      return get(id);
    }
    else return new PurchaseRow._createNew(id,  amount, productName, cost, purchaseTime, weight, packaging, supplier, sales);
  }
  static exists (int ID) => SyncCachable.exists(PurchaseRow, ID);
  static get (int ID) => SyncCachable.get(PurchaseRow, ID);

  /*
   * PURCHASE ROW
   */

  num _amount;
  String _productName;
  num _cost;
  DateTime _purchaseTime;
  ProductWeight _weight;
  ProductPackaging _packaging;
  Supplier _supplier;
  List<SalesRow> _sales;

  num get amount => _amount;
  String get productName => _productName;
  num get cost => _cost;
  DateTime get purchaseTime => _purchaseTime;
  ProductWeight get productWeight => _weight;
  ProductPackaging get productPackaging => _packaging;
  Supplier get supplier => _supplier;

  /*
   * SETTERS
   */

  set amount (num amount) {
    if (amount != _amount) {
      _amount = amount;
      requiresDatabaseSync();
    }
  }

  set productName (String name) {
    if (name != _productName) {
      _productName = name;
      requiresDatabaseSync();
    }
  }

  set cost (num cost) {
    if (cost != _cost) {
      _cost = cost;
      requiresDatabaseSync();
    }
  }

  set purchaseTime (DateTime time) {
    if (time != _purchaseTime) {
      _purchaseTime = time;
      requiresDatabaseSync();
    }
  }

  set productWeight (ProductWeight weight) {
    if (weight != _weight) {
      _weight = weight;
      requiresDatabaseSync();
    }
  }

  set productPackaging (ProductPackaging packaging) {
    if (packaging != _packaging) {
      _packaging = packaging;
      requiresDatabaseSync();
    }
  }

  set supplier (Supplier supplier) {
    if (supplier != _supplier) {
      _supplier = supplier;
      requiresDatabaseSync();
    }
  }

  void detatchSalesRow (SalesRow row) {
    if (_sales.contains(row)) {
      _sales.remove(row);
      row.detatchParent();
      requiresDatabaseSync();
      Logger.root.info("Marking detatchment of row ID ${row.ID}");
    }
  }

  void addSalesRow (SalesRow row) {
    row.setNew();
    row.requiresDatabaseSync();

  }


  Future<bool> updateDatabase (DatabaseHandler dbh) {

  }
}

class TransportRow extends SyncCachable<TransportRow> {
  /*
   * CONSTRUCTOR
   */

  TransportRow._createNew (int id, Transport this._company, num this._deliveryCost):super(id);

  factory TransportRow (int id, Transport company, num deliveryCost) {
    if (exists(id) && id != 0) {
      return get(id);
    }
    else return new TransportRow._createNew(id, company, deliveryCost);
  }
  static exists (int ID) => SyncCachable.exists(TransportRow, ID);
  static get (int ID) => SyncCachable.get(TransportRow, ID);

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
  set company (Transport company) {
    if (company != _company) {
      _company = company;
      requiresDatabaseSync();
    }
  }

  set deliveryCost (num cost) {
    if (_deliveryCost != cost) {
      _deliveryCost = cost;
      requiresDatabaseSync();
    }
  }

  Future<bool> updateDatabase (DatabaseHandler dbh) {

  }
}

class WorkbookRow extends SyncCachable<WorkbookRow> {
  /*
   * CONSTRUCTOR
   */


  WorkbookRow._createNew (int id, PurchaseRow this._purchase):super(id);

  factory WorkbookRow (int id, PurchaseRow purchaseRow) {
    if (exists(id)  && id != 0) {
      return get(id);
    }
    else return new WorkbookRow._createNew(id, purchaseRow);

  }
  static exists (int ID) => SyncCachable.exists(WorkbookRow, ID);
  static get (int ID) => SyncCachable.get(WorkbookRow, ID);

  /*
   *  WORKBOOK ROW
   */

  PurchaseRow _purchase;

  get purchaseData => _purchase;


  Future<bool> updateDatabase (DatabaseHandler dbh) {

  }
}

class WorkbookDay {

  factory WorkbookDay.loadDay (DateTime time) {

  }


}