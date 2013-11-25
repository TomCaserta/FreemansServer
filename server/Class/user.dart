part of FreemansServer;

class User {
  static List<User> users = new List<User>();
  static Future<bool> init () {
    Completer c = new Completer();
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
  
  
  
  // Non static:

  int userID;
  String username; 
  String password;
  Permissions permissions;
  
  User (this.username, this.password, this.userID, String permissionBlob) {
    users.add(this);
    this.permissions = new Permissions.create(permissionBlob);
  }
}

class PermissionNode {
  PermissionNode parentNode;
  String nodeName = "";
  Map<String, PermissionNode> _childNodes = new Map<String, PermissionNode>();
  bool nodeValue = false;
  get hasChildNodes {
    return _childNodes.length != 0;
  }
  void add (PermissionNode node) {
    _childNodes[node.nodeName] = node;
  }
  
  PermissionNode get (String nodename) {
    if (exists(nodename)) {
      return _childNodes[nodename];
    }
  }
  bool exists (String nodename) {
    return _childNodes.containsKey(nodename);
  }
  
  PermissionNode(this.nodeName);
}

class Permissions {
  PermissionNode permissions = new PermissionNode("root");
  
  Permissions.create(String permissionBlob) {
    _recurseAdd(permissionBlob, this.permissions);
  }
  
  void _recurseAdd (String permish, PermissionNode parent) {
    List<String> splitPerm = permish.split(",");
    splitPerm.forEach((perm) { 
      List<String> subPermission = perm.split(".");
      if (subPermission.length > 1) {
        if (parent.exists(subPermission[0])) {
          PermissionNode node = new PermissionNode(subPermission[0]);
          parent.add(node);
          _recurseAdd(subPermission.getRange(1,subPermission.length).join("."), node);
        }
      }
      else {
        if (subPermission[0] != "*") {
          PermissionNode node = new PermissionNode(subPermission[0]);
          node.nodeValue = true;
          parent.add(node);
        }
        else {
          parent.nodeValue = true;
        }
      }
    });
  }
  
  bool _recursePermissionCheck (PermissionNode parent, String permString) {
    List<String> permList = permString.split(".");
    for (int x = 0; x < permList.length; x++) {
      if (parent.exists(permList[x])) {
        if (x == (permList.length - 1)) {
          return parent.get(permList[x]).nodeValue;
        }
        else {
          PermissionNode p = parent.get(permList[x]);
          if (p.nodeValue == true) {
            return true;
          }
          else {
            return _recursePermissionCheck(p, permList.getRange(1, permList.length).join("."));
          }
        }
      }
      else {
        return false;
      }
    }
  }
  
  bool hasPermission (String permissionString) {
    return _recursePermissionCheck (permissions, permissionString);
  }
}