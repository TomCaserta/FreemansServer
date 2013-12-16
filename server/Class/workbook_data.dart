part of FreemansServer;

class Syncable {
  /// Syncables parent object. Used to tell the parent that it contains objects that require a database sync.
  Syncable _parent;
  
  /// ID of the Syncable. Should match the database ID. IS NOT UNIQUE ACROSS OBJECT TYPES.
  int id = 0;
  
  /// Defines weather a Syncable is new data to be inserted into the database
  bool _newInsert = false;
  
  /// Defines weather a Syncable has changed at all. If true, [updateDatabase()] will resync the data with the database
  bool _hasChange = false;
  
  /// Contains a list of child [Syncable]'s with data that has changed.
  List<Syncable> changedChildElements = new List<Syncable>();
  
  /// Returns weather a row is new or not.
  get isNew => _newInsert;
  
  /// Sets a Syncable as a new insert.
  void setNew () {
    _newInsert = true;
  }
  
  /// Called by a syncable object when a database update is required.
  void requiresDatabaseSync ([Syncable child = null]) {
    if (_hasChange == false) {
      _hasChange = true;
      if (child != null) {
        changedChildElements.add(child);
      }
      if (_parent != null) _parent.requiresDatabaseSync();
    }
  }
  
  /// Used to update the synced status of a Syncable
  void synced () {
    changedChildElements.forEach((e) { 
      e.synced();
    });        
    _hasChange = false;
    changedChildElements = new List<Syncable>();
  }
  
  /// Overridden, destroys the object from the server and database.
  Future<bool> destroy () {
    Completer c = new Completer();
    Logger.root.severe("Syncable object ${this.runtimeType} cannot be destroyed. Shutting down to prevent data being out of sync.");
    c.completeError("Syncable object cannot be destroyed.");
    return c.future;
  }
  
  /// Called when a update to the database is occuring.
  Future<bool> updateDatabase () {
    Completer c = new Completer();
    Logger.root.severe("Syncable object ${this.runtimeType} does not implement a database update method. Shutting down to prevent data being out of sync.");
    c.completeError("Syncable object does not implement a database update method.");
    return c.future;
  }
}


class SalesRow extends Syncable {
  
  /*
   * CONSTRUCTOR
   */
  
  /// Map of all SalesRow in the program to avoid duplicate syncs.
  static Map<int, SalesRow> _rows = new Map<int, SalesRow>();
  
  /// Creates a new Sales row and puts it into the datamap.
  SalesRow._createNew (int id, TransportRow this._transport, Customer this._cust) {
    this.id = id; 
    if (id != 0) {
      _rows[id] = this;
    }
  }
  
  /// Factory constructor for the SalesRow to avoid duplicate objects in memory. If it already exists it will use the old object.
  factory SalesRow (int id,  TransportRow transport, Customer cust) {
    if (_rows.containsKey(id) && id != 0) {
      return _rows[id];
    }
    else return new SalesRow._createNew(id, transport, cust);
  }
   
  /*
   * SALES ROW
   */ 
  
  TransportRow _transport;
  Customer _cust;
  set customer (Customer cust) {
     if (cust != _cust) {
       _cust = cust;
      requiresDatabaseSync();
    }
  }
  
  set transport (TransportRow transport) {
    if (transport != _transport && transport != null) {
      _transport = transport;
      requiresDatabaseSync();
    }
  }
  
  TransportRow get transport => _transport;
  Customer get customer => _cust;
  
  // TODO: IMPLEMENT
  void setTransportUnknown () {
    
  }
  
  void detatch() {
    this._parent = null;
  }
  
  Future<bool> updateDatabase () {
    
  }
  

  
}

class PurchaseRow extends Syncable {

  /*
   * CONSTRUCTOR
   */
  
 static Map<int, PurchaseRow> _rows = new Map<int, PurchaseRow>();
  
  PurchaseRow._createNew (int id, num this._amount, String this._productName, num this._cost, DateTime this._purchaseTime, ProductWeight this._weight, ProductPackaging this._packaging, Supplier this._supplier) {
    this.id = id; 
  }
   
  factory PurchaseRow (int id,  num amount, String productName, num cost, DateTime purchaseTime, ProductWeight weight, ProductPackaging packaging, Supplier supplier) {
    if (_rows.containsKey(id) && id != 0) {
      return _rows[id];
    }
    else return new PurchaseRow._createNew(id,  amount, productName, cost, purchaseTime, weight, packaging, supplier);
  }
    
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
  
  /*
   * GETTERS
   */
  
  num get amount => _amount;
  String get productName => _productName;
  num get cost => _cost;
  DateTime get purchaseTime => _purchaseTime;
  ProductWeight get productWeight => _weight;
  ProductPackaging get productPackaging => _packaging;
  Supplier get supplier => _supplier;
  
  
  Future<bool> updateDatabase () {
    
  }
}

class TransportRow extends Syncable {
  /*
   * CONSTRUCTOR
   */
    
 static Map<int, TransportRow> _rows = new Map<int, TransportRow>();
  
  TransportRow._createNew (int id, Transport this._company, num this._deliveryCost) {
    this.id = id; 
  }
   
  factory TransportRow (int id, Transport company, num deliveryCost) {
    if (_rows.containsKey(id) && id != 0) {
      return _rows[id];
    }
    else return new TransportRow._createNew(id, company, deliveryCost);
  }
  
  /*
   * TRANSPORT ROW
   */
   
  Transport _company;
  num _deliveryCost;
  
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
  
  /*
   * GETTERS
   */
  
  Transport get company => _company;
  num get deliveryCost => _deliveryCost;
  
  Future<bool> updateDatabase () {
    
  }
}

class WorkbookRow extends Syncable {
  /*
   * CONSTRUCTOR
   */
  
  static Map<int, WorkbookRow> _rows = new Map<int, WorkbookRow>();
  
  WorkbookRow._createNew (int id, PurchaseRow this._purchase, List<SalesRow> this._sales) {
   this.id = id; 
  }
  
  factory WorkbookRow (int id, PurchaseRow purchaseRow, List<SalesRow> sales) {
    if (_rows.containsKey(id)  && id != 0) {
      return _rows[id];
    }
    else return new WorkbookRow._createNew(id, purchaseRow, sales);
  }
  
  /*
   *  WORKBOOK ROW
   */
  
  /// Cannot set, change data for row individually.
  PurchaseRow _purchase;
  List<SalesRow> _sales;  
  
  /*
   * GETTERS
   */
  
  get purchaseData => _purchase;
  
  void detatchSalesRow (SalesRow row) {
    if (_sales.contains(row)) {
      _sales.remove(row);
      row.detatch();
      requiresDatabaseSync();
      Logger.root.info("Marking detatchment of row ID ${row.id}");
    }
  }
  
  void addSalesRow (SalesRow row) {
    row.setNew();
    row.requiresDatabaseSync();
    
  }
  
  Future<bool> updateDatabase () {
    
  }
}

class WorkbookDay {
  
  factory WorkbookDay.loadDay (DateTime time) {
      
  }
  
  
}