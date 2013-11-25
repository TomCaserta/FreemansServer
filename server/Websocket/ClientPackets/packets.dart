part of FreemansServer;


class AuthenticateClientPacket extends ClientPacket {
  static final int ID = CLIENT_PACKET_IDS.AUTHENTICATE;
  String username;
  String password;
  String respID;
  AuthenticateClientPacket.create(this.respID, this.username, this.password);
  void handlePacket (WebsocketHandler wsh, Client client) {
    // Query our database for the allowed users
    dbHandler.prepareExecute("SELECT ID, username FROM users WHERE username = ? AND password = ?", [this.username, this.password]).then((res) { 
      bool completedLogin = false;
      res.listen((rowData) { 
        completedLogin = true;
        print(rowData);
      },
      onDone: () {
        if (!completedLogin) {
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



class PingPongClientPacket extends ClientPacket {
  static final int ID = CLIENT_PACKET_IDS.PING_PONG;
  bool ping;
  String responseID;
  PingPongClientPacket.create (this.responseID, this.ping);
  
  void handlePacket(WebsocketHandler wsh, Client client) {
     if (ping == true) {
       client.sendPacket(new PingPongServerPacket(this.responseID, false));
     }
  }
}

class DataChangeClientPacket extends ClientPacket {
  static final int ID = CLIENT_PACKET_IDS.DATA_CHANGE;
  String change = "";
  int type = 0;
  String identifier = "";
  DataChangeClientPacket.create (this.change, this.type, this.identifier);
  void handlePacket (WebsocketHandler wsh, Client client) {
    
  }
}

class SupplierAddClientPacket extends ClientPacket {
  String supplierName = "";
  String rID = "";
  SupplierAddClientPacket (this.supplierName, this.rID);
  void handlePacket (WebsocketHandler wsh, Client client) {
    
  }
}

class CustomerAddClientPacket extends ClientPacket {
  String customerName = "";
  String rID = "";
  CustomerAddClientPacket (this.customerName, this.rID);
  void handlePacket (WebsocketHandler wsh, Client client) {
    
  }
}

class TransportAddClientPacket extends ClientPacket {
  String transportName = "";
  String rID = "";
  TransportAddClientPacket (this.transportName, this.rID);   
  void handlePacket (WebsocketHandler wsh, Client client) {
    
  }
}

class FileRequestClientPacket extends ClientPacket {
  
}

class CLIENT_PACKET_IDS {
  static const int AUTHENTICATE = 1;
  static const int PING_PONG = 2;
  
  static const int DATA_CHANGE = 5;
  static const int SUPPLIER_ADD = 6;
  static const int CUSTOMER_ADD = 7;
  static const int TRANSPORT_ADD = 7;
  static const int FILE_REQUEST = 8;
}