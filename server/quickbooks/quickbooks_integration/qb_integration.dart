library QuickbooksIntegration;
import 'dart:io';
import 'dart:async';
import 'package:xml/xml.dart';
import 'dart:mirrors';
import 'package:QBXMLRP2_DART/QBXMLRP2_DART.dart';

part 'response_builder.dart';
part 'enums.dart';
part 'list_query.dart';
part 'data_structures/modifiable.dart';
part 'data_structures/customer.dart';
part 'data_structures/account.dart';

void initEnums () {
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

XmlElement getXmlElement (XmlElement xml, String selector, { optional: true }) { 
   XmlCollection el = xml.query(selector);
   if (el.length == 1) {
     return el[0];
   }
   else {
     if (optional) return new XmlElement("noop");
     else throw "Tag does not have a required element.";
   }
}