part of FreemansServer;


class ProductWeight extends Syncable<ProductWeight>  {
  int type = SyncableTypes.PRODUCT_WEIGHT;
  ProductWeight._create(ID, this._description, this._kg, this._amount):super(ID);
  ProductWeight.fromJson (Map params):super.fromJson(params);
  factory ProductWeight (int ID, String description, num kg, num amount) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new ProductWeight._create(ID, description, kg, amount);
  }
  static exists (int ID) => Syncable.exists(ProductWeight, ID);
  static get (int ID) => Syncable.get(ProductWeight, ID);

  static Future<bool> init() {
    Completer c = new Completer();
    ffpServerLog.info("Loading product weights list...");
    dbHandler.query("SELECT ID, description, active, kg, amount FROM productweights").then((Results results){
      results.listen((Row row) {
        ProductWeight weight = new ProductWeight(row[0], row[1], row[3], row[4]);
        weight._isActive = row[2] == 1;

      },
      onDone: () {
        c.complete(true);
        ffpServerLog.info("List loaded.");
      },
      onError: (e) {
        c.completeError("Could not load list from database: $e");
      });
    }).catchError((e) {
      c.completeError("Could not load list from database: $e");
    });
    return c.future;
  }

  // Object



  String _description;
  num _kg;
  num _amount;

  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({ "description": description, "kg": kg, "amount": amount });
  }

  @IncludeSchema()
  String get description => _description;
  @IncludeSchema(isOptional: true)
  num get kg => _kg;
  @IncludeSchema(isOptional: true)
  num get amount => _amount;

  set description (String description) {
    if (description != _description) {
      _description = description;
      requiresDatabaseSync();
    }
  }

  set kg (num kg) {
    if (kg != _kg) {
      _kg = kg;
      requiresDatabaseSync();
    }
  }
  set amount (num amount) {
    if (amount != _amount) {
      amount = _amount;
      requiresDatabaseSync();
    }
  }

  void mergeJson (Map jsonMap) {
    this.description = jsonMap["description"];
    this.kg = jsonMap["kg"];
    this.amount = jsonMap["amount"];
    super.mergeJson(jsonMap);
  }

  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO productweights (description, kg, amount) VALUES (?,?,?)", [this.description, this.kg, this.amount]).then((res) {
        if (res.insertId != 0) {
          this._firstInsert(res.insertId);
          c.complete(true);
          ffpServerLog.info("Created new ${this.runtimeType} $description");

        }
        else {
          c.completeError("Unspecified mysql error");
          ffpServerLog.severe("Unspecified mysql error");
        }
      }).catchError((e) {
        c.completeError(e);
        ffpServerLog.severe("Error whilst creating ${this.runtimeType} $description :", e);
      });
    }
    else {
      dbh.prepareExecute("UPDATE productweights SET description=?, kg = ?, amount = ? WHERE ID=?", [this.description,this.kg,this.amount,this.ID]).then((res) {
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