library Permissions;

class PermissionNode {
  PermissionNode parentNode;
  String nodeName = "";
  Map<String, PermissionNode> _childNodes = new Map<String, PermissionNode>();
  bool _nodeValue = false;
  set nodeValue(bool val) {
    _nodeValue = val;
  }
  get nodeValue {
    return this._nodeValue;
  }
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

  Map<String, PermissionNode> get childNodes => _childNodes;

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
        if (!parent.exists(subPermission[0])) {
          PermissionNode node = new PermissionNode(subPermission[0]);
          parent.add(node);
          _recurseAdd(subPermission.getRange(1,subPermission.length).join("."), node);
        }
        else {
          _recurseAdd(subPermission.getRange(1,subPermission.length).join("."), parent.get(subPermission[0]));
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
    if (parent.nodeValue == true) return true;
    else {
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
  }

  bool hasPermission (String permissionString) {
    return _recursePermissionCheck (permissions, permissionString);
  }

  List<String> _recurseToString (PermissionNode parent, String curNodeStr, [bool override = false]) {
    List<String> tempL = new List<String>();
    curNodeStr = "$curNodeStr${(override ? "" : parent.nodeName)}";
    if (parent.hasChildNodes) {
      parent.childNodes.forEach((nodeName, node) {
        tempL.addAll(_recurseToString(node, "$curNodeStr${(override ? "" : ".")}"));
      });
    }
    if (parent.nodeValue == true) tempL.add((curNodeStr == "" ? "*" : "$curNodeStr.*"));
    return tempL;
  }
  toList () {
    return _recurseToString(permissions, "", true);
  }
  toString() {
    return _recurseToString(permissions, "", true).join(",");
  }
}