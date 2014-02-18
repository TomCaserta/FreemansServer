part of QuickbooksIntegration;


class XMLFileCached {
  static Map<String, XMLFileCached> fileCache = new Map<String, XMLFileCached>();
  String fileData = "";
  File f;
  XMLFileCached._new (String name) { 
    f = new File(name);
    fileCache[name] = this;
    if (f.existsSync()) {
      f.openSync(mode: FileMode.READ);
      fileData = f.readAsStringSync();
    }
    else throw "File $name does not exist.";
  }  
  factory XMLFileCached (String fileName) { 
    if (fileCache.containsKey(fileName)) {
      return fileCache[fileName];
    }
    else return new XMLFileCached._new(fileName);
  }
}

class ResponseBuilder {
  
  static String parseFromFile (String fileName, { Map params: const  {} }) {
    XMLFileCached file = new XMLFileCached("quickbooks/quickbooks_integration/xml/$fileName.xml");
    return parse(file.fileData, params: params);
  }
  static String parse (String fileData, { Map params: const {}}) {
    // TODO: Fix this up so it isnt as shit.
       RegExp curleyBrackets = new RegExp(r"(?!@){{(.+?)}}");
       bool isExtended = false;
       String extendedTemplate = "";
       
       int fileLength = fileData.length;
       
       // Tag Data
       StringBuffer currentTagData = new StringBuffer();
       bool escapeTag = false;
       bool inTag = false;
       bool tagIsComment = false;
       int tagStart = 0;
       int tagLength = 0;
       
       // For loop
       bool inForEach = false;
       String forParam = "";
       int forNum = 0;
       int startFor = 0;
       int forStartBefore = 0;
       
       // If data
       bool inIf = false;
       int startIf = 0;
       int ifNum = 0;
       String ifParam = "";
       int ifStartBefore = 0;
       
       
       // Sections
       Map<String, String> sections = new Map<String, String>();
       // Section Tag
       bool inSection = false;
       int sectionStart = 0;
       String sectionName = "";
       for (int x = 0; x < fileData.length; x++) {
         String curChar = fileData[x];
             switch (curChar) {
               case "@": 
                 escapeTag = true;
                 break;
               case "{":
                 if (!escapeTag) {
                   inTag = true;
                   tagStart = x;
                 }
                 break;
               case "!": 
                 if (inTag && tagLength == 0) {
                   tagIsComment = true;
                 }
                 break;
               case "}":
                 if (inTag && !escapeTag) {

                   if (tagIsComment) {
                     fileData = _makeReplacement(fileData, tagStart, x, "");
                     x = tagStart;
                     tagIsComment = false;
                   }
                   else {
                     String tagD = currentTagData.toString();
                     List<String> commandDat = tagD.split("::");
                     if (commandDat.length >= 1) {
                       switch (commandDat[0].toUpperCase()) {
                         case "EXTENDS":
                             // Extension should replace the tag with the extension data. 
                             String extendData = parseFromFile(commandDat[1], params: params).replaceAll("\n","");
                             fileData = _makeReplacement(fileData, tagStart, x+1, extendData);
                             x = tagStart + extendData.length;
                             
                           break;
                         case "SECTION":
                           if (!inSection) {
                            inSection = true;
                            sectionName = commandDat[1];
                            sectionStart = x+1;
                           }
                           else throw "Cannot define sections inside of other sections";
                           break;
                         case "ENDSECTION": 
                           if (inSection) {
                             sections[sectionName] = fileData.substring(sectionStart, tagStart);    
                             fileData = _makeReplacement(fileData, sectionStart-sectionName.length-11, x+1, "");
                             x = sectionStart;
                                               
                             inSection = false;
                             sectionStart = 0;
                           }
                           else throw "Cannot end a section that never started!";
                           break;
                       }
                       if (!inSection) {
                         switch (commandDat[0].toUpperCase()) {
                             case "IF":
                                if (!inIf) {
                                 ifStartBefore = tagStart;
                                 startIf = x+1;
                                 ifParam = commandDat[1];
                                }
                                ifNum++;
                                inIf = true;                             
                                break;
                              case "ENDIF":
                                if (inIf) { 
                                  ifNum--;
                                  if (ifNum == 0) {
                                    List paramDat = _containsParameter(params, ifParam.split("."));
                                    bool containsKey = paramDat[0];
                                    if (containsKey) {
                                     bool val = _getBoolValue(paramDat[1]);
                                     if (val) {
                                       String internal = fileData.substring(startIf, tagStart);
                                       fileData = _makeReplacement(fileData, ifStartBefore, x+1, internal);
                                      
                                     }
                                     else {
                                       
                                       fileData = _makeReplacement(fileData, ifStartBefore, x+1, "");                                                                      
                                     }
                                     x = ifStartBefore;
                                    }
                                    else throw "IF parameter value is not defined ${ifParam}.";
                                    
                                    ifParam = "";
                                    startIf = 0;
                                    inIf = false;
                                  }
                                }
                                break;
                           }
                           if (!inIf) {
                             switch (commandDat[0].toUpperCase()) {
                               case "FOREACH":
                                 if (!inForEach) {
                                   forStartBefore = tagStart;
                                   startFor = x + 1;
                                   forParam = commandDat[1];
                                 }
                                 forNum++;
                                 inForEach = true;
                                 break;
                               case "ENDFOREACH":
                                 if (inForEach) {
                                   
                                   forNum--;
                                   if (forNum == 0) {
                                     if (params.containsKey(forParam)) {
                                       if (params[forParam] is List) {
                                         String loopInternals = fileData.substring(startFor, tagStart);
                                         StringBuffer loopedData = new StringBuffer();
                                         params[forParam].forEach((Map data) { 
                                           loopedData.write(parse(loopInternals, params: data));
                                         });
                                         fileData = _makeReplacement(fileData, forStartBefore, x+1, loopedData.toString());
                                         x = forStartBefore; // We want to reparse the template as the top level.
                                       }
                                       else throw "forEach parameter is not a List. ${forParam}";
                                     }
                                     else throw "Cannot use foreach on a null variable ${forParam}";
                                     // Reset
                                     forParam = "";
                                     startFor = 0;
                                     inForEach = false;
                                   }  
                                 }
                                 else throw "No foreach to end.";
                                 break;
                               
                               case "ATRIB":
                                 if (!inIf && !inForEach) {
                                   bool optional = _isParameterOptional(commandDat[1]);
                                   List attributeValue = commandDat[1].split("=");
                                   
                                   String fullVariable = attributeValue[0];
                                   String attribDefault = "";
                                   bool hasDefault = false;
                                   if (attributeValue.length >= 2) {
                                     hasDefault = true;
                                     attribDefault = attributeValue.getRange(1, attributeValue.length).join("=");
                                   }
                                   
                                   String parameter = (optional ? fullVariable.substring(0, fullVariable.length-1) : fullVariable); 
                                   List paramDat = _containsParameter(params, parameter.split("."));
                                   bool containsKey = paramDat[0];
                                   if (containsKey || optional || hasDefault) {
      
                                     String value = (containsKey ? "$parameter=\"${_convertToString(paramDat[1], false)}\"" : (hasDefault ? "$parameter=${attribDefault}" : ""));
                                     fileData = _makeReplacement(fileData, tagStart, x+1, value);
                                     x = tagStart + value.length;
                                   }
                                   else throw "Non optional parameter value was omitted: $parameter";
                                 }
                                 break;
                               case r"$":
                                 if (!inIf && !inForEach) {
                                   bool optional = _isParameterOptional(commandDat[1]);
                                   String fullVariable = commandDat[1];
                                   
                                   String parameter = (optional ? fullVariable.substring(0, fullVariable.length-1) : fullVariable); 
                                   List paramDat = _containsParameter(params, parameter.split("."));
                                   bool containsKey = paramDat[0];
                                   if (containsKey || optional) {
      
                                     String value = (containsKey ? _convertToString(paramDat[1]) : "");
                                     fileData = _makeReplacement(fileData, tagStart, x+1, value);
                                     x = tagStart + value.length;
                                   }
                                   else throw "Non optional parameter value was omitted: $parameter";
                                 }
                                 break;
                             }
                             
                           }
                       }
                       inTag = false;
                       tagLength = 0;
                     }
                   }
                   currentTagData = new StringBuffer();
                 }
                 break;
               default: 
                 if (inTag) {
                   tagLength++;
                   currentTagData.write(curChar);
                 }
                 escapeTag = false;
                 break;
             }
     }
      
     sections.forEach((String secName, String data) {
       //print(data);
       fileData = fileData.replaceAll(new RegExp("{yeild::${secName}}"), parse(data, params: params));       
     });
     return fileData;  
  }
  /// Checks if the value has some sort of boolean value. Returns true if so. 
  /// Strings return true if they are not empty
  /// booleans return true if they are true
  /// Anything else returns true providing it is not null
  static bool _getBoolValue (dynamic value) {
    if (value is bool) {
      return value;
    }
    if (value is String) {
      return value.isNotEmpty;
    }
    if (value is num && value != 0) {
      return true;
    }
    if (value is QBRef) {
     return value.toJson() != null;
    }
    if (value != null) { 
      return true;
    }
    return false;
  }
  static String _convertToString(dynamic val, [bool encode = true]) {
    if (val is int) {
      return val.toString();
    }
    else if (val is num) {
      return val.toStringAsFixed(2);
    }
    else  return (encode ? _escape(val.toString()) : val.toString());
  }
  
    
  static List _containsParameter (val, List<String> params) {
    if (!(val is Map)) {
      try {
      val = val.toJson();
      }
      catch (e) {
        return [false];
      }
    }
    
    if (val is Map) { 
      if (val.containsKey(params[0])) {
        if (params.length > 1) return _containsParameter(val[params.removeAt(0)], params); 
        else return [true,val[params[0]]];
      }
      else return [false];
    }
    else return [false];
  }
  
