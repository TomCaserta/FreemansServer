part of FreemansServer;

class ProductPackaging extends Syncable<ProductPackaging>  {
  int type = SyncableTypes.PRODUCT_PACKAGING;
  // Static
  ProductPackaging._create(ID, this._description):super(ID);
  ProductPackaging.fromJson (Map params):super.fromJson(params);

  factory ProductPackaging (int ID, String description) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new ProductPackaging._create(ID, description);
  }
  static exists (int ID) => Syncable.exists(ProductPackaging, ID);
  static get (int ID) => Syncable.get(ProductPackaging, ID);

  static Future<bool> init() {
    Completer c = new Completer();
    ffpServerLog.info("Loading product weights list...");
    dbHandler.query("SELECT ID, description, active FROM packaging").then((Results results){
      results.listen((Row row) {
        ProductPackaging p = new ProductPackaging(row[0],row[1]);
        p._isActive = row[2] == 1;
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


  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({ "description": description });
  }

  void mergeJson (Map jsonMap) {
    this.description = jsonMap["description"];
    super.mergeJson(jsonMap);
  }


  set description (String description) {
    if (description != _description) {
      _description = description;
      requiresDatabaseSync();
    }
  }


  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO packaging (description) VALUES (?)", [this.description]).then((res) {
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
      dbh.prepareExecute("UPDATE packaging SET description=? WHERE ID=?", [this.description,this.ID]).then((res) {
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