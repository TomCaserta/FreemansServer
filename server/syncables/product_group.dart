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

  ProductGroup(int ID):super(ID) {

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
         ProductGroup prodGroup = new ProductGroup(row[0]);
        prodGroup._productID = row[1];
        prodGroup._weightID = row[2];
        prodGroup._packagingID = row[3];
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