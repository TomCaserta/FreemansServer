part of FreemansServer;

abstract class Cachable<T> {
  
  
  /// Syncables parent object. Used to tell the parent that it contains objects that require a database sync.
  Cachable<T> _parent;
  
  /// ID of the Syncable. Should match the database ID. IS NOT UNIQUE ACROSS OBJECT TYPES.
  int id = 0;
  
  /// Defines weather a Syncable is new data to be inserted into the database
  bool _newInsert = false;
  
  /// Defines weather a Syncable has changed at all. If true, [updateDatabase()] will resync the data with the database
  bool _hasChange = false;
  
  /// Contains a list of child [Syncable]'s with data that has changed.
  List<Cachable> changedChildElements = new List<Cachable>();
  
  /// Returns weather a row is new or not.
  bool get isNew => _newInsert;
  
  static Map<Type, Map<int, Cachable>> _cache = new Map<Type, Map<int, Cachable>>();
  Cachable (int ID) {
    this.id = ID;
    if (id != 0) {
     _put(this);
    }
    else setNew();
  }
  
  static Cachable get (Type t, int ID) {
    if (_cache.containsKey(t)) {
      if (exists(t, ID)) {
        return _cache[t][ID];
      }
    }
    return null;
  }

  static bool exists (Type t, int id) {
    if (_cache.containsKey(t)) {
      return _cache[t].containsKey(id); 
    }
    else {
      return false;
    }
  }
  
  void _put (Cachable<T> obj) {
    if (!_cache.containsKey(T)) _cache[T] = new Map<int, Cachable>();
      if (id != 0) {
        if (!exists(T, id)) {
        _cache[T][id] = this;
      }
      else {
        throw "Object already exists";
      }
    }
  }

  Cachable<T> getO (int ID) {
    return get(T, ID);
  }
  
  bool existsO (int id) {
    return exists(T, id);
  }
  
  /// Sets a Syncable as a new insert.
  void setNew () {
    _newInsert = true;
  }
  void _firstInsert (int ID) {
    if (_newInsert) {
      this.id = ID;
      _newInsert = false;
      _put(this);
    }
    else {
      Logger.root.severe("firstInsert() called on ${this.runtimeType} ID: $id however this row is not first time insert.");
    }
  }
  
  /// Called by a syncable object when a database update is required.
  void requiresDatabaseSync ([Cachable child = null]) {
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
    changedChildElements = new List<Cachable>();
  }
  
  void setParent (Cachable parent) {
    _parent = parent;
  }
  
  /// Overridden, destroys the object from the server and database.
  Future<bool> destroy () {
    Completer c = new Completer();
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