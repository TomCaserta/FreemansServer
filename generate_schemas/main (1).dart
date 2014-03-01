import "../server/freemansserver.dart" as ffpServ;
import "dart:mirrors";
import "dart:io";
import "dart:convert";
import "dart:async";
import "../server/schema_annotations/annotations.dart";

const Symbol libSym = const Symbol ("FreemansServer");
const Symbol extSym = const Symbol ("Syncable");
const Symbol annotationSym = const Symbol("IncludeSchema");
String fileLocation = "../server/schema_annotations/generated_schemas.dart";

void main () {
  MirrorSystem ms = currentMirrorSystem();
  LibraryMirror libMirror = ms.findLibrary(libSym);

  Map<Symbol, DeclarationMirror> declarations = libMirror.declarations;

  Map<JsonSchemaBuilder, ClassMirror> classes = new Map();

  declarations.forEach((Symbol decName, DeclarationMirror mirror) {
    if (mirror is ClassMirror) {
      ClassMirror cm = mirror;
      if (cm.superclass != null) {
        if (cm.superclass.simpleName == extSym) {
          print("=====================${MirrorSystem.getName(cm.simpleName)}======================");
          String name = MirrorSystem.getName(cm.simpleName);
          classes[new JsonSchemaBuilder(name)] = cm;
        }
      }
    }
  });

   void fromClassMirror (JsonSchemaBuilder schema, ClassMirror cm) {
     Map<Symbol, DeclarationMirror> classDec = cm.declarations;
     classDec.forEach((Symbol dec, DeclarationMirror decMirr) {
       if (decMirr is VariableMirror) {
         VariableMirror vari = decMirr;
         Iterable<InstanceMirror> inst = vari.metadata.where((InstanceMirror e) => e.type.simpleName == annotationSym);
         if (!vari.isPrivate && inst.length == 1) {
           schema.addProperty(MirrorSystem.getName(vari.simpleName), MirrorSystem.getName(vari.type.simpleName), inst.first.reflectee.isOptional);
         }
       }
       if (decMirr is MethodMirror) {
         MethodMirror mirr = decMirr;
         Iterable<InstanceMirror> inst = mirr.metadata.where((InstanceMirror e) => e.type.simpleName == annotationSym);
         if (!mirr.isPrivate && mirr.isGetter && inst.length == 1) {
           schema.addProperty(MirrorSystem.getName(mirr.simpleName), MirrorSystem.getName(mirr.returnType.simpleName), inst.first.reflectee.isOptional);
         }
       }

     });
     if (cm.superclass != null) {
       fromClassMirror(schema, cm.superclass);
     }
   }
  /* BUILD IT */
  classes.forEach((JsonSchemaBuilder schema, ClassMirror cm)  {
    fromClassMirror(schema, cm);
  });
  File schemaFile = new File(fileLocation);
  StringBuffer schemaOutput = new StringBuffer();
  schemaOutput.writeln("/* AUTO GENERATED FILE */");
  schemaOutput.writeln("library GeneratedSchema;");
  classes.forEach((schema, cm) {
    schemaOutput.writeln("\n// ${MirrorSystem.getName(cm.simpleName)} Schema: ");
   // print(schema.toJson());
    schemaOutput..write("Map ${MirrorSystem.getName(cm.simpleName).toUpperCase()}_SCHEMA = ")..write(JSON.encode(schema))..writeln(";");
  });
  schemaOutput.writeln("\n // END AUTO GENERATED FILE");
  schemaFile.openSync();
  schemaFile.writeAsStringSync(schemaOutput.toString());

}

class JsonSchemaBuilder {
  static Map<String, JsonSchemaBuilder> builders = new Map<String, JsonSchemaBuilder>();

  String schemaName;

  List<JsonTypeDefinition> properties = new List<JsonTypeDefinition>();

  JsonSchemaBuilder (String this.schemaName) {
    builders[schemaName] = this;
  }

  void addProperty (String propName, String typeName, [bool isOptional = false]) {
    properties.add(new JsonTypeDefinition(propName, typeName, isOptional));
  }

  toJson () {
    print("To Json called");
    Map propMap = new Map();
    properties.forEach((e) {
      propMap.addAll(e.toJson());
    });
    return { "type": "object", "name": schemaName, "additionalProperties" : true, "properties": propMap };
  }
}

class JsonTypeDefinition {
  dynamic type;
  String propName;
  bool isOptional = false;
   JsonTypeDefinition (String this.propName, String typeName, [bool this.isOptional = false]) {
      switch (typeName) {
        case "num":
          type = "number";
          break;
        case "int":
          type = "integer";
          break;
        case "String":
          type = "string";
          break;
        case "double":
          type = "number";
          break;
        case "bool":
          type = "boolean";
          break;
        case "DateTime":
          type = "int";
          break;
        case "List":
          type = "array";
          break;
        case "Permissions":
           type = "string";
          break;
        case "dynamic":
          type = "any";
          break;
        default:
          if (JsonSchemaBuilder.builders.containsKey(typeName)) {
            type = JsonSchemaBuilder.builders[typeName];
          }
          else {
            // TRY TO RESOLVE ON OWN... Could be computationaly expensive but its only going to be run once...
//
//            MirrorSystem ms = currentMirrorSystem();
//            Symbol searchSym = new Symbol(typeName);
//            ms.libraries.forEach ((_, LibraryMirror ls) {
//              ls.declarations.forEach ((Symbol sym, DeclarationMirror mirr) {
//                  if (sym == searchSym && mirr is ClassMirror) {
//                    ClassMirror cm = mirr;
//                    JsonSchemaBuilder schema = new JsonSchemaBuilder(typeName);
//                    cm.declarations.forEach((Symbol decName, DeclarationMirror decMirr) {
//                      if (decMirr is VariableMirror) {
//                        VariableMirror vari = decMirr;
//                        if (!vari.isPrivate) {
//                          schema.addProperty(MirrorSystem.getName(vari.simpleName), MirrorSystem.getName(vari.type.simpleName));
//                        }
//                      }
//                      if (decMirr is MethodMirror) {
//                        MethodMirror mirr = decMirr;
//                        if (!mirr.isPrivate && mirr.isGetter) {
//                          schema.addProperty(MirrorSystem.getName(mirr.simpleName), MirrorSystem.getName(mirr.returnType.simpleName));
//                        }
//                      }
//                    });
//                    type = schema;
//                  }
//              });
//            });
//            if (type == null) throw "Could not resolve $typeName";
              type = "any";
          }
          //else throw new Exception("Cant create schema - No such schema name $typeName");
          break;
      }
   }

   toJson () {
     if (type is String) {
       if (!isOptional) {
         return { "$propName": { "type": type } };
       }
       else {
         return { "$propName": { "oneOf": [{"type": type},{"type": "null"}] } };
       }
     }
     else {
       print(type.runtimeType);
       if (!isOptional)  {
       return { "$propName": type.toJson() };
       }
       else {
         return { "$propName": { "oneOf": [ type.toJson(),{"type": "null"}] } };
       }
     }
   }
}
