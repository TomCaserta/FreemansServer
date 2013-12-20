part of FreemansServer;


class ProductWeight extends SyncCachable<ProductWeight>  {
  // Static
  ProductWeight._create(ID, this._description):super(ID);

  factory ProductWeight (int ID, String description) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new ProductWeight._create(ID, description);
  }
  static exists (int ID) => SyncCachable.exists(ProductWeight, ID);
  static get (int ID) => SyncCachable.get(ProductWeight, ID);

  static Future<bool> init() {
    Completer c = new Completer();
    Logger.root.info("Loading product weights list...");
    dbHandler.query("SELECT ID, description, active FROM productweights").then((Results results){
      results.listen((Row row) {
        ProductWeight weight = new ProductWeight(row[0], row[1]);
        weight._isActive = row[2];
      },
      onDone: () {
        c.complete(true);
        Logger.root.info("List loaded.");
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

  String get description => description;
  
  set description (String description) {
    if (description != _description) {
      _description = description;
      requiresDatabaseSync();
    }
  }

  Future<bool> updateDatabase (DatabaseHandler dbh) {
      Completer c = new Completer();
      if (this.isNew) {
       dbh.prepareExecute("INSERT INTO productweights (description) VALUES (?)", [this.description]).then((res) {
         if (res.insertId != 0) {
           this._firstInsert(res.insertId);
           c.complete(true);
           Logger.root.info("Created new ${this.runtimeType} $description");
  
         }
         else {
           c.completeError("Unspecified mysql error");
           Logger.root.severe("Unspecified mysql error");
         }
       }).catchError((e) {
         c.completeError(e);
         Logger.root.severe("Error whilst creating ${this.runtimeType} $description :", e);
       });
     }
     else {
       dbh.prepareExecute("UPDATE productweights SET description=? WHERE ID=?", [this.description,this.ID]).then((res) {  
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

class ProductPackaging extends SyncCachable<ProductPackaging>  {
  // Static
  ProductPackaging._create(ID, this._description):super(ID);
  factory ProductPackaging (int ID, String description) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new ProductPackaging._create(ID, description);
  }
  static exists (int ID) => SyncCachable.exists(ProductPackaging, ID);
  static get (int ID) => SyncCachable.get(ProductPackaging, ID);

  static Future<bool> init() {
    Completer c = new Completer();
    Logger.root.info("Loading product weights list...");
    dbHandler.query("SELECT ID, description FROM packaging").then((Results results){
      results.listen((Row row) {
        ProductPackaging p = new ProductPackaging(row[0],row[1]);
      },
      onDone: () {
        c.complete(true);
        Logger.root.info("List loaded.");
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
  
  String get description => description;
  
  set description (String description) {
    if (description != _description) {
      _description = description;
      requiresDatabaseSync();
    }
  }


  Future<bool> updateDatabase (DatabaseHandler dbh) {
    Completer c = new Completer();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO packaging (description) VALUES (?)", [this.description]).then((res) {
        if (res.insertId != 0) {
          this._firstInsert(res.insertId);
          c.complete(true);
          Logger.root.info("Created new ${this.runtimeType} $description");
          
        }
        else {
          c.completeError("Unspecified mysql error");
          Logger.root.severe("Unspecified mysql error");
        }
      }).catchError((e) {
        c.completeError(e);
        Logger.root.severe("Error whilst creating ${this.runtimeType} $description :", e);
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

class Product extends SyncCachable<Product> {
  // Static
  Product._create(ID, this._name, this._validWeights, this._validPackaging, this._quickbooksName):super(ID);

  factory Product (int ID, String name, List<int> validWeights, List<int> validPackaging, String quickbooksName) {
    if (exists(ID)) {
      return get(ID);
    }
    else return new Product._create(ID, name, validWeights, validPackaging, quickbooksName);
  }

  static exists (int ID) => SyncCachable.exists(Product, ID);
  static get (int ID) => SyncCachable.get(Product, ID);

  static Future<bool> init() {
    Completer c = new Completer();
    Logger.root.info("Loading product list...");
    dbHandler.query("SELECT ID, productName, validWeights, validPackaging, quickbooksItem FROM products").then((Results results){
      results.listen((Row row) {
        List<int> vWeights = new List<int>();
        List<int> vPackaging = new List<int>();
        String vWeightString = row[2];
        String vPackagingString = row[3];
        vWeightString.split(",").forEach((String val) {
          vWeights.add(int.parse(val));
        });
        vPackagingString.split(",").forEach((String val) {
          vPackaging.add(int.parse(val));
        });
        new Product(row[0], row[1], vWeights, vPackaging, row[4]);
      },
      onDone: () {
        c.complete(true);
        Logger.root.info("List loaded.");
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
  
  String get name => _name;
  List<int> get validWeights => _validWeights;
  List<int> get validPackaging  => _validPackaging;
  String get quickbooksName => _quickbooksName;
  
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
  Future<bool> updateDatabase (DatabaseHandler dbh) {
    Completer c = new Completer();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO prdoucts (productName, validWeights, validPackaging, quickbooksItem) VALUES (?,?,?,?)", [name, validWeights.join(","), validPackaging.join(","), quickbooksName]).then((res) {
        if (res.insertId != 0) {
          this._firstInsert(res.insertId);
          c.complete(true);
          Logger.root.info("Created new ${this.runtimeType} $name");
          
        }
        else {
          c.completeError("Unspecified mysql error");
          Logger.root.severe("Unspecified mysql error");
        }
      }).catchError((e) {
        c.completeError(e);
        Logger.root.severe("Error whilst creating ${this.runtimeType} $name :", e);
      });
    }
    else {
      dbh.prepareExecute("UPDATE packaging SET productName=?, validWeights=?, validPackaging=?, quickbooksItem=? WHERE ID=?", [name, validWeights.join(","), validPackaging.join(","), quickbooksName, ID]).then((res) {  
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


class ProductGroup {
  String name;
  Product product;
  ProductWeight item;
  ProductPackaging packaging;

}