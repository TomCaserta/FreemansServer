part of FreemansClient;

class User {
  int userID;
  String username;
  Permissions perm;
  User (this.userID, this.username, String permBlob) {
    perm = new Permissions.create(permBlob);
  }
}