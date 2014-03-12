part of FreemansServer;

class SalesRow extends Syncable<SalesRow> {

  int type = SyncableTypes.SALE_ROW;
  /*
   * CONSTRUCTOR
   */
  SalesRow._createNew (int id, TransportRow this._transport, Customer this._customer):super(id) {

  }

  /// Factory constructor for the SalesRow to avoid duplicate objects in memory. If it already exists it will use the old object.
  factory SalesRow (int id, TransportRow transport, Customer cust) {
    if (exists(id) && id != 0) {
      return get(id);
    } else return new SalesRow._createNew(id, transport, cust);
  }

  static exists(int ID) => Syncable.exists(SalesRow, ID);
  static get(int ID) => Syncable.get(SalesRow, ID);

  SalesRow.fromJson (Map jsonMap):super.fromJson(jsonMap);

  void mergeJson (Map jsonMap) {
    this.customer = Customer.get(jsonMap["customerID"]);
    if (jsonMap["transportID"] != null) {
      this.transport = Transport.get(jsonMap["transportID"]);
    }
    this.amount = jsonMap["amount"];
    this.salePrice = jsonMap["salePrice"];
    if (jsonMap["produceID"] != null) {
      this.produceID = jsonMap["produceID"];
    }

    int productID = jsonMap["productID"];
    int weightID = jsonMap["weightID"];
    int packagingID = jsonMap["packagingID"];
    if (productID == null) productID = 0;
    if (weightID == null) weightID = 0;
    if (packagingID == null) packagingID = 0;
    this.product = new ProductGroup(0, productID, weightID, packagingID);

    if (jsonMap["deliveryDate"] != null) {
      this.deliveryDate = new DateTime.fromMillisecondsSinceEpoch(jsonMap["deliveryDate"], isUtc: true);
    }
    this.deliveryCost = jsonMap["deliveryCost"];
    super.mergeJson(jsonMap);
  }

  Map toJson () {
    return super.toJson()..addAll({
        "customerID": (customer != null ? customer.ID : null),
        "transportID": (transport != null ? transport.ID : null),
        "amount": amount,
        "salePrice": salePrice,
        "deliveryDate": deliveryDate.millisecondsSinceEpoch,
        "deliveryCost": deliveryCost,
        "productID": productID,
        "weightID": weightID,
        "packagingID": packagingID
    });
  }
  /*
   * SALES ROW
   */
  TransportRow _transport;
  Customer _customer;
  num _amount;
  num _salePrice;
  DateTime _deliveryDate;
  num _deliveryCost;
  ProductGroup product;
  int _produceID;

  TransportRow get transport => _transport;
  Customer get customer => _customer;

  @IncludeSchema(isOptional: true)
  num get amount => _amount;
  @IncludeSchema(isOptional: true)
  num get salePrice => _salePrice;
  @IncludeSchema()
  int get customerID => (customer != null ? customer.ID : null);
  @IncludeSchema(isOptional: true)
  int get transportID => (transport != null? transport.ID : transport);
  @IncludeSchema(isOptional: true)
  DateTime get deliveryDate => _deliveryDate;
  @IncludeSchema(isOptional: true)
  int get produceID => _produceID;
  @IncludeSchema(isOptional: true)
  int get productID => (product != null ? product.productID : null);
  @IncludeSchema(isOptional: true)
  int get weightID =>  (product != null ? product.weightID : null);
  @IncludeSchema(isOptional: true)
  int get packagingID =>  (product != null ? product.packagingID : null);
  @IncludeSchema(isOptional: true)
  num get deliveryCost => _deliveryCost;

  set customer(Customer cust) {
    if (cust != _customer) {
      _customer = cust;
      requiresDatabaseSync();
    }
  }

  set transport(TransportRow transport) {
    if (transport != _transport) {
      _transport = transport;
      requiresDatabaseSync();
    }
  }

  set amount(num amount) {
    if (amount != _amount) {
      _amount = amount;
      requiresDatabaseSync();
    }
  }

  set salePrice(num salePrice) {
    if (salePrice != _salePrice) {
      _salePrice = salePrice;
      requiresDatabaseSync();
    }
  }

  set deliveryDate (DateTime deliveryDate) {
    if (deliveryDate != _deliveryDate) {
      _deliveryDate = deliveryDate;
      requiresDatabaseSync();
    }
  }

  set deliveryCost (num deliveryCost) {
    if (deliveryCost != _deliveryCost) {
      _deliveryCost =  deliveryCost;
      requiresDatabaseSync();
    }
  }

  set produceID (int produceID) {
    if (produceID != _produceID) {
      _produceID = produceID;
      requiresDatabaseSync();
    }
  }

  static String selector = "SELECT ID, customerID, produceID, haulageID, amount, cost, deliveryCost, deliveryDate, active, productID, weightID, packagingID FROM sales";
  SalesRow.fromRow(Row row):super(row.ID) {
    this.ID = row.ID;
    this.customer = Customer.get(row.customerID);

    this.produceID = row.produceID;
    int transportID = row.haulageID;
    if (transportID != null) {
      this.transport = Transport.get(transportID);
    }
    this.amount = row.amount;
    this.salePrice = row.cost;
    this.deliveryCost = row.deliveryCost;
    this._isActive = row.active == 1;

    int productID = row.productID;
    int weightID = row.weightID;
    int packagingID = row.packagingID;
    if (productID == null) productID = 0;
    if (weightID == null) weightID = 0;
    if (packagingID == null) packagingID = 0;
    this.product = new ProductGroup(0, productID, weightID, packagingID);

  }

  Future<bool> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    List<Future<dynamic>> futures = new List<Future<bool>>();
    // Fake completer/future to ensure that we always have atleast one future waiting on.
    // Whilst its a bit hacky its easier than doing a check.
    Completer fakeCompleter = new Completer();
    futures.add(fakeCompleter.future);
    if (_customer != null) futures.add(_customer.updateDatabase(dbh, qbc));
    if (product != null) futures.add(product.updateDatabase(dbh, qbc));
    Future.wait(futures).then((List returnVal) {
      bool all = returnVal.every((e) {
        if (e is bool) {
          return e;
        } else if (e is List<bool>) {
          return e.every((v) => v);
        }
      });
      if (all) {
        int haulageID;
        if (_transport != null) {
          haulageID = _transport.ID;
        }
        int customerID;
        if (_customer != null) {
          customerID = _customer.ID;
        }

        if (this.isNew) {
          dbh.prepareExecute("INSERT INTO sales (customerID, produceID, haulageID, amount, cost, deliveryCost, deliveryDate, active, productID, weightID, packagingID) VALUES (?,?,?,?,?,?,?,?,?,?,?)", [customerID, produceID, haulageID, _amount, _salePrice, deliveryCost, (deliveryDate != null ? deliveryDate.millisecondsSinceEpoch : null), (this.isActive ? 1 : 0),productID,weightID,packagingID]).then((Results res) {
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
          dbh.prepareExecute("UPDATE sales SET customerID=?, produceID=?, haulageID=?, amount=?, cost=?, deliveryCost=?, deliveryDate=?, active=?, productID=?, weightID=?, packagingID=? WHERE ID=?", [customerID, produceID, haulageID, _amount, _salePrice, deliveryCost, (deliveryDate != null ? deliveryDate.millisecondsSinceEpoch : null), (this.isActive ? 1 : 0),productID,weightID,packagingID, ID]).then((res) {
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
      } else {
        ffpServerLog.severe("Unspecified error.");
      }
    }).catchError((e) => c.completeError(e));
    fakeCompleter.complete(true);
    return c.future;
  }

}