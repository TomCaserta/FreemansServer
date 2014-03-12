part of FreemansServer;

class ProductCategory extends Syncable<ProductCategory>  {
  int type = SyncableTypes.PRODUCT_CATEGORY;
  // Static
  ProductCategory._create(ID, this._categoryName, this._categoryColour):super(ID);
  ProductCategory.fromJson (Map params):super.fromJson(params);
  factory ProductCategory (int ID, String categoryName, String categoryColour) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new ProductCategory._create(ID, categoryName, categoryColour);
  }

  static exists (int ID) => Syncable.exists(ProductCategory, ID);
  static ProductCategory get (int ID) => Syncable.get(ProductCategory, ID);
  static List<Syncable> getVals () => Syncable.getVals(ProductCategory);

  static Future<bool> init() {
    Completer c = new Completer();
    ffpServerLog.info("Loading category list...");
    dbHandler.query("SELECT ID, categoryName, categoryColour, active FROM productcategories").then((Results results){
      results.listen((Row row) {
        ProductCategory p = new ProductCategory(row[0],row[1], row[2])..isActive = row[3] == 1;
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

  String _categoryName;

  @IncludeSchema()
  String get categoryName => _categoryName;

  set categoryName (String categoryName) {
    if (categoryName != _categoryName) {
      _categoryName = categoryName;
      requiresDatabaseSync();
    }
  }

  String _categoryColour;

  String get categoryColour => _categoryColour;
  set categoryColour (String categoryColour) {
    if (categoryColour != _categoryColour) {
      _categoryColour = categoryColour;
      requiresDatabaseSync();
    }
  }

  void mergeJson (Map jsonMap) {
    this.categoryColour = jsonMap["categoryColour"];
    this.categoryName = jsonMap["categoryName"];
    super.mergeJson(jsonMap);
  }

  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({ "categoryName": categoryName, "categoryColour": categoryColour });
  }

  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO productcategories (categoryName, categoryColour, active) VALUES (?,?, ?)", [this._categoryName, this._categoryColour, this._isActive ? 1 : 0]).then((res) {
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
        ffpServerLog.severe("Error whilst creating ${this.runtimeType} $categoryName :", e);
      });
    }
    else {
      dbh.prepareExecute("UPDATE productcategories SET categoryName=?, categoryColour=?, active=? WHERE ID=?", [this._categoryName, this._categoryColour, this._isActive ? 1 : 0, this.ID]).then((res) {
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
