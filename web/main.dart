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


import "controller/lists/overview.dart";
import "class/main.dart";
import "websocket/websocket_handler.dart";
import "utilities/state_service.dart";

// TODO: Separate these dependencies:
part 'controller/main/loading.dart';
part 'controller/main/mainnavigation.dart';
part 'controller/main/login.dart';
part 'controller/main/contentdropdown.dart';
part 'controller/main/multilistselectbox.dart';
part 'controller/workbook/workbook.dart';
part 'controller/transport/transport.dart';
part 'controller/sales/sales.dart';


void main() {
  Logger.root.level = Level.FINE;
  Logger.root.onRecord.listen((LogRecord r) { print("[${new DateFormat("hh:mm:ss").format(r.time)}][${r.level}][${r.loggerName != "" ? r.loggerName : "ROOT"}]: ${r.message}"); });


  ngBootstrap(module: new FreemansModule());
}

class FreemansModule extends Module {
  
  FreemansModule () {    
    Logger.root.info("Loading ${this.runtimeType}");
    value(RouteInitializerFn, freemansRouteInitializer);
    
    type(StateService);
    type(MainNavigation);
    type(Workbook);
    type(ContentDropdown);
    type(Loading);
    type(Login);
    type(ListButtons);
    type(SalesController);
    type(ListEditor);
    type(MultiListSelectBox);
    factory(NgRoutingUsePushState,
        (_) => new NgRoutingUsePushState.value(false));
   
  }
}


freemansRouteInitializer(Router router, ViewFactory views) {
  return views.configure({
       'overview': ngRoute(
          path: 'overview',
          view: 'views/overview.html'),
       'workbook': ngRoute(
        path: 'workbook',
        view: 'views/workbook/index.html'
       ),
       'sales/classic': ngRoute(
          path: 'sales/classic',
          view: 'views/sales/classic.html'
       ),
       'sales': ngRoute(
          path: 'sales',
          view: 'views/sales/index.html'
       ),
       'lists': ngRoute(
          path: 'lists',
          view: 'views/lists/index.html'
       ),
       'login': ngRoute (
           defaultRoute: true,
          path: "login",
          view: "views/login/login.html"
       )
  });
}