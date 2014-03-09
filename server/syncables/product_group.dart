part of FreemansServer;


class ProductGroup extends Syncable<ProductGroup> {
  int _productID;
  int _weightID;
  int _packagingID;
  DateTime _lastUsed;

  int get productID => _productID;
  int get weightID => _weightID;
  int get packagingID => _packagingID;
  DateTime get lastUsed => _lastUsed;

  set productID (int productID) {
    if (productID != _productID) {
      _productID = productID;
      requiresDatabaseSync();
    }
  }
  set weightID (int weightID) {
    if (weightID != _weightID) {
      _weightID = weightID;
      requiresDatabaseSync();
    }
  }
  set packagingID (int packagingID) {
    if (packagingID != _packagingID) {
      _packagingID = packagingID;
      requiresDatabaseSync();
    }
  }
  set lastUsed (DateTime lastUsed) {
    if (lastUsed != _lastUsed) {
      _lastUsed = lastUsed;
      requiresDatabaseSync();
    }
  }

  ProductGroup._create(int ID, int productID, int weightID, int packagingID):super(ID, ("${productID}:${weightID}:${packagingID}")) {
    this._productID = productID;
    this._weightID = weightID;
    this._packagingID = packagingID;
  }

  factory ProductGroup (int ID, int productID, int weightID, int packagingID) {
    if (exists(productID, weightID, packagingID)) {
      if (ID != 0) {
        ffpServerLog.warning("Duplicate product group detected, $productID $weightID $packagingID");
      }
      return get(productID, weightID, packagingID);
    }
    else return new ProductGroup._create(ID, productID, weightID, packagingID);
  }


  static exists (int productID, int weightID, int packagingID) => Syncable.exists(ProductGroup, ("${productID}:${weightID}:${packagingID}"));
  static get (int productID, int weightID, int packagingID) => Syncable.get(ProductGroup, ("${productID}:${weightID}:${packagingID}"));

  void mergeJson (Map jsonMap) {
    this._productID = jsonMap["productID"];
    this._weightID = jsonMap["weightID"];
    this._packagingID = jsonMap["packagingID"];
    if (jsonMap["lastUsed"] != null) {
      this._lastUsed = new DateTime.fromMillisecondsSinceEpoch(jsonMap["lastUsed"], isUtc: true);
    }
    super.mergeJson(jsonMap);
  }

  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO productgroups (productID, weightID, packagingID, lastUsed, isActive) VALUES (?,?,?,?,?)", [productID, weightID, packagingID, (lastUsed != null ? lastUsed.millisecondsSinceEpoch : null), (isActive ? 1 : 0)]).then((res) {
        if (res.insertId != 0) {
          this._firstInsert(res.insertId);
          c.complete(true);
        }
        else {
          ffpServerLog.warning("Unspecified mysql error");
          c.completeError("Unspecified mysql error");
        }
      }).catchError((e) {
        ffpServerLog.warning("Error whilst creating ${this.runtimeType} $name :", e);
        c.completeError(e);
      });
    }
    else {
      dbh.prepareExecute("UPDATE productgroupss SET productID=?, weightID=?. packagingID=? lastUsed=?, isActive=? WHERE ID=?", [productID,weightID,packagingID, (lastUsed != null ? lastUsed.millisecondsSinceEpoch : null), (isActive ? 1 : 0), ID]).then((res) {
        if (res.affectedRows <= 1) {
          this.synced();
          c.complete(true);
        }
        else {
          c.completeError("Tried updating ${this.runtimeType} however ${res.affectedRows} rows affected does not equal one.");
        }
      }).catchError((e) {
        ffpServerLog.warning("Error whilst updating ${this.runtimeType} $e", e);
        c.completeError(e);
      });
    }
    return c.future;
  }

  static Future<bool> init() {
    Completer c = new Completer();
    ffpServerLog.info("Loading product list...");
    dbHandler.query("SELECT ID, productID, weightID, packagingID, lastUsed, isActive FROM productgroups").then((Results results){
      results.listen((Row row) {
         ProductGroup prodGroup = new ProductGroup(row[0], row[1], row[2], row[3]);
        prodGroup._lastUsed = new DateTime.fromMillisecondsSinceEpoch(row[4], isUtc: true);
        prodGroup._isActive = row[5] == 1;
      },
      onDone: () {
        ffpServerLog.info("List loaded.");
        c.complete(true);

      },
      onError: (e) {
        c.completeError("Could not load list from database: $e");
      });
    }).catchError((e) {
      c.completeError("Could not load list from database: $e");
    });
    return c.future;
  }

  Map toJson () {
    return super.toJson()..addAll({ "productID": productID,  "weightID": weightID,  "packagingID": packagingID,  "lastUsed": (lastUsed != null ? lastUsed.millisecondsSinceEpoch : null ) });
  }
}