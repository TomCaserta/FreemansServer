part of FreemansServer;


abstract class SyncCachable<T> {
  /// Syncables parent object. Used to tell the parent that it contains objects that require a database sync.
  SyncCachable _parent;

  /// ID of the Syncable. Should match the database ID. IS NOT UNIQUE ACROSS OBJECT TYPES.
  int ID = 0;
  String UUID = new Uuid().v4();
  
  
  bool _isActive = true;

  /// Defines weather a Syncable is new data to be inserted into the database
  bool _newInsert = false;

  /// Defines weather a Syncable has changed at all. If true, [updateDatabase()] will resync the data with the database
  bool _hasChange = false;

  /// Contains a list of child [Syncable]'s with data that has changed.
  List<SyncCachable> changedChildElements = new List<SyncCachable>();
  
  /// Contains a list of child [Syncable]'s
  List<SyncCachable> childElements = new List<SyncCachable>();

  /// Returns weather a row is new or not.
  bool get isNew => _newInsert;
  bool get isActive => _isActive; 
  
  set isActive (bool active) {
    if (active != _isActive) {
      childElements.forEach((e) {
        e.isActive = active;
      });
      requiresDatabaseSync();
    }
  }
  
  
  dynamic tempKey;

  static Map<Type, Map<int, SyncCachable>> _cache = new Map<Type, Map<dynamic, SyncCachable>>();

  SyncCachable (this.ID, [dynamic key]) {
    if (ID != 0) {
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
    if (!exists(T, key)) {
      if (ID != 0) {
        _cache[T][key] = this;
      }
    }
    else {
      ffpServerLog.severe("Object already exists");
    }
  }

  static Map<dynamic, SyncCachable> getMap (Type t) {
    if (!_cache.containsKey(t)) _cache[t] = new Map<dynamic, SyncCachable>();
    return _cache[t];
  }

  static List getVals (Type t) {
    if (!_cache.containsKey(t)) _cache[t] = new Map<dynamic, SyncCachable>();
    return _cache[t].values.toList();
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
    requiresDatabaseSync();
  }
  
  void _firstInsert (int identifier) {
    if (_newInsert) {
      this.ID = identifier;
      _newInsert = false;
      _put(tempKey != null ? tempKey : identifier);
      synced();
      tempKey = null;
    }
    else {
      ffpServerLog.severe("firstInsert() called on ${this.runtimeType} ID: $ID however this row is not first time insert.");
    }
  }
  
  

  /// Called by a syncable object when a database update is required.
  void requiresDatabaseSync ([SyncCachable child = null]) {
    if (child != null) {
      changedChildElements.add(child);
    }
    if (_hasChange == false) {
      _hasChange = true;
      if (_parent != null) _parent.requiresDatabaseSync(this);
    }
  }

  /// Used to update the synced status of a Syncable
  void synced () {
    if (_parent != null) _parent._childSynced(this);
    _hasChange = false;
  }

  void _childSynced (SyncCachable child) {
    if (changedChildElements.contains(child)) {
      changedChildElements.remove(child);
    }
  }
  
  void addChild (SyncCachable child) {
    childElements.add(child);
  }
  
  void removeChild (SyncCachable child) {
    _childSynced(child);
    if (childElements.contains(child)) childElements.remove(child);
  }
  
  void addParent (SyncCachable parent) {
    if (_parent == null && parent != null) {
      _parent = parent;
      if (parent != null) {
        parent.addChild(this);
      }
    }
  }
  
  void detatchParent () {
    if (_parent != null) _parent.removeChild(this);
    _parent = null;
  }
  
  /// Called when a update to the database is occuring.
  Future<bool> updateDatabase (DatabaseHandler dbh) {
    Completer c = new Completer();
    ffpServerLog.warning("Syncable object ${this.runtimeType} does not implement a database update method.");
    c.complete(false);
    return c.future;
  }
  Map<String, dynamic> toJson() { 
    return { "UUID": UUID, "ID": ID };
  }
}

class QBSyncCachable<T> extends SyncCachable<T> {
  QBSyncCachable(int ID):super(ID);
  // TODO: Implement QB syncing
}