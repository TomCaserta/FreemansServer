part of FreemansServer;

class Product extends Syncable<Product> {
  int type = SyncableTypes.PRODUCT;

  @IncludeSchema()
  String get name => _name;
  @IncludeSchema()
  List<int> get validWeights => _validWeights;
  @IncludeSchema()
  List<int> get validPackaging  => _validPackaging;
  @IncludeSchema(isOptional: true)
  String get quickbooksName => _quickbooksName;
  @IncludeSchema()
  int get category => _category;


  // Static
  Product._create(ID, this._name, this._validWeights, this._validPackaging, this._quickbooksName, this._category):super(ID);
  Product.fromJson (Map params):super.fromJson(params);

  factory Product (int ID, String name, List<int> validWeights, List<int> validPackaging, String quickbooksName, int category) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new Product._create(ID, name, validWeights, validPackaging, quickbooksName, category);
  }

  static exists (int ID) => Syncable.exists(Product, ID);
  static get (int ID) => Syncable.get(Product, ID);

  static Future<bool> init() {
    Completer c = new Completer();
    ffpServerLog.info("Loading product list...");
    dbHandler.query("SELECT ID, productName, validWeights, validPackaging, quickbooksItem, category, active FROM products").then((Results results){
      results.listen((Row row) {
        List<int> vWeights = new List<int>();
        List<int> vPackaging = new List<int>();
        String vWeightString = (row[2] != null ? row[2].toString() : "");
        String vPackagingString = (row[3] != null ? row[3].toString() : "");
        if (vWeightString != null && vWeightString.isNotEmpty) {
          vWeightString.split(",").forEach((String val) {
            vWeights.add(int.parse(val));
          });
        }
        if (vPackagingString != null && vPackagingString.isNotEmpty) { 
          vPackagingString.split(",").forEach((String val) {
            vPackaging.add(int.parse(val));
          });
        }
        new Product(row[0], row[1], vWeights, vPackaging, row[4], row[5]).._isActive = row[6] == 1;
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

  // Object

  String _name;
  List<int> _validWeights = new List<int>();
  List<int> _validPackaging = new List<int>();
  String _quickbooksName;
  int _category;
  
  bool get isQBSyncable { 
    return _quickbooksName != "" && _quickbooksName != null;
  }
  
  Map<String, dynamic> toJson () { 
          return super.toJson()..addAll({ "name": name,
                                          "quickbooksName": quickbooksName,
                                          "validWeights":   validWeights,
                                          "validPackaging": validPackaging,
                                          "category": category });
  }


  void mergeJson (Map jsonMap) {
    this.name = jsonMap["name"];
    this.validWeights = jsonMap["validWeights"];
    this.validPackaging = jsonMap["validPackaging"];
    this.quickbooksName = jsonMap["quickbooksName"];
    this.category = jsonMap["category"];
    super.mergeJson(jsonMap);
  }
  
  set name (  String name) {
    if (name != _name) {
      _name = name;
      requiresDatabaseSync();
    }
  }
  set quickbooksName (  String quickbooksName) {
    if (quickbooksName != _quickbooksName) {
      _quickbooksName = quickbooksName;
      requiresDatabaseSync();
    }
  }
  set validWeights (List<int> validWeights) {
    if (validWeights != _validWeights) {
      _validWeights = validWeights;
      requiresDatabaseSync();
    }
  }
  set validPackaging (List<int> validPackaging) {
    if (validPackaging != _validPackaging) {
      _validPackaging = validPackaging;
      requiresDatabaseSync();
    }
  }
  set category (int category) {
      if (category != _category) {
        _category = category;
        requiresDatabaseSync();
      }
    }
  void addValidWeight (ProductWeight weight) {
    if (!validWeights.contains(weight.ID)) {
      validWeights.add(weight.ID);
      requiresDatabaseSync();
    }
  }
  void removeValidWeight (ProductWeight weight) {
    if (validWeights.contains(weight.ID)) {
      validWeights.remove(weight.ID);
      requiresDatabaseSync();
    }
  }
  void addValidPackaging (ProductPackaging packaging) {
    if (!validPackaging.contains(packaging.ID)) {
      validPackaging.add(packaging.ID);
      requiresDatabaseSync();
    }
  }
  void removeValidPackaging (ProductPackaging packaging) {
    if (validPackaging.contains(packaging.ID)) {
      validPackaging.remove(packaging.ID);
      requiresDatabaseSync();
    }
  }
  void setCategory (ProductCategory category) {
    this._category = category.ID;
    requiresDatabaseSync();
  }

  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO products (productName, validWeights, validPackaging, quickbooksItem, category) VALUES (?,?,?,?,?)", [name, validWeights.join(","), validPackaging.join(","), quickbooksName, category]).then((res) {
        if (res.insertId != 0) {
          this._firstInsert(res.insertId);
          c.complete(true);
          ffpServerLog.info("Created new ${this.runtimeType} $name");
          
        }
        else {
          c.completeError("Unspecified mysql error");
          ffpServerLog.severe("Unspecified mysql error");
        }
      }).catchError((e) {
        c.completeError(e);
        ffpServerLog.severe("Error whilst creating ${this.runtimeType} $name :", e);
      });
    }
    else {
      dbh.prepareExecute("UPDATE products SET productName=?, validWeights=?, validPackaging=?, quickbooksItem=?, category=? WHERE ID=?", [name, validWeights.join(","), validPackaging.join(","), quickbooksName, category, ID]).then((res) {  
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

