library FreemansClient;

import 'dart:html';
import 'dart:async';
import 'dart:convert';
import 'dart:js';
import 'dart:mirrors';
import 'package:angular/angular.dart';
import 'package:uuid/uuid.dart';
import 'package:logging/logging.dart';
import 'package:intl/intl.dart';
import 'utilities/date_functions.dart';
import 'utilities/preloader.dart';
import 'utilities/permissions.dart';

part 'class/user.dart';
part 'class/transport.dart';
part 'class/product.dart';
part 'class/customer.dart';
part 'class/supplier.dart';

part 'websocket/websocket_handler.dart';
part 'websocket/server_packets.dart';
part 'websocket/client_packets.dart';

part 'controller/main/loading.dart';
part 'controller/main/mainnavigation.dart';
part 'controller/main/login.dart';
part 'controller/main/contentdropdown.dart';
part 'controller/main/multilistselectbox.dart';
part 'controller/workbook/workbook.dart';
part 'controller/transport/transport.dart';

/*
 * LIST EDITOR
 */
part 'controller/lists/overview.dart';


void main() {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((LogRecord r) { print("[${new DateFormat("hh:mm:ss").format(r.time)}][${r.level}][${r.loggerName != "" ? r.loggerName : "ROOT"}]: ${r.message}"); });


  ngBootstrap(module: new FreemansModule());
}

class StateService {
  bool loggedIn = false;
  WebsocketHandler wsh = new WebsocketHandler("ws://192.168.1.87:1337/websocket");
  Preloader preloader = new Preloader();
  User currUser;
  
  bool get loaded {
    return preloader.loaded;  
  }
  
  bool get webSocketLoaded {
    return wsh.loaded;
  }
  
  bool checkLogin () {
    if (loggedIn == false) {
      window.location.hash = "/login";
      return true;
    }
    else {
      return true;
    }
  }
  
  StateService () { 
    preloader.addMethod(new PreloadElement("ServerPacket", ServerPacket.init));
  }

}

class FreemansModule extends Module {
  
  FreemansModule () {    
    Logger.root.info("Loading ${this.runtimeType}");
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
    type(RouteInitializer, implementedBy: FreemansRouteInitializer);
    type(StateService);
    type(MainNavigation);
    type(Workbook);
    type(ContentDropdown);
    type(Loading);
    type(Login);
    type(ListEditor);
    type(MultiListSelectBox);
   
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
                        name: 'lists',
                        path: '/lists',
                        enter: view('views/lists/index.html')
                    )
          ..addRoute(
              name: 'login',
              path: '/login',
              enter: view('views/login/login.html')
          );
  }
}