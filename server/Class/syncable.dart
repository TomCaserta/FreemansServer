part of FreemansServer;


abstract class SyncCachable<T> {
  
  
  /// Syncables parent object. Used to tell the parent that it contains objects that require a database sync.
  SyncCachable<T> _parent;
  
  /// ID of the Syncable. Should match the database ID. IS NOT UNIQUE ACROSS OBJECT TYPES.
  int id = 0;
  
  /// Defines weather a Syncable is new data to be inserted into the database
  bool _newInsert = false;
  
  /// Defines weather a Syncable has changed at all. If true, [updateDatabase()] will resync the data with the database
  bool _hasChange = false;
  
  /// Contains a list of child [Syncable]'s with data that has changed.
  List<SyncCachable> changedChildElements = new List<SyncCachable>();
  
  /// Returns weather a row is new or not.
  bool get isNew => _newInsert;
  dynamic tempKey;
  
  static Map<Type, Map<int, SyncCachable>> _cache = new Map<Type, Map<dynamic, SyncCachable>>();
  SyncCachable (int ID, [dynamic key]) {
    this.id = ID;
    if (id != 0) {
      _put(key != null ? key : ID);
      
    }
    else {
      tempKey = key;
      setNew();
    }
  }
  
 
  static SyncCachable get (Type t, dynamic key) {
    if (_cache.containsKey(t)) {
      if (exists(t, key)) {
        return _cache[t][key];
      }
    }
    return null;
  }

  static bool exists (Type t, dynamic key) {
    if (_cache.containsKey(t)) {
      return _cache[t].containsKey(key); 
    }
    else {
      return false;
    }
  }
  
  void _put (dynamic key) {
    if (!_cache.containsKey(T)) _cache[T] = new Map<dynamic, SyncCachable>();
      if (id != 0) {
        
        if (!exists(T, key)) {
        _cache[T][key] = this;
      }
      else {
        throw "Object already exists";
      }
    }
  }
  
  static Map<dynamic, SyncCachable> getMap (Type t) {
    if (!_cache.containsKey(t)) _cache[t] = new Map<dynamic, SyncCachable>();
    return _cache[t];
  }
  
  static getVals (Type t) {
    if (!_cache.containsKey(t)) _cache[t] = new Map<dynamic, SyncCachable>();
    return _cache[t].values;
  }

  Iterable<T> getValsO () {
    return getVals(T);
  }
  
 
  Map<dynamic, T> getMapO () {
    return getMap(T);
  }
  

  SyncCachable<T> getO (dynamic key) {
    return get(T, key);
  }
  
  bool existsO (dynamic key) {
    return exists(T, key);
  }
  
  /// Sets a Syncable as a new insert.
  void setNew () {
    _newInsert = true;
  }
  void _firstInsert (int ID) {
    if (_newInsert) {
      this.id = ID;
      _newInsert = false;
      _put(tempKey != null ? tempKey : ID);
      tempKey = null;
    }
    else {
      Logger.root.severe("firstInsert() called on ${this.runtimeType} ID: $id however this row is not first time insert.");
    }
  }
  
  /// Called by a syncable object when a database update is required.
  void requiresDatabaseSync ([SyncCachable child = null]) {
    if (_hasChange == false) {
      _hasChange = true;
      if (child != null) {
        changedChildElements.add(child);
      }
      if (_parent != null) _parent.requiresDatabaseSync();
    }
  }
  
  /// Used to update the synced status of a Syncable
  void synced () {
    changedChildElements.forEach((e) { 
      e.synced();
    });        
    _hasChange = false;
    changedChildElements = new List<SyncCachable>();
  }
  
  void setParent (SyncCachable parent) {
    _parent = parent;
  }
  
  /// Overridden, destroys the object from the server and database.
  Future<bool> destroy () {
    Completer<bool> c = new Completer<bool>();
    Logger.root.severe("Syncable object ${this.runtimeType} cannot be destroyed. Shutting down to prevent data being out of sync.");
    c.completeError("Syncable object cannot be destroyed.");
    return c.future;
  }
  
  /// Called when a update to the database is occuring.
  Future<bool> updateDatabase (DatabaseHandler dbh) {
    Completer c = new Completer();
    Logger.root.severe("Syncable object ${this.runtimeType} does not implement a database update method. Shutting down to prevent data being out of sync.");
    c.completeError("Syncable object does not implement a database update method.");
    return c.future;
  }
}

class QBSyncCachable<T> extends SyncCachable<T> {
  QBSyncCachable(int ID):super(ID);
  // TODO: Implement QB syncing
}