part of FreemansServer;


abstract class Syncable<T> {

  /// Cache of Objects which extend Syncable
  static Map<Type, Map<int, Syncable>> _cache = new Map<Type, Map<dynamic, Syncable>>();

  static Map<String, Syncable> _UuidToSyncable = new Map<String, Syncable>();

  static Syncable getByUuid(String Uuid, [ int typeCheck]) {
    Syncable s = _UuidToSyncable[Uuid];
    if (s != null) {
      if (typeCheck != null) {
        if (s.type != typeCheck) {
          return null;
        }
      }
      return s;
    }
    return null;
  }


  Syncable.fromJson(Map payload) {
    while (_UuidToSyncable.containsKey(this.Uuid)) this.Uuid = new uuid.Uuid().v4();
    _UuidToSyncable[this.Uuid] = this;
    setNew();
    this.mergeJson(payload);
  }

  int type = 0;

  /// Syncables parent object. Used to tell the parent that it contains objects that require a database sync.
  Syncable _parent;

  /// ID of the Syncable. Should match the database ID. IS NOT UNIQUE ACROSS OBJECT TYPES.
  @IncludeSchema()

  int ID = 0;

  /// UUID of the current object. 100% Unique accross all Syncables. Regenerates if in the HIGHLY unlikely event of collision.
  @IncludeSchema()

  String Uuid = new uuid.Uuid().v4();

  /// Defines if the Syncable is active
  bool _isActive = true;

  /// Defines weather a Syncable is new data to be inserted into the database
  bool _newInsert = false;

  /// Defines weather a Syncable has changed at all. If true, [updateDatabase()] will resync the data with the database
  bool _hasChange = false;

  /// Contains a list of child [Syncable]'s with data that has changed.
  List<Syncable> changedChildElements = new List<Syncable>();

  /// Contains a list of child [Syncable]'s
  List<Syncable> childElements = new List<Syncable>();

  /// Getter to check if the result is a new object which hasnt been inserted into the database yet.

  bool get isNew => _newInsert;

  /// Getter to check if the object has been soft deleted.
  /// If [isActive] is false, it will not show up in list queries
  @IncludeSchema()

  bool get isActive => _isActive;

  set isActive(bool active) {
    if (active != _isActive) {
      childElements.forEach((e) {
        e.isActive = active;
      });
      _isActive = active;
      requiresDatabaseSync();
    }
  }

  /// Temporary key to use to cache the object until it has been stored into the database.
  dynamic tempKey;

  /***
   * Creates a new instance, if the ID is 0 it assumes the object is new
   * and therefore is needing to be inserted into the database.
   * 
   * You can supply the [key] parameter to temporarily store the object into the cache... 
   * Otherwise the object is not cached until after it has been synced.
   */

  Syncable(this.ID, [dynamic key]) {
    while (_UuidToSyncable.containsKey(this.Uuid)) this.Uuid = new uuid.Uuid().v4();
    _UuidToSyncable[this.Uuid] = this;
    if (ID != 0) {
      _put(key != null ? key : ID);
    } else {
      tempKey = key;
      setNew();
    }
  }


  static Syncable get(Type t, dynamic key) {
    if (_cache.containsKey(t)) {
      if (exists(t, key)) {
        return _cache[t][key];
      }
    }
    return null;
  }

  static bool exists(Type t, dynamic key) {
    if (_cache.containsKey(t)) {
      return _cache[t].containsKey(key);
    } else {
      return false;
    }
  }

  void _put(dynamic key) {
    if (!_cache.containsKey(T)) _cache[T] = new Map<dynamic, Syncable>();
    if (!exists(T, key)) {
      if (ID != 0) {
        _cache[T][key] = this;
      }
    } else {
      ffpServerLog.severe("Object already exists");
    }
  }

  static Map<dynamic, Syncable> getMap(Type t) {
    if (!_cache.containsKey(t)) _cache[t] = new Map<dynamic, Syncable>();
    return _cache[t];
  }

  static List getVals(Type t) {
    if (!_cache.containsKey(t)) _cache[t] = new Map<dynamic, Syncable>();
    return _cache[t].values.toList();
  }

  Iterable<T> getValsO() {
    return getVals(T);
  }


  Map<dynamic, T> getMapO() {
    return getMap(T);
  }


  Syncable<T> getO(dynamic key) {
    return get(T, key);
  }

  bool existsO(dynamic key) {
    return exists(T, key);
  }

  /// Sets a Syncable as a new insert.

  void setNew() {
    _newInsert = true;
    requiresDatabaseSync();
  }

  void _firstInsert(int identifier) {
    if (_newInsert) {
      this.ID = identifier;
      _newInsert = false;
      _isActive = true;
      _put(tempKey != null ? tempKey : identifier);
      synced();
      tempKey = null;
    } else {
      ffpServerLog.severe("firstInsert() called on ${this.runtimeType} ID: $ID however this row is not first time insert.");
    }
  }


  /// Called by a syncable object when a database update is required.

  void requiresDatabaseSync([Syncable child = null]) {
    if (child != null) {
      changedChildElements.add(child);
    }
    if (_hasChange == false) {
      _hasChange = true;
      if (_parent != null) _parent.requiresDatabaseSync(this);
    }
  }

  /// Used to update the synced status of a Syncable

  void synced() {
    if (_parent != null) _parent._childSynced(this);
    _hasChange = false;
  }

  void _childSynced(Syncable child) {
    if (changedChildElements.contains(child)) {
      changedChildElements.remove(child);
    }
  }

  void addChild(Syncable child) {
    childElements.add(child);
  }

  void removeChild(Syncable child) {
    _childSynced(child);
    if (childElements.contains(child)) childElements.remove(child);
  }

  /***
   * Merges the jsonMap to the syncables data
   */

  void mergeJson(Map jsonMap) {
    this.isActive = jsonMap["isActive"];
  }

  void addParent(Syncable parent) {
    if (_parent == null && parent != null) {
      _parent = parent;
      if (parent != null) {
        parent.addChild(this);
      }
    }
  }

  void detatchParent() {
    if (_parent != null) _parent.removeChild(this);
    _parent = null;
  }

  /// Called when a update to the database is occuring.

  Future<dynamic> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    ffpServerLog.warning("Syncable object ${this.runtimeType} does not implement a database update method.");
    c.complete(false);
    return c.future;
  }

  Map<String, dynamic> toJson() {
    return {
        "Uuid": Uuid, "ID": ID, "isActive": isActive
    };
  }
}

class QBSyncCachable<T> extends Syncable<T> {
  QBSyncCachable(int ID):super(ID);
// TODO: Implement QB syncing
}