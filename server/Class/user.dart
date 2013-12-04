part of FreemansServer;

class User {
  static List<User> users = new List<User>();
  static Future<bool> init () {
    Completer c = new Completer();
    new User("Guest", "", 0, "").isGuest = true;
    dbHandler.prepareExecute("SELECT ID, username, password, permissions FROM users", []).then((res) { 
      res.listen((rowData) { 
        int uID = rowData[0];
        String username = rowData[1];
        String password = rowData[2];
        String permissions = rowData[3];
        new User(username, password, uID, permissions);
      },
      onDone: () {
        c.complete();
      },
      onError: (err) {
        c.completeError("Mysql error: $err");
      });
    });
    return c.future;
  }
   
  /// Warning returns null if user doesnt exist.
  static User getUser (String username, String password) {
    Iterable<User> u = users.where((e) => e.username == username && e.password == password);
    if (u.length > 0) {
      return u.elementAt(0);
    }
  }
  
  // Non static:
  bool isGuest = false;
  int userID;
  String username; 
  String password;
  Permissions permissions;
  
  User (this.username, this.password, this.userID, String permissionBlob) {
    users.add(this);
    this.permissions = new Permissions.create(permissionBlob);
  }
  
  bool hasPermission (String perm) {
    return permissions.hasPermission(perm);
  }
  
  toJson () {
    return { "uID": userID, "username": username, "permissions": permissions.toList() };
  }
}
