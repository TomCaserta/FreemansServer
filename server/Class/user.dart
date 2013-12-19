part of FreemansServer;

class User extends SyncCachable<User> {
  /// Initializes the user list into the application from the database
  static Future<bool> init () {
    Logger.root.info("Loading users list...");
    Completer c = new Completer();
    new User("Guest", "", 0, "").isGuest = true;
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
        Logger.root.info("Loaded user list...");
      },
      onError: (err) {
        c.completeError("Mysql error: $err");
        Logger.root.severe("Mysql error: $err");
      });
    }).catchError((e) {

      c.completeError("Error when selecting users from database: $e");
      Logger.root.severe("Error when selecting users from database", e);
    });
    return c.future;
  }

  Future<bool> updateDatabase(DatabaseHandler dbh) {
    Completer c = new Completer<bool>();
    if (this.isNew) {
      dbHandler.prepareExecute("INSERT INTO users (username, password, permissions) VALUES (?,?,?)", [username, password, permissions]).then((Results res) {
        if (res.insertId != 0) {
          this._firstInsert(res.insertId);
          c.complete(true);
        }
        else {
          c.completeError("Unspecified mysql error");
          Logger.root.severe("Unspecified mysql error whilst inserting user $username");
        }
      });
    }
    else {
      dbHandler.prepareExecute("UPDATE users SET `name`=?, `password`=?, `permissions`=? WHERE ID=?",[this.username, this.password, this.permissions.toString()]).then((row) {
        if (row.affectedRows == 1) {
          c.complete(true);
          Logger.root.info("Updated user $username");
        }
        else {
          c.completeError("Unspecified error occurred when updating user $username (${row.affectedRows} Rows Updated)");
          Logger.root.severe("Unspecified error occurred when updating user $username (${row.affectedRows} Rows Updated)");
        }
      });
    }
    return c.future;
  }


  static bool exists(String name) {
    return SyncCachable.exists(User, name);
  }

  /// Warning returns null if user doesnt exist.
  static User getUser (String username, String password) {
    Iterable<User> users = SyncCachable.getVals(User);
    Iterable<User> u = users.where((e) => e.username == username && e.password == password);
    if (u.length > 0) {
      return u.elementAt(0);
    }
  }

  static User get(String username) => SyncCachable.get(User, username);

  // Non static:
  bool isGuest = false;
  String username;
  String password;
  Permissions permissions;

  User._create (String username, this.password, int ID, String permissionBlob):super(ID, username) {
    this.username = username;
    this.permissions = new Permissions.create(permissionBlob);
  }

  factory User (String username, String password, int ID, String permissionBlob) {
     if (exists(username)) {
       return get(username);
     }
     else {
       return new User._create(username, password, ID, permissionBlob);
     }
  }

  bool hasPermission (String perm) {
    return permissions.hasPermission(perm);
  }

  toJson () {
    return { "uID": id, "username": username, "permissions": permissions.toList() };
  }
}
