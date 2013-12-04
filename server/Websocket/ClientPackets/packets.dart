part of FreemansServer;


class AuthenticateClientPacket extends ClientPacket {
  static final int ID = CLIENT_PACKET_IDS.AUTHENTICATE;
  String username;
  String password;
  String respID;
  AuthenticateClientPacket.create(this.respID, this.username, this.password);
  void handlePacket (WebsocketHandler wsh, Client client) {
    if (client.user.isGuest == true) { 
      User temp = User.getUser(this.username, this.password);
       if (temp != null) {
         client.user = temp;
         client.sendPacket(new LoggedInServerPacket(temp, this.respID));
       }
       else {
         client.sendPacket(new UserPassIncorrectServerPacket(this.respID));
       }
    }
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
    if (!client.user.isGuest) {
      
    }
  }
}

class SupplierAddClientPacket extends ClientPacket {
  String supplierName = "";
  String rID = "";
  SupplierAddClientPacket (this.supplierName, this.rID);
  void handlePacket (WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("list.supplier.add")) {
      
    }
  }
}

class CustomerAddClientPacket extends ClientPacket {
  String customerName = "";
  String rID = "";
  CustomerAddClientPacket (this.customerName, this.rID);
  void handlePacket (WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("list.customer.add")) {
      dbHandler.prepareExecute("SELECT count(*) FROM customers WHERE customerName=? LIMIT 1,1", [customerName]).then((row) { 
        row.listen((res) {
          print(res[0]);          
        });
      });
    }
  }
}

class TransportAddClientPacket extends ClientPacket {
  String transportName = "";
  String rID = "";
  TransportAddClientPacket (this.transportName, this.rID);   
  void handlePacket (WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("list.transport.add")) {
      
    }
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