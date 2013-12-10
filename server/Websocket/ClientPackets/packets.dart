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
  String rID = "";
  String identifier = "";
  DataChangeClientPacket.create (this.change, this.type, this.identifier, this.rID);
  void handlePacket (WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("data-change.$type")) {
      wsh.clients.values.where((cli) { return cli != client; }).forEach((e) { 
        e.sendPacket(new DataChangeServerPacket(client.user.userID, change, type, identifier));
      });             
      client.sendPacket(new ActionResponseServerPacket(true, rID));
    }
    else {
      client.sendPacket(new ActionResponseServerPacket(false, rID));      
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