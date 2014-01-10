library FreemansClient;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'dart:mirrors';
import 'package:angular/angular.dart';
import 'package:uuid/uuid.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'utilities/date_functions.dart';
import 'utilities/preloader.dart';

part 'websocket/websocket_handler.dart';
part 'websocket/server_packets.dart';
part 'websocket/client_packets.dart';

part 'controller/main/loading.dart';
part 'controller/main/mainnavigation.dart';
part 'controller/main/contentdropdown.dart';
part 'controller/workbook/workbook.dart';
part 'controller/transport/transport.dart';

void main() {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((LogRecord r) { print("[${new DateFormat("hh:mm:ss").format(r.time)}][${r.level}][${r.loggerName != "" ? r.loggerName : "ROOT"}]: ${r.message}"); });
  FreemansModule.preloader.addMethod(new PreloadElement("ServerPacket", ServerPacket.init));
  for (var x = 0; x<10000; x++) {
    FreemansModule.preloader.addMethod(new PreloadElement("$x", () { 
      return true;
    }));
  }
  ngBootstrap(module: new FreemansModule());
}

class FreemansModule extends Module {
  static bool loggedIn = false;
  static WebsocketHandler wsh = new WebsocketHandler("ws://127.0.0.1:1337/websocket");
  static Preloader preloader = new Preloader();
  static bool get loaded {
    return preloader.loaded;  
  }
  static bool get webSocketLoaded {
    return wsh.loaded;
  }
  
  static bool checkLogin () {
    if (loggedIn == false) {
     // window.location.hash = "/login";
      return true;
    }
    else {
      return true;
    }
  }
  
  
  FreemansModule () {
    Logger.root.info("Loading ${this.runtimeType}");
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
    type(RouteInitializer, implementedBy: FreemansRouteInitializer);
    type(MainNavigation);
    type(Workbook);
    type(ContentDropdown);
    type(Loading);
   
  }
}


class FreemansRouteInitializer implements RouteInitializer {
  init(Router router, ViewFactory view) {
    Logger.root.info("Loading ${this.runtimeType}");
    router.root
          ..addRoute(
              name: 'overview',
              path: '/overview',
              enter: view('views/overview.html')
          )
          ..addRoute(
              name: 'workbook',
              path: '/workbook',
              enter: view('views/workbook/index.html')
          )
          ..addRoute(
              name: 'login',
              path: '/login',
              enter: view('views/login/login.html')
          );
  }
}