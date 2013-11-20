library FreemansServer;

import 'dart:io';
import 'package:sqljocky/sqljocky.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:utf/utf.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'dart:mirrors';
import 'package:uuid/uuid.dart';

part 'Class/user.dart';
part 'Config/config.dart';

part 'Websocket/websocket_handler.dart';
part 'Websocket/client.dart';

// Packets
part 'Websocket/ClientPackets/authentication_packet.dart';
part 'Websocket/ClientPackets/client_packet.dart';

part 'Websocket/ServerPackets/server_packet.dart';
part 'Websocket/ServerPackets/timeout_packet.dart';

ConnectionPool dbHandler = new ConnectionPool(host: GLOBAL_SETTINGS["db_host"], port: GLOBAL_SETTINGS["db_port"], user: GLOBAL_SETTINGS["db_user"], password: GLOBAL_SETTINGS["db_password"], db: GLOBAL_SETTINGS["db_database"], max: 5);
void main() {
  print("Test");
  WebsocketHandler wsh = new WebsocketHandler ();
  wsh.start();
  print("Done");
}


