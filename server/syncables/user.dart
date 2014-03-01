part of FreemansServer;

class User extends Syncable<User> {
  int type = SyncableTypes.USER;
  bool _isGuest = false;
  String _username;
  String _password;
  Permissions _permissions;

  bool get isGuest => _isGuest;
  @IncludeSchema()
  String get username => _username;
  @IncludeSchema(isOptional: true)
  String get password => _password;
  @IncludeSchema()
  Permissions get permissions => _permissions;

  void mergeJson (Map jsonMap) {
    this.username = jsonMap["username"];
    if (jsonMap["password"] != null) this.password = jsonMap["password"];
    this.permissions = new Permissions.create(jsonMap["permissions"]);
    super.mergeJson(jsonMap);
  }

  set isGuest (bool isGuest) {
    if (isGuest != _isGuest) {
      _isGuest = isGuest;
      requiresDatabaseSync();
    }
  }

  set username (String username) {
    if (username != _username) {
      _username = username;
      requiresDatabaseSync();
    }
  }
  
  set password (  String password) {
    if (password != _password) {
      _password = password;
      requiresDatabaseSync();
    }
  }
  
  set permissions (Permissions permissions) {
    if (permissions != _permissions) {
      _permissions = permissions;
      requiresDatabaseSync();
    }
  }
  
  User._create (String username, this._password, int ID, String permissionBlob):super(ID, username) {
    this._username = username;
    this._permissions = new Permissions.create(permissionBlob);
  }
  User.fromJson (Map params):super.fromJson(params);



  factory User (String username, String password, int ID, String permissionBlob) {
     if (exists(username)) {
       return get(username);
     }
     else {
       return new User._create(username, password, ID, permissionBlob);
     }
  }

  Future<bool> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer<bool>();
    if (this.isNew) {
      dbHandler.prepareExecute("INSERT INTO users (username, password, permissions) VALUES (?,?,?)", [username, password, permissions]).then((Results res) {
        if (res.insertId != 0) {
          this._firstInsert(res.insertId);
          c.complete(true);
        }
        else {
          c.completeError("Unspecified mysql error");
          ffpServerLog.severe("Unspecified mysql error whilst inserting user $username");
        }
      });
    }
    else {
      dbHandler.prepareExecute("UPDATE users SET `name`=?, `password`=?, `permissions`=? WHERE ID=?",[this.username, this.password, this.permissions.toString()]).then((row) {
        if (row.affectedRows == 1) {
          c.complete(true);
          ffpServerLog.info("Updated user $username");
        }
        else {
          c.completeError("Unspecified error occurred when updating user $username (${row.affectedRows} Rows Updated)");
          ffpServerLog.severe("Unspecified error occurred when updating user $username (${row.affectedRows} Rows Updated)");
        }
      });
    }
    return c.future;
  }
  
  bool hasPermission (String perm) {
    return permissions.hasPermission(perm);
  }

  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({ "username": username, "permissions": permissions.toString() });
  }
  
  /*****************************
   ***********STATIC************
   *****************************/
  
  
  /// Initializes the user list into the application from the database
  static Future<bool> init () {
    ffpServerLog.info("Loading users list...");
    Completer c = new Completer();
    new User("Guest", "", -1, "").._isGuest = true;
    dbHandler.query("SELECT ID, username, password, permissions FROM users").then((res) {
      res.listen((rowData) {
        int uID = rowData[0];
        String username = rowData[1];
        String password = rowData[2];
        String permissions = rowData[3].toString();
        new User(username, password, uID, permissions);
      },
      onDone: () {
        c.complete(true);
        ffpServerLog.info("Loaded user list...");
      },
      onError: (err) {
        c.completeError("Mysql error: $err");
        ffpServerLog.severe("Mysql error: $err");
      });
    }).catchError((e) {

      c.completeError("Error when selecting users from database: $e");
      ffpServerLog.severe("Error when selecting users from database", e);
    });
    return c.future;
  }

  static bool exists(String name) {
    return Syncable.exists(User, name);
  }

  /// Finds a user where the username and password matches the supplied username and password.
  /// Password is the plaintext password.
  static User getUser (String username, String password) {
    List users = Syncable.getVals(User).toList();
    Iterable<User> u = users.where((e) => e.username == username && e.password == password);

    if (u.length > 0) {
      return u.elementAt(0);
    }
  }

  static User get(String username) => Syncable.get(User, username);

}
