library FreemansServer;

import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:mirrors';
import 'package:sqljocky/sqljocky.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:logging/logging.dart';
import 'package:ansicolor/ansicolor.dart';
import 'package:xml/xml.dart';
import 'package:utf/utf.dart';
import 'package:uuid/uuid.dart' as uuid;
import 'package:json_schema/json_schema.dart';
import 'utils/permissions.dart';
import 'utils/preloader.dart';
import 'package:QBXMLRP2_DART/QBXMLRP2_DART.dart';
import 'quickbooks/quickbooks_integration/qb_integration.dart';
import 'utils/functions.dart';
import 'schema_annotations/annotations.dart';
import 'schema_annotations/generated_schemas.dart';

part 'syncables/terms.dart';
part 'syncables/accounts.dart';
part 'syncables/user.dart';
part 'syncables/supplier.dart';
part 'syncables/customer.dart';
part 'syncables/transport.dart';
part 'syncables/product.dart';
part 'syncables/location.dart';
part 'syncables/transport_haulage_costs.dart';
part 'utils/syncable.dart';
part 'syncables/workbook_data.dart';
part 'config/config.dart';
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
  initQbIntegration();
  //ffpServerLog.hierarchicalLoggingEnabled = true
//  hierarchicalLoggingEnabled = true;
//  ffpServerLog.level = Level.ALL;
  ffpServerLog.onRecord.listen((r) {
    print("[${r.level}][${new DateFormat("hh:mm:ss").format(r.time)}][${r.loggerName != "" ? r.loggerName : "ROOT"}]: ${r.message}");
    if (r.level == Level.SEVERE) {
      throw r;
    }
  });

  qbHandler.openConnection(GLOBAL_CONFIG["qb_app_ID"], GLOBAL_CONFIG["qb_app_name"]).then((bool connected) {
    if (connected) {
      ffpServerLog.info("Connected to quickbooks... $connected : ${GLOBAL_CONFIG["qb_app_ID"]} ${GLOBAL_CONFIG["qb_app_name"]}");
      String companyFileName = ""; // Empty string specifies current open file.
      return qbHandler.beginSession(companyFileName, QBFileMode.doNotCare);
    } else {
      ffpServerLog.severe("Could not initialize quickbooks... Is it open?");
    }
  }).then((String ticketID) {
    ffpServerLog.info("Began session with company file...");
    ConnectionPool handler = new ConnectionPool(host: GLOBAL_CONFIG["db_host"], port: GLOBAL_CONFIG["db_port"], user: GLOBAL_CONFIG["db_user"], password: GLOBAL_CONFIG["db_password"], db: GLOBAL_CONFIG["db_database"], max: 5);
    dbHandler = new DatabaseHandler(handler);
    ffpServerLog.info("Initializing database values");
    Preloader prel = new Preloader();
    prel.addFuture(new PreloadElement("UserInit", User.init));
    prel.addFuture(new PreloadElement("SupplierInit", Supplier.init));
    prel.addFuture(new PreloadElement("CustomerInit", Customer.init));
    prel.addFuture(new PreloadElement("TransportInit", Transport.init));
    prel.addFuture(new PreloadElement("QBAccountsInit", Account.init));
    prel.addFuture(new PreloadElement("ProductInit", Product.init));
    prel.addFuture(new PreloadElement("ProductWeightInit", ProductWeight.init));
    prel.addFuture(new PreloadElement("ProductPackagingInit", ProductPackaging.init));
    prel.addFuture(new PreloadElement("ProductCategoryInit", ProductCategory.init));
    prel.addFuture(new PreloadElement("TermsInit", Terms.init));
    prel.addFuture(new PreloadElement("LocationInit", Location.init));
    prel.addFuture(new PreloadElement("TransportHaulageCostInit", TransportHaulageCost.init));
    prel.addMethod(new PreloadElement("PacketInit", ClientPacket.init));
    ffpServerLog.info("Beginning load");

    prel.startLoad(onError: (e) {
      ffpServerLog.severe("$e");
    }).listen((int x) {
      ffpServerLog.fine("[${str_repeat("|", x)}${str_repeat("=", (100 - x))}]");
    }, onDone: () {
      afterLoading();
    });
  }).catchError((err) {
    ffpServerLog.severe("Could not start up program as quickbooks failed to initialize due to the following error: $err\n\n${err.stackTrace}\n\n");
  });
}

void afterLoading() {
  WebsocketHandler wsh = new WebsocketHandler ();
  wsh.start(GLOBAL_CONFIG["ws_bind_ip"], GLOBAL_CONFIG["ws_bind_port"]);
}



