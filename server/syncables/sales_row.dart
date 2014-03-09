part of FreemansServer;

class SalesRow extends Syncable<SalesRow> {

  /*
   * CONSTRUCTOR
   */
  SalesRow._createNew (int id, TransportRow this._transport, Customer this._customer):super(id) {
    this.addChild(_transport);
    this.addChild(_customer);
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
    this.deliveryDate = new DateTime.fromMillisecondsSinceEpoch(jsonMap["deliveryDate"], isUtc: true);
    super.mergeJson(jsonMap);
  }

  Map toJson () {
    return super.toJson()..addAll({ "customerID": (customer != null ? customer.ID : null), "transportID": (transport != null ? transport.ID : null), "amount": amount, "salePrice": salePrice, "deliveryDate": deliveryDate.millisecondsSinceEpoch });
  }
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

  set customer(Customer cust) {
    if (cust != _customer) {
      _customer = cust;
      requiresDatabaseSync();
    }
  }

  set transport(TransportRow transport) {
    if (transport != _transport) {
      _transport.detatchParent();
      _transport = transport;
      if (transport != null) transport.addParent(this);
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

  Future<bool> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    List<Future<dynamic>> futures = new List<Future<bool>>();
    // Fake completer/future to ensure that we always have atleast one future waiting on.
    // Whilst its a bit hacky its easier than doing a check.
    Completer fakeCompleter = new Completer();
    futures.add(fakeCompleter.future);
    if (_customer != null) futures.add(_customer.updateDatabase(dbh, qbc));
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
          dbh.prepareExecute("INSERT INTO sales (customerID, produceID, haulageID, amount, cost, deliveryCost, deliveryDate, active) VALUES (?,?,?,?,?,?,?,?)", [customerID, produceID, haulageID, _amount, _salePrice, deliveryCost, deliveryDate.millisecondsSinceEpoch, (this.isActive ? 1 : 0)]).then((Results res) {
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
          dbh.prepareExecute("UPDATE sales SET customerID=?, produceID=?, haulageID=?, amount=?, cost=?, deliveryCost=?, deliveryDate=?, active=? WHERE ID=?", [customerID, produceID, haulageID, _amount, _salePrice, deliveryCost, deliveryDate.millisecondsSinceEpoch, (this.isActive ? 1 : 0), ID]).then((res) {
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