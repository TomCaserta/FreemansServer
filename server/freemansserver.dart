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
part 'Config/config.dart';

part 'Utilities/date_functions.dart';
part 'Utilities/prepared_cacher.dart';

part 'Websocket/websocket_handler.dart';
part 'Websocket/client.dart';

// Packets
part 'Websocket/ClientPackets/packets.dart';
part 'Websocket/ClientPackets/client_packet.dart';

part 'Websocket/ServerPackets/server_packet.dart';


Future getNumRows (sql, parameters) { 
  Completer c = new Completer();
  dbHandler.prepareExecute(sql, parameters).then((row) { 
    row.listen((res) {
      c.complete(res[0]);
    }, onDone: () { 
      if (!c.isCompleted) c.complete(0);
    });
  });
  return c.future;
}

String str_repeat(String s, int repeat) { 
  StringBuffer sb = new StringBuffer();
  for (int x = 0; x < repeat; x++) {
    sb.write(s);
  }
  return sb.toString();
}

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
  prel.startLoad(onError: (e) { 
    Logger.root.severe("$e");
  }).listen((int x) { 
    stdout.flush();
    print("[${str_repeat("|",x)}${str_repeat("=",(100-x))}]");
  }, onDone: () { 
    print("Finished loading!");
  });
 
  //WebsocketHandler wsh = new WebsocketHandler ();
  //wsh.start();
}



