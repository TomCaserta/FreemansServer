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
part 'Utilities/sync_cachable.dart';
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
Logger ffpServerLog = new Logger("FFPServer");
void main() {
  
  ConnectionPool handler = new ConnectionPool(host: GLOBAL_CONFIG["db_host"], port: GLOBAL_CONFIG["db_port"], user: GLOBAL_CONFIG["db_user"], password: GLOBAL_CONFIG["db_password"], db: GLOBAL_CONFIG["db_database"], max: 5);
  dbHandler = new DatabaseHandler(handler);
  
  ffpServerLog.onRecord.listen((e) {
    print(e);
    if (e.level == Level.SEVERE) {
      throw e;
    }
  });
  
  ffpServerLog.info("Initializing database values");
  Preloader prel = new Preloader();
  prel.addFuture(new PreloadElement("UserInit", User.init));
  prel.addFuture(new PreloadElement("SupplierInit", Supplier.init));
  prel.addFuture(new PreloadElement("CustomerInit", Customer.init));
  prel.addFuture(new PreloadElement("TransportInit", Transport.init));
  prel.startLoad(onError: (e) {
    ffpServerLog.severe("$e");
  }).listen((int x) {
    print("[${str_repeat("|",x)}${str_repeat("=",(100-x))}]");
  }, onDone: () {
    print("Finished loading!");
    afterLoading();
  });
}

void afterLoading () {
  WebsocketHandler wsh = new WebsocketHandler ();
  wsh.start(GLOBAL_CONFIG["ws_bind_ip"], GLOBAL_CONFIG["ws_bind_port"]);
}



