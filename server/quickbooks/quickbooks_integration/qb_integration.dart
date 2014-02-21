library QuickbooksIntegration;
import 'dart:io';
import 'dart:async';
import 'package:xml/xml.dart';
import 'dart:mirrors';
import 'package:QBXMLRP2_DART/QBXMLRP2_DART.dart';

part 'expression_parser.dart';
part 'response_builder.dart';
part 'list_query.dart';
part 'customer_add.dart';
part 'types/percent.dart';
part 'types/enum.dart';
part 'data_structures/modifiable.dart';
part 'data_structures/reference.dart';
part 'data_structures/address.dart';
part 'data_structures/customer.dart';
part 'data_structures/account.dart';
part 'data_structures/terms.dart';

String QB_VERSION;
void initEnums ([String version = "11.0"]) {
  QB_VERSION = version;
  MirrorSystem ms = currentMirrorSystem();
  TypeMirror tm = reflectType(EnumString);
  Symbol thisSymbol = tm.simpleName;
  ms.libraries.forEach((Uri libUri, LibraryMirror libM) { 
    libM.declarations.forEach((Symbol declarationN, DeclarationMirror dm) { 
      if (dm is ClassMirror) { 
        ClassMirror superClass = dm.superclass;
         if (superClass != null)  {
           if (superClass.simpleName == thisSymbol) {
             dm.declarations.forEach((Symbol fmName, DeclarationMirror decMirror) {
               if (decMirror.runtimeType.toString() == "_LocalVariableMirror") {
                 // Force our field to initialize
                 dm.getField(fmName).reflectee;
               }
             });  
           }
         }
      }
    });
  });
}

//http://phpjs.org/functions/htmlspecialchars_decode/
// Ported to dart
String htmlspecialchars_decode (String input, [ dynamic quoteStyle = 2 ]) {
  // From: http://phpjs.org/functions

  int optTemp = 0;
  int  i = 0;
  bool noquotes = false;
  input = input.replaceAll(new RegExp("&lt;"), '<').replaceAll(new RegExp("&gt;"), '>');
  Map<String, int> OPTS = const {
    'ENT_NOQUOTES': 0,
    'ENT_HTML_QUOTE_SINGLE': 1,
    'ENT_HTML_QUOTE_DOUBLE': 2,
    'ENT_COMPAT': 2,
    'ENT_QUOTES': 3,
    'ENT_IGNORE': 4
  };
  if (quoteStyle == 0) {
    noquotes = true;
  }
  if (quoteStyle is List<String>) { // Allow for a single string or an array of string flags
    for (i = 0; i < quoteStyle.length; i++) {
      // Resolve string input to bitwise e.g. 'PATHINFO_EXTENSION' becomes 4
      if (OPTS[quoteStyle[i]] == 0) {
        noquotes = true;
      } else if (OPTS[quoteStyle[i]] != null) {
        optTemp = optTemp | OPTS[quoteStyle[i]];
      }
    }
    quoteStyle = optTemp;
  }
  if (quoteStyle & OPTS["ENT_HTML_QUOTE_SINGLE"] == 1) {
    input = input.replaceAll(new RegExp("&#0*39;"), "'"); 
   // input = input.replaceAll(new RegExp("&apos;|&#x0*27;"), "'"); // This would also be useful here, but not a part of PHP
  }
  if (!noquotes) {
    input = input.replaceAll(new RegExp("&quot;"), '"');
  }
  // Put this in last place to avoid escape being double-decoded
  input = input.replaceAll(new RegExp("&amp;"), '&');

  return input;
}


class QBXmlContainer {
  XmlElement nodeValue;
  bool exists = true;
  
  String get text {
    if (exists) {
      return htmlspecialchars_decode(nodeValue.text);
    }
    return null;
  }
  
  /// Gets a percent type (Initial value * 10)
  QBPercent get percent {
    if (exists && nodeValue.text != "") { 
      return new QBPercent(double.parse(nodeValue.text, (e) => 0.0) * 10);
    }
    else return null;
  }
  
  int get integer {
    if (exists && nodeValue.text != "") {
      return int.parse(nodeValue.text, onError: (e) { return 0; });
    }
    else return null;
  }
  bool get boolean {
    if (exists) {
      if (nodeValue.text.toUpperCase() == "TRUE") return true;
      else if (nodeValue.text.toUpperCase() == "FALSE") return false;
      else throw new Exception("Unknown value given for Quickbooks boolean conversion: ${nodeValue.text}");
    }
    return null;
  }
  num get number {
    if (exists && nodeValue.text != "") {
      return num.parse(nodeValue.text, (e) { return 0; });
    }
    else return null;
  }
  DateTime get date {
    if (exists && nodeValue.text != "") {
      return DateTime.parse(nodeValue.text);
    }
    return null;
  }
  
  QBXmlContainer ([this.nodeValue]) {
    if (this.nodeValue == null) exists = false;
  }
  
  XmlCollection query (String selector) {
    if (exists) {
      return nodeValue.query(selector);
    }
    return null;
  }
}
QBXmlContainer getQbxmlContainer (dynamic xml, String selector, { optional: false }) { 
   XmlCollection el = xml.query(selector);
   
   if ( el != null && el.length == 1) {
     return new QBXmlContainer(el[0]);
   } 
   if (optional) return new QBXmlContainer();
   else throw new Exception("Tag does not have a required element: $selector");
}