part of FreemansServer;


class SalesRow extends Syncable<SalesRow> {

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
  
  static exists (int ID) => Syncable.exists(SalesRow, ID);
  static get (int ID) => Syncable.get(SalesRow, ID);

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
  
  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
  Completer c = new Completer();
    List<Future<bool>> futures = new List<Future<bool>>();
    // Fake completer/future to ensure that we always have atleast one future waiting on.
    // Whilst its a bit hacky its easier than doing a check.
    Completer fakeCompleter = new Completer();
    futures.add(fakeCompleter.future);
    if (_customer != null) futures.add(_customer.updateDatabase(dbh, qbc));
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
    fakeCompleter.complete(true);
    return c.future;
  }
}

class PurchaseRow extends Syncable<PurchaseRow> {

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
  static exists (int ID) => Syncable.exists(PurchaseRow, ID);
  static get (int ID) => Syncable.get(PurchaseRow, ID);

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
    row.requiresDatabaseSync();
  }


  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    int supplierID;
    if (supplier != null) {
      supplierID = supplier.ID;
    }
    int haulierID;
    if (collectingHaulier != null) {
      haulierID = collectingHaulier.ID;
    }
    List<Future<bool>> futures = new List<Future<bool>>();
    _sales.forEach((SalesRow sr) {
      futures.add(sr.updateDatabase(dbh, qbc));
    });
    // Fake completer/future to ensure that we always have atleast one future waiting on.
    // Whilst its a bit hacky its easier than doing a check.
    Completer fakeCompleter = new Completer();
    futures.add(fakeCompleter.future);
    if (_supplier != null) futures.add(_supplier.updateDatabase(dbh, qbc));
    Future.wait(futures).then((List<bool> returnVal )  { 
      bool all = returnVal.every((e) { return e; });
      if (all) {
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
      }
      else c.completeError("Unknown SalesRow db update error");
    }).catchError((e) => c.completeError(e));
    fakeCompleter.complete(true);
    return c.future;
  }
}

class TransportRow extends Syncable<TransportRow> {
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
  static exists (int ID) => Syncable.exists(TransportRow, ID);
  static get (int ID) => Syncable.get(TransportRow, ID);

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

  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    ffpServerLog.severe("Transport row does not have its own database table");
  }
}

class WorkbookRow extends Syncable<WorkbookRow> {
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
  static exists (int ID) => Syncable.exists(WorkbookRow, ID);
  static get (int ID) => Syncable.get(WorkbookRow, ID);

  /*
   *  WORKBOOK ROW
   */

  PurchaseRow _purchase;

  get purchaseData => _purchase;


  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    return _purchase.updateDatabase(dbh, qbc);
  }
}


class WorkbookDay  extends Syncable<WorkbookDay> {
  static int _auto_inc = 0;
  List<WorkbookRow> workbook_data = new List<WorkbookRow>();
  WorkbookDay._loadTimePeriod (DateTime timeFrom, DateTime timeTo):super(_auto_inc, "${timeFrom.millisecondsSinceEpoch};${timeTo.millisecondsSinceEpoch}") {
    _auto_inc++;
    
  }
  static exists (DateTime timeFrom, DateTime timeTo) => Syncable.exists(WorkbookDay, ("${timeFrom.millisecondsSinceEpoch};${timeTo.millisecondsSinceEpoch}"));
  static get (DateTime timeFrom, DateTime timeTo) => Syncable.get(WorkbookDay, "${timeFrom.millisecondsSinceEpoch};${timeTo.millisecondsSinceEpoch}");
  
  factory WorkbookDay (DateTime timeFrom, DateTime timeTo) {
     if (exists(timeFrom,timeTo)) {
       return get(timeFrom, timeTo);
     }
     else {
       return new WorkbookDay._loadTimePeriod(timeFrom, timeTo);
     }
  }
  
  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    List<Future<bool>> futures = new List<Future<bool>>();
    // Fake completer/future to ensure that we always have atleast one future waiting on.
    // Whilst its a bit hacky its easier than doing a check.
    Completer fakeCompleter = new Completer();
    futures.add(fakeCompleter.future);
    workbook_data.forEach((WorkbookRow wr) {
      futures.add(wr.updateDatabase(dbh, qbc));
    });
    Future.wait(futures).then((List<bool> returns) { 
      if (returns.every((e) => e)) {
        c.complete(true);
      }
      else {
        ffpServerLog.severe("Could not update database.");
      }
    }).catchError((e) => c.completeError(e));
    fakeCompleter.complete(true);
    return c.future;
  }

}