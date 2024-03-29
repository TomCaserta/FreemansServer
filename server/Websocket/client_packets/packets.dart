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
        client.loggedIn = true;
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
    if (!client.user.isGuest) {
      List aL = Syncable.getVals(Account);
      List cL = Syncable.getVals(Customer);
      List pL = Syncable.getVals(Product);
      List pWL = Syncable.getVals(ProductWeight);
      List pPL = Syncable.getVals(ProductPackaging);
      List pD = Syncable.getVals(ProductDescriptor);
      List pCL = Syncable.getVals(ProductCategory);
      List tL = Syncable.getVals(Transport);
      List uL = Syncable.getVals(User);
      List sL = Syncable.getVals(Supplier);
      List terL = Syncable.getVals(Terms);
      List locL = Syncable.getVals(Location);
      List thcL = Syncable.getVals(TransportHaulageCost);
      List optL = Syncable.getVals(Options);
      client.sendPacket(new InitialDataResponseServerPacket(rID, aL, cL, pL, pWL, pPL, pD, pCL, tL, uL, sL, terL, locL, thcL, optL));
    }
  }
}

class DataChangeClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.DATA_CHANGE;

  String change = "";

  int type = 0;

  String rID = "";

  String identifier = "";

  bool isAdd = false;

  DataChangeClientPacket.create (this.change, this.type, this.identifier, this.rID, this.isAdd);

  void handlePacket(WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("data-change.$type")) {

      wsh.clients.values.where((cli) {
        return cli != client;
      }).forEach((e) {
        e.sendPacket(new DataChangeServerPacket(client.user.ID, change, type, identifier, isAdd));
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
  static const int TERMS = 9;
  static const int LOCATION = 10;
  static const int TRANSPORT_HAULAGE_COST = 11;
  static const int PURCHASE_ROW = 12;
  static const int SALE_ROW = 13;
  static const int PRODUCT_DESCRIPTOR = 14;
  static const int OPTION = 15;
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
        case SyncableTypes.TERMS:
          schema = TERMS_SCHEMA;
          break;
        case SyncableTypes.LOCATION:
          schema = LOCATION_SCHEMA;
          break;
        case SyncableTypes.TRANSPORT_HAULAGE_COST:
          schema = TRANSPORTHAULAGECOST_SCHEMA;
          break;
        case SyncableTypes.PURCHASE_ROW:
          schema = PURCHASEROW_SCHEMA;
          break;
        case SyncableTypes.SALE_ROW:
          schema = SALESROW_SCHEMA;
          break;
        case SyncableTypes.PRODUCT_DESCRIPTOR:
          schema = PRODUCTDESCRIPTOR_SCHEMA;
          break;
        case SyncableTypes.OPTION:
          schema = OPTIONS_SCHEMA;
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
              case SyncableTypes.TERMS:
                s = new Terms.fromJson(payload);
                break;
              case SyncableTypes.LOCATION:
                s = new Location.fromJson(payload);
                break;
              case SyncableTypes.TRANSPORT_HAULAGE_COST:
                s = new TransportHaulageCost.fromJson(payload);
                break;
              case SyncableTypes.PURCHASE_ROW:
                s = new PurchaseRow.fromJson(payload);
                break;
              case SyncableTypes.SALE_ROW:
                s = new SalesRow.fromJson(payload);
                break;
              case SyncableTypes.PRODUCT_DESCRIPTOR:
                s = new ProductDescriptor.fromJson(payload);
                break;
              case SyncableTypes.OPTION:
                s = new Options.fromJson(payload);
                break;
            }
          } else {
            s = Syncable.getByUuid(payload["Uuid"], type);
            if (s != null) {
              s.mergeJson(payload);
            } else {
              client.sendPacket(new ActionResponseServerPacket(this.rID, false, ["Server -> Interface mismatch. The object you are editing is not currently in the servers memory. Notify Tom..."]));
            }
          }
          if (s != null){
            s.updateDatabase(dbHandler, qbHandler).then((didComplete) {
              bool comp = false;
              if (didComplete is List) {
                comp = didComplete.every((e) => e == true);
              } else comp = didComplete;
              if (comp) {
                client.sendPacket(new ActionResponseServerPacket(this.rID, true, [s]));
              } else client.sendPacket(new ActionResponseServerPacket(this.rID, false, ["Unspecified error"]));
            }).catchError((e) {
              ffpServerLog.warning("Error: $e");
              client.sendPacket(new ActionResponseServerPacket(this.rID, false, ["There was a server error whilst processing your request. The request may not have gone through. Please notify Tom."]));
            });
          }
          else client.sendPacket(new  ActionResponseServerPacket(this.rID, false, ["Error whilst updating/adding the supplied object. Please notify Tom ASAP. Changes *have not* been updated."]));
        } else {
          client.sendPacket(new ActionResponseServerPacket(this.rID, false, ["Sorry one of the required fields was not entered correctly. Please try again. (If you see this notify Tom to add a more descriptive error message)"]));
        }

      });
    }
  }
}

class FetchPurchaseRowDataClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.PURCHASE_ROW_DATA;
  int start;
  int max;
  num amount;
  String amountOperator = "=";
  num cost;
  String costOperator = "=";
  int supplierID;
  int productID;
  int weightID;
  int packagingID;
  int descriptorID;
  int collectingHaulierID;
  int purchaseTimeFrom;
  int purchaseTimeTo;
  bool getSales = false;
  String rID;
  String orderBy = "";
  int identifier;
  bool active;
  FetchPurchaseRowDataClientPacket.create ({this.rID,
                                           this.identifier,
                                           this.start,
                                           this.max,
                                           this.amount,
                                           this.amountOperator,
                                           this.cost,
                                           this.costOperator,
                                           this.supplierID,
                                           this.productID,
                                           this.weightID,
                                           this.packagingID,
                                           this.descriptorID,
                                           this.collectingHaulierID,
                                           this.purchaseTimeFrom,
                                           this.purchaseTimeTo,
                                           this.getSales,
                                           this.orderBy,
                                           this.active});

  void handlePacket(WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("purchaserow.select")) {
      if (!isValidOperator(this.amountOperator)) this.amountOperator = "=";
      if (!isValidOperator(this.costOperator)) this.costOperator = "=";
      StringBuffer buffer = new StringBuffer();
      List params = [];
      buffer.write(" WHERE active=? ");
      params.add((active == null || active == true ? 1 : 0));
      if (identifier != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("ID = ?");
        params.add(identifier);
      }
      if (amount != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("amount $amountOperator ?");
        params.add(amount);
      }
      if (cost != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("cost $costOperator ?");
        params.add(cost);
      }
      if (supplierID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("supplierID=?");
        params.add(supplierID);
      }
      if (productID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("productID=?");
        params.add(productID);
      }
      if (weightID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("weightID=?");
        params.add(weightID);
      }
      if (descriptorID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("descriptorID=?");
        params.add(descriptorID);
      }
      if (packagingID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("packagingID=?");
        params.add(packagingID);
      }
      if (collectingHaulierID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("haulageID=?");
        params.add(collectingHaulierID);
      }
      if (purchaseTimeFrom != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("timeofpurchase > ?");
        params.add(purchaseTimeFrom);
      }

      if (purchaseTimeTo != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("timeofpurchase < ?");
        params.add(purchaseTimeTo);
      }
      if (orderBy != null) {
        // TODO: SQL Sanitation
        buffer.write(" ORDER BY $orderBy");
      }
      if (start != null && max != null && start is int && max is int) {
         buffer.write(" LIMIT $start,$max");
      }

      String fullSql = "${PurchaseRow.selector}${buffer.toString()}";
      if (getSales == null) getSales = false;
      ffpServerLog.info("Fetching $fullSql from the database!");
      dbHandler.prepareExecute(fullSql, params).then((Results res) {
        List<PurchaseRow> purchaseRows = [];
        List<Future> salesRowFetchers = [];
        res.listen((Row r) {
          ffpServerLog.info("Found row $r");
          PurchaseRow pr = new PurchaseRow.fromRow(r);
          purchaseRows.add(pr);
          if (this.getSales) salesRowFetchers.add(pr.fetchSalesRows(dbHandler));
        }, onDone: () {
          if (this.getSales == false) {
            client.sendPacket(new ActionResponseServerPacket(this.rID,true,purchaseRows));
          }
          else {
            Future.wait(salesRowFetchers).then((List responses) {
              client.sendPacket(new ActionResponseServerPacket(this.rID,true,purchaseRows));
            }).catchError((e) {
              client.sendPacket(new ActionResponseServerPacket(this.rID,false,[e]));
            });
          }
        });
      });
    }
  }
}

bool isValidOperator (String operator) {
  List ops = const ["=",">",">=","<","<=","LIKE","NOT LIKE","!="];
  return ops.contains(operator);
}

class SendSessionClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.SEND_SESSION;
  String sessionID;
  SendSessionClientPacket.create (this.sessionID);

  void handlePacket(WebsocketHandler wsh, Client client) {
    ffpServerLog.info("Received session packet ${sessionID}");
    if (sessionID != null && sessionID.isNotEmpty) {
      Client cli = wsh.getClientFromSocket(sessionID); 
      ffpServerLog.info("Session data received...");
      if (cli != null) {
        ffpServerLog.info("Sent new session information");
        wsh.removeClient(cli);
        client.mergeWith(cli);
        client.cancelDestroy();
        if (client.loggedIn) {
          client.sendPacket(new LoggedInServerPacket("", client.user));
        }
        else {
          ffpServerLog.warning("Client was not logged in! ${cli.loggedIn}");
        }
        client.sendPacket(new SetSessionServerPacket(client._uniqueID));
      }
      else {
        ffpServerLog.info("Session not found $sessionID resending data ${client._uniqueID}");
        client.sendPacket(new SetSessionServerPacket(client._uniqueID));
      }
    }
    else {
      ffpServerLog.info("Sent new session data ${client._uniqueID}");
      client.sendPacket(new SetSessionServerPacket(client._uniqueID));
    }
  }  
}

class FetchSalesRowDataClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.SALES_ROW_DATA;
  int start;
  int max;
  num amount;
  String amountOperator = "=";
  num salePrice;
  String salePriceOperator = "=";
  String rID;
  String orderBy = "";
  int identifier;
  int descriptorID;
  int customerID;
  int produceID;
  int productID;
  int weightID;
  int packagingID;
  int deliveryDateFrom;
  int deliveryDateTo;
  int deliveryCost;
  String deliveryCostOperator = "=";
  int transportID;
  bool active = true;

  FetchSalesRowDataClientPacket.create ({this.rID,
                                           this.start,
                                           this.max,
                                           this.amount,
                                           this.amountOperator,
                                           this.salePrice,
                                           this.salePriceOperator,
                                           this.identifier,
                                           this.descriptorID,
                                           this.customerID,
                                           this.produceID,
                                           this.productID,
                                           this.weightID,
                                           this.packagingID,
                                           this.deliveryDateFrom,
                                           this.deliveryDateTo,
                                           this.deliveryCost,
                                           this.deliveryCostOperator,
                                           this.transportID,
                                           this.orderBy,
                                           this.active
                                           });

  void handlePacket(WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("purchaserow.select")) {
      if (!isValidOperator(this.amountOperator)) this.amountOperator = "=";
      if (!isValidOperator(this.salePriceOperator)) this.salePriceOperator = "=";
      if (!isValidOperator(deliveryCostOperator)) this.deliveryCostOperator = "=";
      StringBuffer buffer = new StringBuffer();
      List params = [];
      buffer.write(" WHERE active=? ");
      params.add((active == null || active == true ? 1 : 0));
      if (identifier != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("ID = ?");
        params.add(identifier);
      }
      if (amount != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("amount $amountOperator ?");
        params.add(amount);
      }
      if (salePrice != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("cost $salePriceOperator ?");
        params.add(salePrice);
      }
      if (customerID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("customerID = ?");
        params.add(customerID);
      }
      if (produceID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("produceID = ?");
        params.add(produceID);
      }
      if (transportID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("haulageID = ?");
        params.add(transportID);
      }
      if (productID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("produceID = ?");
        params.add(produceID);
      }
      if (weightID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("weightID = ?");
        params.add(weightID);
      }
      if (packagingID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("packagingID = ?");
        params.add(packagingID);
      }
      if (descriptorID != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("descriptorID = ?");
        params.add(descriptorID);
      }
      if (deliveryDateFrom != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("deliveryDate > ?");
        params.add(deliveryDateFrom);
      }

      if (deliveryDateTo != null) {
        if (buffer.length > 0) buffer.write(" AND ");
        else buffer.write(" WHERE ");
        buffer.write("deliveryDate < ?");
        params.add(deliveryDateTo);
      }


      if (orderBy != null) {
        // TODO: SQL Sanitation
        buffer.write(" ORDER BY $orderBy");
      }
      if (start != null && max != null && start is int && max is int) {
        buffer.write(" LIMIT $start,$max");
      }

      String fullSql = "${SalesRow.selector}${buffer.toString()}";
      ffpServerLog.info("Fetching $fullSql from the database! ${params}");
      dbHandler.prepareExecute(fullSql, params).then((Results res) {
        List<SalesRow> salesRows = [];
        res.listen((Row r) {
          ffpServerLog.info("Found row $r");
          SalesRow sr = new SalesRow.fromRow(r);
          salesRows.add(sr);
        }, onDone: () {
            client.sendPacket(new ActionResponseServerPacket(this.rID,true,salesRows));
        });
      });
    }
  }
}

class GeneratePDFClientPacket extends ClientPacket {
  static int ID = CLIENT_PACKET_IDS.GENERATE_PDF;
  String html;
  String directory;
  String outputfile;
  GeneratePDFClientPacket.create (String this.html, String this.directory, String this.outputfile) {
    
   
  }
  void handlePacket(WebsocketHandler wsh, Client client) {
    if (!client.user.isGuest && client.user.hasPermission("generatepdf")) {
         Directory dir = new Directory("").absolute;
         Directory asked = new Directory(this.directory).absolute;
         
    }
  }
}


class CLIENT_PACKET_IDS {
  static const int AUTHENTICATE = 1;
  static const int PING_PONG = 2;
  static const int INITIAL_DATA_REQUEST = 3;
  static const int SYNCABLE_MODIFY = 4;
  static const int DATA_CHANGE = 5;
  static const int SEND_SESSION = 6;
  static const int PURCHASE_ROW_DATA = 7;
  static const int SALES_ROW_DATA = 8;
  static const int GENERATE_PDF = 9;
}