library FreemansServer;

import 'dart:io';
import 'package:sqljocky/sqljocky.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:logging/logging.dart';
import 'package:utf/utf.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:mirrors';
import 'package:uuid/uuid.dart';
import 'Utilities/permissions.dart';
import 'Utilities/preloader.dart';

part 'Class/user.dart';
part 'Class/supplier.dart';
part 'Class/customer.dart';
part 'Class/transport.dart';
part 'Class/product.dart';
part 'Utilities/syncable.dart';
part 'Class/workbook_data.dart';
part 'Config/config.dart';

part 'Utilities/functions.dart';
part 'Utilities/database_handler.dart';

part 'Websocket/websocket_handler.dart';
part 'Websocket/client.dart';

// Packets
part 'Websocket/ClientPackets/packets.dart';
part 'Websocket/ClientPackets/client_packet.dart';

part 'Websocket/ServerPackets/server_packet.dart';



DatabaseHandler dbHandler;

void main() {

  ConnectionPool handler = new ConnectionPool(host: GLOBAL_SETTINGS["db_host"], port: GLOBAL_SETTINGS["db_port"], user: GLOBAL_SETTINGS["db_user"], password: GLOBAL_SETTINGS["db_password"], db: GLOBAL_SETTINGS["db_database"], max: 5);
  dbHandler = new DatabaseHandler(handler);
  
  Logger.root.onRecord.listen((e) {
    print(e);
    if (e.level == Level.SEVERE) {
      throw e;
    }
  });
  Logger.root.info("Initializing database values");
  Preloader prel = new Preloader();
  prel.addFuture(new PreloadElement("UserInit", User.init));
  prel.addFuture(new PreloadElement("SupplierInit", Supplier.init));
  prel.addFuture(new PreloadElement("CustomerInit", Customer.init));
  prel.addFuture(new PreloadElement("TransportInit", Transport.init));
  prel.startLoad(onError: (e) {
    Logger.root.severe("$e");
  }).listen((int x) {
    print("[${str_repeat("|",x)}${str_repeat("=",(100-x))}]");
  }, onDone: () {
    print("Finished loading!");
    afterLoading();
  });
}

void afterLoading () {
//WebsocketHandler wsh = new WebsocketHandler ();
  //wsh.start();
  if (!Customer.exists("Tom12s")) {
    
    Customer cust = new Customer(0,"Tom12s");
    cust.billto2 = "Test :)";
    cust.updateDatabase(dbHandler).then((comp) {
      cust.billto1 = "Testing 123!";
      print("Inserted!");
      cust.updateDatabase(dbHandler).then((done) { 
        print("Updated customer");
      });
    });
  }
  else {
    print("Customer already inserted");
    Customer cust = Customer.get("Tom12s");
    print(cust.billto1);
    cust.billto3 = "Hmm2";
    cust.updateDatabase(dbHandler).then((done) { 
      print("Updated customer");
    });
  }
}



