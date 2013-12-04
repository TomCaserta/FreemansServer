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
import 'Class/permissions.dart';

part 'Class/user.dart';
part 'Class/supplier.dart';
part 'Config/config.dart';

part 'Websocket/websocket_handler.dart';
part 'Websocket/client.dart';

// Packets
part 'Websocket/ClientPackets/packets.dart';
part 'Websocket/ClientPackets/client_packet.dart';

part 'Websocket/ServerPackets/server_packet.dart';

ConnectionPool dbHandler = new ConnectionPool(host: GLOBAL_SETTINGS["db_host"], port: GLOBAL_SETTINGS["db_port"], user: GLOBAL_SETTINGS["db_user"], password: GLOBAL_SETTINGS["db_password"], db: GLOBAL_SETTINGS["db_database"], max: 5);


Future getNumRows (sql, parameters) { 
  Completer c = new Completer();
  dbHandler.prepareExecute(sql, parameters).then((row) { 
    row.listen((res) {
      print("row!");
      c.complete(res[0]);
    }, onDone: () { 
      print("done");
      if (!c.isCompleted) c.complete(0);
    });
  });
  return c.future;
}

void main() {

  //WebsocketHandler wsh = new WebsocketHandler ();
  //wsh.start();
  print("Done");
  Completer c = new Completer();
  c.future.then((d) {
    print("Keeping this alive");
  });
}



