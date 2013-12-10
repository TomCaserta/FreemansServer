part of FreemansServer;


class DatabaseHandler {
  ConnectionPool _connectionPool;
  
  /// Caches the query
  Map<String, Query> _queryCache = new Map<String, Query>();
  
  DatabaseHandler (this._connectionPool);
  
  /// Executes a query  
  Future<Results> query(String sql) {
    return _connectionPool.query(sql);
  }
  
  /// Prepares an sql statement and returns the Query ready for execution. Prepared statement is cached.
  Future<Query> prepare (String sql) { 
    Completer c = new Completer();
    if (!_queryCache.containsKey(sql)) {
      _connectionPool.prepare(sql).then((Query E) {
        _queryCache[sql] = E;
        c.complete(E);
      }).catchError((e) { c.completeError(e); });
    }
    else {
      c.complete(_queryCache[sql]);
    }
    return c.future;
  }
  
  /// Prepares a sql statement then executes with the supplied parameters and caches the prepared statement.
  Future<Results> prepareExecute (String sql, List<dynamic> parameters) { 
    Completer c = new Completer();
    this.prepare(sql).then((Query q) { 
      c.complete(q.execute(parameters)); 
    }).catchError((e) { c.completeError(e); });
    return c.future;
  }
    
  /// Returns the number of rows a sql statement returns.
  Future<int> getNumRows (sql, parameters) { 
    Completer c = new Completer();
    this.prepareExecute(sql, parameters).then((row) { 
      row.listen((res) {
        c.complete(res[0]);
      }, onDone: () { 
        if (!c.isCompleted) c.complete(0);
      });
    }).catchError((e) { c.completeError(e); });
    return c.future;
  }
}