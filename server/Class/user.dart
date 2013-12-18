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
  
  static Future<User> createNew (String name, String password, String permissions) {
    Completer c = new Completer();
    if (!exists(name)) {
      dbHandler.prepareExecute("INSERT INTO users (username, password, permissions) VALUES (?,?,?)", [name, password, permissions]).then((Results res) { 
           if (res.insertId != 0) {
             User u = new User(name, password, res.insertId, permissions);
             c.complete(u);
           }
           else {
             c.completeError("Unspecified mysql error");
             Logger.root.severe("Unspecified mysql error whilst inserting user $name");
           }
      });
    }
    else { 
      c.completeError("User already exists");
      Logger.root.warning("Attempted to create duplicate user $name");
    }
    
    return c.future;
  }
   
  static bool exists(String name) { 
    Iterable<User> users = SyncCachable.getVals(User);
    for (User user in users) {
      if (user.username == name) {
        return true;
      }
    }
    return false;
  }
  
  /// Warning returns null if user doesnt exist.
  static User getUser (String username, String password) {
    Iterable<User> users = SyncCachable.getVals(User);
    Iterable<User> u = users.where((e) => e.username == username && e.password == password);
    if (u.length > 0) {
      return u.elementAt(0);
    }
  }
  
  // Non static:
  bool isGuest = false;
  String username; 
  String password;
  Permissions permissions;
  
  User (this.username, this.password, ID, String permissionBlob):super(ID) {
    this.permissions = new Permissions.create(permissionBlob);
  }

  
  Future<bool> sendChangesToDatabase () {
    Completer c = new Completer();
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
  bool hasPermission (String perm) {
    return permissions.hasPermission(perm);
  }
  
  toJson () {
    return { "uID": id, "username": username, "permissions": permissions.toList() };
  }
}
