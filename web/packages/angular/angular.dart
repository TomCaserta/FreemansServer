/**
 * Angular is a framework for building single page web applications.
 *
 * Further reading:
 *
 *   - AngularJS [Overview](http://www.angularjs.org)
 *   - [Tutorial](https://github.com/angular/angular.dart.tutorial/wiki)
 *   - [Mailing List](http://groups.google.com/d/forum/angular-dart?hl=en)
 *
 */
library angular;

import 'dart:html' as dom;
import 'package:di/di.dart';
import 'package:di/dynamic_injector.dart';

import 'core/module.dart';
import 'core_dom/module.dart';
import 'directive/module.dart';
import 'filter/module.dart';
import 'perf/module.dart';
import 'routing/module.dart';

export 'package:di/di.dart';
export 'core/module.dart';
export 'core_dom/module.dart';
export 'core/parser/parser_library.dart';
export 'directive/module.dart';
export 'filter/module.dart';
export 'routing/module.dart';

part 'bootstrap.dart';
