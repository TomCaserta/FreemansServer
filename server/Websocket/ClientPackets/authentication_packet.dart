part of FreemansServer;


class ClientPacketAuthenticate extends ClientPacket {
  static final int ID = 1;
  String username;
  String password;
  String respID;
  ClientPacketAuthenticate.create(this.respID, this.username, this.password);
  void handlePacket (WebsocketHandler wsh, Client client) {
    
    dbHandler.prepareExecute("SELECT ID, username FROM users WHERE username = ? AND password = ?", [this.username, this.password]).then((res) { 
      bool completedLogin = false;
      res.stream.listen((rowData) { 
        completedLogin = true;
        print(rowData);
      },
      onDone: () {
        if (completedLogin == true) {
          client.sendPacket(new UserPassIncorrectServerPacket(respID));
        } 
        else {
          client.sendPacket(new LoggedInServerPacket());
        }
      },
      onError: (err) {
        throw err;
      });
    });
  }
}