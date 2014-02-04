library FreemansServer;

import 'dart:io';
import 'package:sqljocky/sqljocky.dart';
import 'dart:async';
import 'package:path/path.dart';
import 'package:logging/logging.dart';
import 'package:xml/xml.dart';
import 'package:utf/utf.dart';
import 'dart:convert';
import 'dart:mirrors';
import 'package:uuid/uuid.dart';
import 'utils/permissions.dart';
import 'utils/preloader.dart';
// TODO: Change this back to package once https://code.google.com/p/dart/issues/detail?id=16205
// is fixed.
import 'package:QBXMLRP2_DART/QBXMLRP2_DART.dart';
import 'quickbooks/quickbooks_integration/qb_integration.dart';


part 'quickbooks/quickbooks_initializer.dart';
part 'syncables/user.dart';
part 'syncables/supplier.dart';
part 'syncables/customer.dart';
part 'syncables/transport.dart';
part 'syncables/product.dart';
part 'utils/sync_cachable.dart';
part 'syncables/workbook_data.dart';
part 'config/config.dart';
part 'utils/functions.dart';
part 'utils/database_handler.dart';
part 'websocket/websocket_handler.dart';
part 'websocket/client.dart';
part 'websocket/client_packets/packets.dart';
part 'websocket/client_packets/client_packet.dart';
part 'websocket/server_packets/server_packet.dart';



DatabaseHandler dbHandler;
QuickbooksConnector qbHandler;
Logger ffpServerLog = new Logger("FFPServer");
void main() {
  
  qbHandler = new QuickbooksConnector();
  String appID = "FFPSoftware";
  String appName = "Freemans Farm Produce Software";

  qbHandler.openConnection(GLOBAL_CONFIG["qb_app_ID"], GLOBAL_CONFIG["qb_app_name"]).then((bool connected) {
    if (connected) {
      ffpServerLog.info("Connected to quickbooks...");
      String companyFileName = ""; // Empty string specifies current open file.
      qbHandler.beginSession(companyFileName, QBFileMode.doNotCare).then((String ticketID) {
          ffpServerLog.info("Began session with company file...");
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
          prel.addFuture(new PreloadElement("QuickbooksInit", QuickbooksInitializer.init));
          prel.addFuture(new PreloadElement("UserInit", User.init));
          prel.addFuture(new PreloadElement("SupplierInit", Supplier.init));
          prel.addFuture(new PreloadElement("CustomerInit", Customer.init));
          prel.addFuture(new PreloadElement("TransportInit", Transport.init));
          prel.addMethod(new PreloadElement("PacketInit", ClientPacket.init));
          prel.startLoad(onError: (e) {
            ffpServerLog.severe("$e");
          }).listen((int x) {
            print("[${str_repeat("|",x)}${str_repeat("=",(100-x))}]");
          }, onDone: () {
            print("Finished loading!");
            afterLoading();
          });
      });
    }
    else {
      ffpServerLog.severe("Could not initialize quickbooks... Is it open?");
    }
  })
  .catchError((err) { 
    ffpServerLog.severe("Could not start up program as quickbooks failed to initialize due to the following error: $err");
  });
}

void afterLoading () {
  WebsocketHandler wsh = new WebsocketHandler ();
  wsh.start(GLOBAL_CONFIG["ws_bind_ip"], GLOBAL_CONFIG["ws_bind_port"]);
}



