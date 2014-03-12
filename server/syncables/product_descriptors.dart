part of FreemansServer;

class ProductDescriptor extends Syncable<ProductDescriptor> {
  int type = SyncableTypes.PRODUCT_DESCRIPTOR;

  ProductDescriptor._create(ID, this._description):super(ID);
  ProductDescriptor.fromJson (Map params):super.fromJson(params);
  factory ProductDescriptor (int ID, String productDescriptor) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new ProductDescriptor._create(ID, productDescriptor);
  }

  static exists (int ID) => Syncable.exists(ProductDescriptor, ID);
  static ProductDescriptor get (int ID) => Syncable.get(ProductDescriptor, ID);
  static List<Syncable> getVals () => Syncable.getVals(ProductDescriptor);

  static Future<bool> init() {
    Completer c = new Completer();
    ffpServerLog.info("Loading descriptor list...");
    dbHandler.query("SELECT ID, description, active FROM productdescriptors").then((Results results){
      results.listen((Row row) {
        ProductDescriptor p = new ProductDescriptor(row[0],row[1])..isActive = row[2] == 1;
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

  @IncludeSchema()
  String get description => _description;

  set description (String description) {
    if (description != _description) {
      _description = description;
      requiresDatabaseSync();
    }
  }


  void mergeJson (Map jsonMap) {
    this.description = jsonMap["description"];
    super.mergeJson(jsonMap);
  }

  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({ "description": description });
  }

  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO productdescriptors (description, active) VALUES (?,?)", [this._description, this._isActive ? 1 : 0]).then((res) {
        if (res.insertId != 0) {
          this._firstInsert(res.insertId);
          c.complete(true);
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
      dbh.prepareExecute("UPDATE productdescriptors SET description=?, active=? WHERE ID=?", [this._description, this._isActive ? 1 : 0, this.ID]).then((res) {
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