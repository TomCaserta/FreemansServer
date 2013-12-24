part of FreemansServer;


class SalesRow extends SyncCachable<SalesRow> {

  /*
   * CONSTRUCTOR
   */

  SalesRow._createNew (int id, TransportRow this._transport, Customer this._customer):super(id) {
    _transport.addParent(this);
    _customer.addParent(this);
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
  Customer _customer;
  num _amount;
  num _salePrice;
  DateTime deliveryDate;
  
  TransportRow get transport => _transport;
  Customer get customer => _customer;
  num get amount => _amount;
  num get salePrice => _salePrice;
  
  set customer (Customer cust) {
     if (cust != _customer) {
       _customer = cust;
      requiresDatabaseSync();
    }
  }

  set transport (TransportRow transport) {
    if (transport != _transport) {
      _transport.detatchParent();
      _transport = transport;
      if (transport != null) transport.addParent(this);
      requiresDatabaseSync();
    }
  }

  set amount (num amount) {
    if (amount != _amount) {
      _amount = amount;
      requiresDatabaseSync();
    }
  }
  set salePrice (  num salePrice) {
    if (salePrice != _salePrice) {
      _salePrice = salePrice;
      requiresDatabaseSync();
    }
  }
  
  Future<bool> updateDatabase (DatabaseHandler dbh) {
  Completer c = new Completer();
    List<Future<bool>> futures = new List<Future<bool>>();
    if (_transport != null) futures.add(_transport.updateDatabase(dbh));
    if (_customer != null) futures.add(_customer.updateDatabase(dbh));
    Future.wait(futures).then((List<bool> returnVal )  { 
      bool all = returnVal.every((e) { return e; });
      if (all) {
        int haulageID;
        int deliveryCost;
        if (_transport != null) {
          haulageID = _transport.ID;
          deliveryCost = _transport.deliveryCost;
        }
        int customerID;
        if (_customer != null) {
          customerID = _customer.ID;
        }
        int produceID;
        if (this._parent is PurchaseRow) {
          produceID = _parent.ID;
        }
        
        if (this.isNew) {
          dbh.prepareExecute("INSERT INTO sales (customerID, produceID, haulageID, amount, cost, deliveryCost, deliveryDate, active) VALUES (?,?,?,?,?,?,?,?)", [customerID, produceID, haulageID, _amount, _salePrice, deliveryCost, deliveryDate.millisecondsSinceEpoch, (this.isActive ? 1 : 0)])
             .then((Results res) { 
               if (res.insertId != 0) {
                 this._firstInsert(res.insertId);
                 c.complete(true);
                 ffpServerLog.info("Created new ${this.runtimeType}");
                 
               }
               else {
                 c.completeError("Unspecified mysql error");
                 ffpServerLog.severe("Unspecified mysql error");
               }
             }).catchError((e) {
               c.completeError(e);
               ffpServerLog.severe("Error whilst creating ${this.runtimeType}:", e);
             });
        }
        else {
          dbh.prepareExecute("UPDATE sales SET customerID=?, produceID=?, haulageID=?, amount=?, cost=?, deliveryCost=?, deliveryDate=?, active=? WHERE ID=?", [customerID, produceID, haulageID, _amount, _salePrice, deliveryCost, deliveryDate.millisecondsSinceEpoch, (this.isActive ? 1 : 0), ID]).then((res) {  
            if (res.affectedRows <= 1) {
              this.synced();
              c.complete(true);
            }
            else {
              c.completeError("Tried updating ${this.runtimeType} however ${res.affectedRows} rows affected does not equal one.");
            }
          }).catchError((e) {
            c.completeError(e);
          });
        }
      }
      else { 
        ffpServerLog.severe("Unspecified error.");
      }
    }).catchError((e) => c.completeError(e));
    return c.future;
  }
}

class PurchaseRow extends SyncCachable<PurchaseRow> {

  /*
   * CONSTRUCTOR
   */
  PurchaseRow._createNew (int id, num this._amount, ProductGroup this._product, num this._cost, DateTime this._purchaseTime, Supplier this._supplier, List<SalesRow> this._sales):super(id);

