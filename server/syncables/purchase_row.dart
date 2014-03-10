part of FreemansServer;


class PurchaseRow extends Syncable<PurchaseRow> {

  /*
   * CONSTRUCTOR
   */
  PurchaseRow._createNew (int id, num this._amount, ProductGroup this._product, num this._cost, DateTime this._purchaseTime, Supplier this._supplier, List<SalesRow> this._sales):super(id);

  PurchaseRow.fromJson (Map jsonMap):super.fromJson(jsonMap);
  factory PurchaseRow (int id, num amount, ProductGroup product, num cost, DateTime purchaseTime, Supplier supplier, List<SalesRow> sales) {
    if (exists(id) && id != 0) {
      return get(id);
    } else return new PurchaseRow._createNew(id, amount, product, cost, purchaseTime, supplier, sales);
  }

  static exists(int ID) => Syncable.exists(PurchaseRow, ID);

  static get(int ID) => Syncable.get(PurchaseRow, ID);

  void mergeJson (Map jsonMap) {
    this.amount = jsonMap["amount"];
    this.cost = jsonMap["cost"];
    int productID = jsonMap["productID"];
    int weightID = jsonMap["weightID"];
    int packagingID = jsonMap["packagingID"];
    if (productID == null) productID = 0;
    if (weightID == null) weightID = 0;
    if (packagingID == null) packagingID = 0;

    this.product = new ProductGroup(0, productID, weightID, packagingID);

    int supplierID = jsonMap["supplierID"];
    this.supplier = Supplier.get(supplierID);

    this.purchaseTime = new DateTime.fromMillisecondsSinceEpoch(jsonMap["purchaseTime"], isUtc: true);

    if (jsonMap["collectingHaulierID"] != null) {
      this.collectingHaulier = Transport.get(jsonMap["collectingHaulierID"]);
    }

    super.mergeJson(jsonMap);
  }

  Map toJson () {
    return super.toJson()..addAll({ "amount": amount, "cost": cost, "supplierID": supplierID, "productID": productID, "weightID": weightID, "packagingID": packagingID, "collectingHaulierID": collectingHaulierID, "purchaseTime": (purchaseTime != null ? purchaseTime.millisecondsSinceEpoch : null) });
  }

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

  @IncludeSchema()
  num get amount => _amount;
  @IncludeSchema(isOptional: true)
  num get cost => _cost;
  @IncludeSchema()
  DateTime get purchaseTime => _purchaseTime;
  Supplier get supplier => _supplier;
  ProductGroup get product => _product;
  Transport get collectingHaulier => _collectingHaulier;

  @IncludeSchema()
  int get productID => product.productID;
  @IncludeSchema(isOptional: true)
  int get weightID => product.weightID;
  @IncludeSchema(isOptional: true)
  int get packagingID => product.packagingID;
  @IncludeSchema()
  int get supplierID => supplier.ID;
  @IncludeSchema(isOptional: true)
  int get collectingHaulierID => (collectingHaulier != null ? collectingHaulier.ID : null);

  /*
   * SETTERS
   */

  set amount(num amount) {
    if (amount != _amount) {
      _amount = amount;
      requiresDatabaseSync();
    }
  }

  set cost(num cost) {
    if (cost != _cost) {
      _cost = cost;
      requiresDatabaseSync();
    }
  }

  set purchaseTime(DateTime time) {
    if (time != _purchaseTime) {
      _purchaseTime = time;
      requiresDatabaseSync();
    }
  }

  set supplier(Supplier supplier) {
    if (supplier != _supplier) {
      _supplier = supplier;
      requiresDatabaseSync();
    }
  }

  set product(ProductGroup product) {
    if (product != _product && product != null) {
      _product = product;
      requiresDatabaseSync();
    }
  }

  set collectingHaulier(Transport company) {
    if (company != _collectingHaulier) {
      _collectingHaulier = company;
      requiresDatabaseSync();
    }
  }

  void detatchSalesRow(SalesRow row) {
    if (_sales.contains(row)) {
      _sales.remove(row);
      row.detatchParent();
      requiresDatabaseSync();
      ffpServerLog.info("Marking detatchment of row ID ${row.ID}");
    }
  }


