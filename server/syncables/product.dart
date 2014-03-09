part of FreemansServer;


class ProductWeight extends Syncable<ProductWeight>  {
  int type = SyncableTypes.PRODUCT_WEIGHT;
  ProductWeight._create(ID, this._description, this._kg):super(ID);
  ProductWeight.fromJson (Map params):super.fromJson(params);
  factory ProductWeight (int ID, String description, num kg) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new ProductWeight._create(ID, description, kg);
  }
  static exists (int ID) => Syncable.exists(ProductWeight, ID);
  static get (int ID) => Syncable.get(ProductWeight, ID);

  static Future<bool> init() {
    Completer c = new Completer();
    ffpServerLog.info("Loading product weights list...");
    dbHandler.query("SELECT ID, description, active, kg FROM productweights").then((Results results){
      results.listen((Row row) {
        ProductWeight weight = new ProductWeight(row[0], row[1], row[3]);
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
  Map<String, dynamic> toJson () { 
          return super.toJson()..addAll({ "description": description, "kg": kg });
  }

  @IncludeSchema()
  String get description => _description;
  @IncludeSchema()
  num get kg => _kg;
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
  
  void mergeJson (Map jsonMap) {
    this.description = jsonMap["description"];
    this.kg = jsonMap["kg"];
    super.mergeJson(jsonMap);
  }
  
  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
      Completer c = new Completer();
      if (this.isNew) {
       dbh.prepareExecute("INSERT INTO productweights (description, kg) VALUES (?,?)", [this.description, this.kg]).then((res) {
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
       dbh.prepareExecute("UPDATE productweights SET description=?, kg = ? WHERE ID=?", [this.description,this.kg,this.ID]).then((res) {  
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
      dbh.prepareExecute("INSERT INTO productcategories (categoryName, categoryColour, active) VALUES (?,?, ?)", [this._categoryName, this._categoryColour, this._isActive]).then((res) {
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
      dbh.prepareExecute("UPDATE productcategories SET categoryName=?, categoryColour=?, active=? WHERE ID=?", [this._categoryName, this._categoryColour, this._isActive, this.ID]).then((res) {  
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

class Product extends Syncable<Product> {
  int type = SyncableTypes.PRODUCT;
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

