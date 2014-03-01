part of DataObjects;

class User extends Syncable {
  final int type = SyncableTypes.USER;
  String username;
  Permissions permissions;
  String password;
  User();
  User.fromJson (Map jsonMap):super.fromJson(jsonMap) {
  }
  void mergeJson (Map jsonMap) {
    this.username = jsonMap["username"];
    this.permissions =  new Permissions.create(jsonMap["permissions"]);
    super.mergeJson(jsonMap);
  }
  Map<String, dynamic> toJson () {
    return super.toJson()..addAll({  "username": username, "permissions": permissions.toString(), "password": password });
  }
}