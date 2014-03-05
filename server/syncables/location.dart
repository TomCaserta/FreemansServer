part of FreemansServer;

class Location extends Syncable<Location> {
  int type = SyncableTypes.LOCATION;
  String _locationName;
  
  @IncludeSchema()
  String get locationName => _locationName;
  
  
  set locationName (String locationName) {
    if (_locationName != locationName) {
      _locationName = locationName;
      requiresDatabaseSync();
    }
  }
    
  Location._create(int id):super(id);
  
  factory Location (int ID) {
    if (exists(ID)) {
      return get(ID);
    } else {
      return new Location._create(ID);
    }
  }

  static exists(int ID) => Syncable.exists(Location, ID);
  static get(int ID) => Syncable.get(Location, ID);
  
  Location.fromJson(Map jsonMap):super.fromJson(jsonMap);
  
  void mergeJson(Map jsonMap) {
    this.locationName = jsonMap["locationName"];
    super.mergeJson(jsonMap);
  }
  
  Future<bool> updateDatabase (DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (this.isNew) {   
      dbh.prepareExecute("INSERT INTO locations (locationName, isActive) VALUES (?, ?)", [this.locationName, (isActive ? 1 : 0)]).then((Results r) { 
        if (r.insertId != 0) {
           _firstInsert(r.insertId);
           c.complete(true);
        } else {
           c.completeError("Unspecified mysql error");
        }
      }).catchError((e) => c.completeError(e));
    }
    else {
      dbh.prepareExecute("UPDATE locations SET locationName=?, isActive=? WHERE ID=?", [this.locationName, (isActive ? 1 : 0), this.ID]).then((Results res) { 
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
    ffpServerLog.info("Loading Locations list...");
    dbHandler.query("SELECT ID, locationName, isActive FROM locations").then((Results results){
      results.listen((Row row) {
        Location location = new Location(row[0]);
        location.locationName = row[1];
        location._isActive = row[2] == 1;
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
    return super.toJson()..addAll({ "locationName": locationName });
  }
}