  static String selector = "SELECT `ID`, `productID`, `supplierID`, `haulageID`, `cost`, `weightID`, `packagingID`, `timeofpurchase`, `insertedBy`, `active` from produce";
  PurchaseRow.fromRow(Row row):super(row.ID) {
    this.ID = row.ID;
    int supplierID = row.supplierID;
    if (supplierID != null) {
      this.supplierID = Supplier.get(supplierID);
    }
    int haulageID = row.haulageID;
    if (haulageID != null) {
      this.collectingHaulier = row.haulageID;
    }
    this.cost = row.cost;
    int productID = row.productID;
    int weightID = row.weightID;
    int packagingID = row.packagingID;
    if (productID == null) productID = 0;
    if (weightID == null) weightID = 0;
    if (packagingID == null) packagingID = 0;
    this.product = new ProductGroup(0, productID, weightID, packagingID);
    this.purchaseTime = new DateTime.fromMillisecondsSinceEpoch(row.timeofpurchase);
    this.isActive = row.active == 1;
  }

  Future<bool> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();

    List<Future> futures = new List<Future>();
    if (_sales != null) {
      _sales.forEach((SalesRow sr) {
        futures.add(sr.updateDatabase(dbh, qbc));
      });
    }
    // Fake completer/future to ensure that we always have atleast one future waiting on.
    // Whilst its a bit hacky its easier than doing a check.
    Completer fakeCompleter = new Completer();
    futures.add(fakeCompleter.future);
    if (supplier != null) futures.add(supplier.updateDatabase(dbh, qbc));
    if (product != null && product.isNew) futures.add(product.updateDatabase(dbh, qbc));
    Future.wait(futures).then((List returnVal) {
      bool all = true;
      returnVal.forEach((elem)  {
        if (elem is List) {
          bool ev = elem.every((e) => e == true);
          if (ev == false) all = false;
        }
        else if (elem is bool && elem == false) all = false;
      });

      ffpServerLog.info("Sync method called on ${this.runtimeType} Result on all other rows: $all ${purchaseTime.millisecondsSinceEpoch}");
      if (all) {
        if (this.isNew) {

          dbh.prepareExecute("INSERT INTO `produce` (`productID`, `supplierID`, `haulageID`, `cost`, `weightID`, `packagingID`, `timeofpurchase`, `insertedBy`, `active`) VALUES (?,?,?,?,?,?,?,?,?)", [productID, supplierID, collectingHaulierID, cost, weightID, packagingID, purchaseTime.millisecondsSinceEpoch, null, (isActive ? 1 : 0)]).then((Results res) {
            if (res.insertId != 0) {
              this._firstInsert(res.insertId);
              c.complete(true);
              ffpServerLog.info("Created new ${this.runtimeType}");
            } else {
              c.completeError("Unspecified mysql error");
              ffpServerLog.severe("Unspecified mysql error");
            }
          }).catchError((e) {
            c.completeError(e);
            ffpServerLog.severe("Error whilst creating ${this.runtimeType}:", e);
          });
        } else {
          dbh.prepareExecute("UPDATE `produce` SET `productID`=?, `supplierID`=?, `haulageID`=?, `cost`=?, `weightID`=?, `packagingID`=?, `timeofpurchase`=?, `insertedBy`=?, `active`=? WHERE ID=?", [productID, supplierID, collectingHaulierID, cost, weightID, packagingID, purchaseTime.millisecondsSinceEpoch, null, (isActive ? 1 : 0), ID]).then((res) {
            if (res.affectedRows <= 1) {
              this.synced();
              c.complete(true);
            } else {
              c.completeError("Tried updating ${this.runtimeType} however ${res.affectedRows} rows affected does not equal one.");
            }
          }).catchError((e) {
            c.completeError(e);
          });
        }
      } else c.completeError("Unknown ${this.runtimeType} db update error");
    }).catchError((e) => c.completeError(e));
    fakeCompleter.complete(true);
    return c.future;
  }
}

