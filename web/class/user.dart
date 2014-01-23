part of FreemansClient;

class User {
  String UUID;
  int userID;
  String username;
  Permissions perm;
  User (this.UUID, this.userID, this.username, String permBlob) {
    perm = new Permissions.create(permBlob);
  }
}