  static String _escape (String str) {
    int i = str.length;
    List<String> buffer = new List<String>(str.length);
    while (i-- != 0) {
      var iC = str[i].codeUnitAt(0);
      if (!(iC >= 48 && iC <= 57) && !(iC >= 65 && iC <= 90) && !(iC >= 97 && iC <= 122) && iC != 46 && iC != 32 && iC != 64) {
        buffer[i] = '&#$iC;';
      } else {
        buffer[i] = str[i];
      }
     }
    return buffer.join(""); 
  }
  static String _makeReplacement(String input, int startX, int endX, String data) {
     return "${input.substring(0, startX)}${data}${input.substring(endX,input.length)}";
  }
  
  static bool _isParameterOptional (String parameter) {
    if (parameter[parameter.length - 1] == "?") return true;
    else return false;
  }
}


class QBExpression {
 static Map<String, Function> OPERATORS = {
      'null': ()  => null,
      'true': ()  => true,
      'false': () => false,
      '+': (self, locals, a,b){
       
        },
      '-':(self, locals, a,b){
           
          },
      '*':(self, locals, a,b){return a(self, locals)*b(self, locals);},
      '/':(self, locals, a,b){return a(self, locals)/b(self, locals);},
      '%':(self, locals, a,b){return a(self, locals)%b(self, locals);},
      '^':(self, locals, a,b){return a(self, locals)^b(self, locals);},
      '=': () { },
      '==':(self, locals, a,b){return a(self, locals)==b(self, locals);},
      '!=':(self, locals, a,b){return a(self, locals)!=b(self, locals);},
      '<':(self, locals, a,b){return a(self, locals)<b(self, locals);},
      '>':(self, locals, a,b){return a(self, locals)>b(self, locals);},
      '<=':(self, locals, a,b){return a(self, locals)<=b(self, locals);},
      '>=':(self, locals, a,b){return a(self, locals)>=b(self, locals);},
      '&&':(self, locals, a,b){return a(self, locals)&&b(self, locals);},
      '||':(self, locals, a,b){return a(self, locals)||b(self, locals);},
      '&':(self, locals, a,b){return a(self, locals)&b(self, locals);},
      '|':(self, locals, a,b){return b(self, locals)(self, locals, a(self, locals));},
      '!':(self, locals, a){return !a(self, locals);}
 };
 