  factory PurchaseRow (int id,  num amount, ProductGroup product, num cost, DateTime purchaseTime, Supplier supplier, List<SalesRow> sales) {
    if (exists(id) && id != 0) {
      return get(id);
    }
    else return new PurchaseRow._createNew(id,  amount, product, cost, purchaseTime,  supplier, sales);
  }
  static exists (int ID) => SyncCachable.exists(PurchaseRow, ID);
  static get (int ID) => SyncCachable.get(PurchaseRow, ID);

  /*
   * PURCHASE ROW
   */

  num _amount;
  num _cost;
  DateTime _purchaseTime;
  Supplier _supplier;
  List<SalesRow> _sales;
  ProductGroup _product;
  Transport _collectingHaulier;

  num get amount => _amount;
  num get cost => _cost;
  DateTime get purchaseTime => _purchaseTime;
  Supplier get supplier => _supplier;
  ProductGroup get product => _product;
  Transport get collectingHaulier => _collectingHaulier;
  /*
   * SETTERS
   */

  set amount (num amount) {
    if (amount != _amount) {
      _amount = amount;
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

  set supplier (Supplier supplier) {
    if (supplier != _supplier) {
      _supplier = supplier;
      requiresDatabaseSync();
    }
  }
  
  set product (ProductGroup product) {
    if (product != _product && product != null) {
      _product = product;
      requiresDatabaseSync();
    }
  }
  
  set collectingHaulier (Transport company) {
    if (company != _collectingHaulier) {
      _collectingHaulier = company;
      requiresDatabaseSync();
    }
  }
  
  void detatchSalesRow (SalesRow row) {
    if (_sales.contains(row)) {
      _sales.remove(row);
      row.detatchParent();
      requiresDatabaseSync();
      ffpServerLog.info("Marking detatchment of row ID ${row.ID}");
    }
  }

  void addSalesRow (SalesRow row) {
    row.setNew();
    row.requiresDatabaseSync();

  }


  Future<bool> updateDatabase (DatabaseHandler dbh) {
    Completer c = new Completer();
    int supplierID;
    if (supplier != null) {
      supplierID = supplier.ID;
    }
    int haulierID;
    if (collectingHaulier != null) {
      haulierID = collectingHaulier.ID;
    }
    if (this.isNew) {
      
      dbh.prepareExecute("INSERT INTO `produce` (`productID`, `supplierID`, `haulageID`, `cost`, `weightID`, `packagingID`, `timeofpurchase`, `insertedBy`, `active`) VALUES (?,?,?,?,?,?,?,?,?)",
          [product.product.ID, supplierID, haulierID, cost, product.item.ID, product.packaging.ID, purchaseTime.millisecondsSinceEpoch, null, (isActive ? 1 : 0)])
          .then((Results res) { 
            if (res.insertId != 0) {
              this._firstInsert(res.insertId);
              c.complete(true);
              ffpServerLog.info("Created new ${this.runtimeType}");
              
            }
            else {
              c.completeError("Unspecified mysql error");
              ffpServerLog.severe("Unspecified mysql error");
            }
          }).catchError((e) {
            c.completeError(e);
            ffpServerLog.severe("Error whilst creating ${this.runtimeType}:", e);
          });
    }
    else {
      dbh.prepareExecute("UPDATE `produce` SET `productID`=?, `supplierID`=?, `haulageID`=?, `cost`=?, `weightID`=?, `packagingID`=?, `timeofpurchase`=?, `insertedBy`=?, `active`=? WHERE ID=?", 
          [product.product.ID, supplierID, haulierID, cost, product.item.ID, product.packaging.ID, purchaseTime.millisecondsSinceEpoch, null, (isActive ? 1 : 0), ID]).then((res) {  
        if (res.affectedRows <= 1) {
          this.synced();
          c.complete(true);
        }
        else {
          c.completeError("Tried updating ${this.runtimeType} however ${res.affectedRows} rows affected does not equal one.");
        }
      }).catchError((e) {
        c.completeError(e);
      });
    }
    return c.future;
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
      if (_parent != null) _parent.requiresDatabaseSync();
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