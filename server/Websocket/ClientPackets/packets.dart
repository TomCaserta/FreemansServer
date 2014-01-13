part of FreemansServer;


class AuthenticateClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.AUTHENTICATE;
  String username;
  String password;
  String rID;
  AuthenticateClientPacket.create (this.rID, this.username, this.password);
  void handlePacket (WebsocketHandler wsh, Client client) {
    if (client.user.isGuest == true) { 
      User temp = User.getUser(this.username, this.password);
       if (temp != null) {
         client.user = temp;
         client.sendPacket(new LoggedInServerPacket(this.rID, temp));
       }
       else {
         client.sendPacket(new ActionResponseServerPacket(this.rID, false, ["Username or password did not match any records"]));
       }
    }
  }
}

class PingPongClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.PING_PONG;
  bool ping;
  String rID;
  PingPongClientPacket.create (this.rID, this.ping);
  
  void handlePacket(WebsocketHandler wsh, Client client) {
     if (ping == true) {
       client.sendPacket(new PingPongServerPacket(this.rID, false));
     }
  }
}

class InitialDataRequest extends ClientPacket {
  static final int ID = CLIENT_PACKET_IDS.INITIAL_DATA_REQUEST;
  String rID;
  InitialDataRequest.create (this.rID);
  
  void handlePacket(WebsocketHandler wsh, Client client) {
    List cL = SyncCachable.getVals(Customer);
    List pL = SyncCachable.getVals(Product);
    List pWL = SyncCachable.getVals(ProductWeight);
    List pPL = SyncCachable.getVals(ProductPackaging);
    List tL = SyncCachable.getVals(Transport);
    List uL = SyncCachable.getVals(User);
    client.sendPacket(new InitialDataResponseServerPacket(rID, cL, pL, pWL, pPL, tL, uL));    
  }
}

class DataChangeClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.DATA_CHANGE;
  String change = "";
  int type = 0;
  String rID = "";
  String identifier = "";
  DataChangeClientPacket.create (this.change, this.type, this.identifier, this.rID);
  void handlePacket (WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("data-change.$type")) {
      wsh.clients.values.where((cli) { return cli != client; }).forEach((e) { 
        e.sendPacket(new DataChangeServerPacket(client.user.ID, change, type, identifier));
      });             
      client.sendPacket(new ActionResponseServerPacket(rID, true));
    }
    else {
      client.sendPacket(new ActionResponseServerPacket(rID, false, ["You do not have permission to change this field."]));      
    }
  }
}

class SupplierAddClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.SUPPLIER_ADD;
  String supplierName = "";
  String rID = "";
  SupplierAddClientPacket.create (this.supplierName, this.rID);
  void handlePacket (WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("list.supplier.add")) {
      
    }
  }
}

class CustomerAddClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.CUSTOMER_ADD;
  String customerName = "";
  String rID = "";
  CustomerAddClientPacket.create (this.customerName, this.rID);
  void handlePacket (WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("list.customer.add")) {
      
    }
  }
}


class TransportAddClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.TRANSPORT_ADD;
  String transportName = "";
  String rID = "";
  TransportAddClientPacket.create (this.transportName, this.rID);   
  void handlePacket (WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("list.transport.add")) {
      
    }
  }
}



class CLIENT_PACKET_IDS {
  static const int AUTHENTICATE = 1;
  static const int PING_PONG = 2;
  static const int INITIAL_DATA_REQUEST = 3;
  
  static const int DATA_CHANGE = 5;
  static const int SUPPLIER_ADD = 6;
  static const int CUSTOMER_ADD = 7;
  static const int TRANSPORT_ADD = 8;
}