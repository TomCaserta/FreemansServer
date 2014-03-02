part of FreemansServer;


class AuthenticateClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.AUTHENTICATE;

  String username;

  String password;

  String rID;

  AuthenticateClientPacket.create (this.rID, this.username, this.password);

  void handlePacket(WebsocketHandler wsh, Client client) {
    if (client.user.isGuest == true) {
      User temp = User.getUser(this.username, this.password);
      if (temp != null) {
        client.user = temp;
        client.sendPacket(new LoggedInServerPacket(this.rID, temp));
      } else {
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
    List aL = Syncable.getVals(Account);
    List cL = Syncable.getVals(Customer);
    List pL = Syncable.getVals(Product);
    List pWL = Syncable.getVals(ProductWeight);
    List pPL = Syncable.getVals(ProductPackaging);
    List pCL = Syncable.getVals(ProductCategory);
    List tL = Syncable.getVals(Transport);
    List uL = Syncable.getVals(User);
    List sL = Syncable.getVals(Supplier);
    client.sendPacket(new InitialDataResponseServerPacket(rID, aL, cL, pL, pWL, pPL, pCL, tL, uL, sL));
  }
}

class DataChangeClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.DATA_CHANGE;

  String change = "";

  int type = 0;

  String rID = "";

  String identifier = "";

  DataChangeClientPacket.create (this.change, this.type, this.identifier, this.rID);

  void handlePacket(WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("data-change.$type")) {
      wsh.clients.values.where((cli) {
        return cli != client;
      }).forEach((e) {
        e.sendPacket(new DataChangeServerPacket(client.user.ID, change, type, identifier));
      });
      client.sendPacket(new ActionResponseServerPacket(rID, true));
    } else {
      client.sendPacket(new ActionResponseServerPacket(rID, false, ["You do not have permission to change this field."]));
    }
  }
}


class SyncableTypes {
  static const int CUSTOMER = 1;

  static const int SUPPLIER = 2;

  static const int PRODUCT_WEIGHT = 3;

  static const int PRODUCT_PACKAGING = 4;

  static const int PRODUCT_CATEGORY = 5;

  static const int PRODUCT = 6;

  static const int TRANSPORT = 7;

  static const int USER = 8;
}

class SyncableModifyClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.SYNCABLE_MODIFY;

  bool add;

  int type;

  Map payload;

  String rID;

  SyncableModifyClientPacket.create (this.rID, this.add, this.type, this.payload);

  void handlePacket(WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("list.modify")) {
      Map schema = {
      };
      switch (type) {
        case SyncableTypes.CUSTOMER:
          schema = CUSTOMER_SCHEMA;
          break;
        case SyncableTypes.SUPPLIER:
          schema = SUPPLIER_SCHEMA;
          break;
        case SyncableTypes.PRODUCT_WEIGHT:
          schema = PRODUCTWEIGHT_SCHEMA;
          break;
        case SyncableTypes.PRODUCT_PACKAGING:
          schema = PRODUCTPACKAGING_SCHEMA;
          break;
        case SyncableTypes.PRODUCT_CATEGORY:
          schema = PRODUCTCATEGORY_SCHEMA;
          break;
        case SyncableTypes.PRODUCT:
          schema = PRODUCT_SCHEMA;
          break;
        case SyncableTypes.USER:
          schema = USER_SCHEMA;
          break;
        case SyncableTypes.TRANSPORT:
          schema = TRANSPORT_SCHEMA;
          break;
        default:
          client.sendPacket(new ActionResponseServerPacket(this.rID, false, ["Unknown type $type"]));
          return;
          break;
      }
      // FUCK IT DONT EVEN BOTHER CACHING THE SCHEMAS. NO POINT. NO TIME.
      Schema.createSchema(schema).then((validator) {
        if (validator.validate(payload)) {
          // Another switch statement... sorry. Only way of doing this quickly
          Syncable s;
          if (add) {
            switch (type) {
              case SyncableTypes.CUSTOMER:
                s = new Customer.fromJson(payload);
                break;
              case SyncableTypes.SUPPLIER:
                s = new Supplier.fromJson(payload);
                break;
              case SyncableTypes.PRODUCT_WEIGHT:
                s = new ProductWeight.fromJson(payload);
                break;
              case SyncableTypes.PRODUCT_PACKAGING:
                s = new ProductPackaging.fromJson(payload);
                break;
              case SyncableTypes.PRODUCT_CATEGORY:
                s = new ProductCategory.fromJson(payload);
                break;
              case SyncableTypes.PRODUCT:
                s = new Product.fromJson(payload);
                break;
              case SyncableTypes.USER:
                s = new User.fromJson(payload);
                break;
              case SyncableTypes.TRANSPORT:
                s = new Transport.fromJson(payload);
                break;
            }
          } else {
            s = Syncable.getByUuid(payload["Uuid"], type);
            if (s != null) {
              s.mergeJson(payload);
            } else {
              client.sendPacket(new ActionResponseServerPacket(this.rID, false, ["Your client sent an invalid packet"]));
            }
          }

          s.updateDatabase(dbHandler, qbHandler).then((didComplete) {
            bool comp = false;
            if (didComplete is List) {
              comp = didComplete.every((e) => e == true);
            } else comp = didComplete;
            if (comp) {
              client.sendPacket(new ActionResponseServerPacket(this.rID, true, [s]));
            } else client.sendPacket(new ActionResponseServerPacket(this.rID, false, ["Unspecified error"]));
          }).catchError((e) => client.sendPacket(new ActionResponseServerPacket(this.rID, false, ["Unspecified error"])));
        } else {
          client.sendPacket(new ActionResponseServerPacket(this.rID, false, ["The request could not validate. For security reasons it has been denied. Please try again later."]));
        }
      });
    }
  }
}


class CLIENT_PACKET_IDS {
  static const int AUTHENTICATE = 1;

  static const int PING_PONG = 2;

  static const int INITIAL_DATA_REQUEST = 3;

  static const int SYNCABLE_MODIFY = 4;

  static const int DATA_CHANGE = 5;
}