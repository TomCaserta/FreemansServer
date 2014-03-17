part of FreemansServer;

class Options extends Syncable<Options> {
  int type = SyncableTypes.OPTION;
  String _name;
  bool _isActive = true;
  bool get isActive => true;

  @IncludeSchema()
  String get name => _name;


  set name (String name) {
    if (_name != name) {
      _name = name;
      requiresDatabaseSync();
    }
  }

  String _option;
  @IncludeSchema()
  String get option => _option;

  set option (String option) {
    if (_option != option) {
      _option = option;
      requiresDatabaseSync();
    }
  }

  Options._create(int id):super(id);

  factory Options (int ID) {
    if (exists(ID)) {
      return get(ID);
    } else {
      return new  Options._create(ID);
    }
  }

  static exists(int ID) => Syncable.exists(Options, ID);
  static get(int ID) => Syncable.get(Options, ID);

  Options.fromJson(Map jsonMap):super.fromJson(jsonMap);

  void mergeJson(Map jsonMap) {
    this.name = jsonMap["name"];
    this.option = jsonMap["option"];
    super.mergeJson(jsonMap);
  }

  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (this.isNew) {
      dbh.prepareExecute("INSERT INTO company_options (name, data) VALUES (?, ?)", [name, option]).then((Results r) {
        if (r.insertId != 0) {
          _firstInsert(r.insertId);
          c.complete(true);
        } else {
          c.completeError("Unspecified mysql error");
        }
      }).catchError((e) => c.completeError(e));
    }
    else {
      dbh.prepareExecute("UPDATE company_options SET name=?, data=? WHERE ID=?", [this.name, this.option, this.ID]).then((Results res) {
        if (res.affectedRows <= 1) {
          synced();
          c.complete(true);
        } else {
          c.completeError("Query affected ${res.affectedRows} instead of just one.");
        }
      }).catchError((e) => c.completeError(e));
    }
    return c.future;
  }

  static Future<bool> init() {
    Completer c = new Completer();
    ffpServerLog.info("Loading Options list...");
    dbHandler.query("SELECT ID,  name, data FROM company_options").then((Results results){
      results.listen((Row row) {
        Options opt = new Options(row[0]);
        opt.name = row[1];
        opt.option = row[2].toString();
        opt._isActive = true;
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


  Map toJson () {
    return super.toJson()..addAll({ "name": name, "option": option });
  }
}