 static isValidIdentifierStart (int charCode) {
   return (charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122);
 }
 static isValidIdentifierBody (int charCode) {
   return isValidIdentifierStart(charCode) || charCode == 46 || charCode == 137 || (charCode >= 48 && charCode <= 57);
 }
 static List<String> OPERATOR_STARTS = ["n","t","f","+","-","*","/","%","^","=","!",">","<","&","|"];
 static isValidOperatorStart (String character) { 
   return OPERATOR_STARTS.contains(character);
 }
 static List<String> OPERATOR_BODY = ["u","l","r","e","a","s","=","&","|"];
 static isValidOperatorBody (String character) { 
   return OPERATOR_BODY.contains(character);
 }
 
 static isValidOperator (String character) {
   return OPERATORS.containsKey("character");
 }

 static bool isWhitespace (String inp) {
   return inp == " " || inp.codeUnitAt(0) == 0;
 }
 
 
 String input = "";

 int i = 0;
  
 String peekAhead () {
   return (i+1 < input.length ? input[i+1] : new String.fromCharCode(0));
 }
 String get (int chNum) { 
   return (chNum < input.length ? input[chNum] : new String.fromCharCode(0));
 }
 bool eof (int num) {
   return num+1 == input.length;
 }

 List parsedExpression = new List();
 String parse () {
   String prev = "";
   String char = "";
   List<String> opBuffer = [];
   List<String> identifierBuffer = [];
   List<String> otherBuffer = [];
   int charCode = 0;
   for (i = 0; i < input.length; i++) {
     char = input[i];
     charCode = char.codeUnitAt(0);
     print("$char => ${charCode}");
     if (!isWhitespace(char)) {
       
       if (isValidOperatorStart(char)) {

           opBuffer.add(char);
         for (int x = i; x < input.length; x++) {
           
           if ((eof(x) && isValidOperator(opBuffer.join())) || !isValidOperatorBody(get(x))) {
             print("Added valid operator");
             parsedExpression.add(new QBOperator(opBuffer.join()));
             opBuffer.clear();
             i = x;
             break;
           }
           else {
             opBuffer.add(input[x]);
           }
         }
         if (opBuffer.length > 0) throw "Invalid operator: ${opBuffer.join()}";
         continue;
       }
       if (isValidIdentifierStart(charCode)) {
         print("Could be a identifier");
         for (int x = i; x < input.length; x++) {
           print("= ${get(x+1)} => ${get(x+1).codeUnitAt(0)}");
           identifierBuffer.add(get(x)); 
           if (!isValidIdentifierBody(get(x+1).codeUnitAt(0)) || eof(x)) {
              String identifier = identifierBuffer.join();
              identifierBuffer.clear();
              parsedExpression.add(new QBIdentifier(identifier));
              i = x;
              break;
           }
         }
         continue;
       }
       otherBuffer.add(char); 
       if (!isWhitespace(peekAhead()) && isValidIdentifierStart(peekAhead().codeUnitAt(0))) {
         throw "Unexpexted Identifier start at: ${otherBuffer.join()}${peekAhead()}";
       }
       else {
         bool isValOpStart = isValidOperatorStart(peekAhead());
         if (isValOpStart || isWhitespace(peekAhead())) {
           num t = num.parse(otherBuffer.join(), (e) { throw "$e is not an operator, identifier or numeric"; });
           print("Added valid numeric");
           parsedExpression.add(t); 
           otherBuffer.clear();
         }
       }
       
     }
     prev = char;
   }
 }
 
 QBExpression (String this.input) {
   
 } 
 toString () => parsedExpression.toString();
 
}
class QBIdentifier { 
  String identifier;
  QBIdentifier(this.identifier);
  String toString() => identifier;
}

class QBOperator {
  String op;
  QBOperator(String this.op);
  String toString() => op;
}