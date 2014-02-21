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
                 else {
                   if (inTag) {
                     tagLength++;
                     currentTagData.write(curChar);
                   }
                   escapeTag = false;
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
                                  print(currentTagData.toString());
                                }
                                ifNum++;
                                inIf = true;                             
                                break;
                              case "ENDIF":
                                if (inIf) { 
                                  ifNum--;
                                  if (ifNum == 0) {
                                     dynamic data = new QBExpression(ifParam).exec(params);
                                     if (!(data is bool)) {
                                       data = _getBoolValue (data);
                                     }
                                    if (data is bool) {
                                     if (data) {
                                       String internal = fileData.substring(startIf, tagStart);
                                       fileData = _makeReplacement(fileData, ifStartBefore, x+1, internal);
                                     }
                                     else {
                                       fileData = _makeReplacement(fileData, ifStartBefore, x+1, "");                                                                      
                                     }
                                     x = ifStartBefore;
                                    }
                                    else throw new ArgumentError("'${data.runtimeType}' is not a valid subtype of 'bool' for if parameter: $ifParam");
                                    
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
                                     dynamic data = new QBExpression(forParam).exec(params);
                                     if (data is List) {
                                       String loopInternals = fileData.substring(startFor, tagStart);
                                       StringBuffer loopedData = new StringBuffer();
                                       data.forEach((Map data) { 
                                         loopedData.write(parse(loopInternals, params: data));
                                       });
                                       fileData = _makeReplacement(fileData, forStartBefore, x+1, loopedData.toString());
                                       x = forStartBefore; // We want to reparse the template as the top level.
                                     }
                                     else throw new ArgumentError("'${data.runtimeType}' is not a valid subtype of 'List' on for each parameter $data");
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
                                   String fullVariable = "";
                                   bool hasDefault = false;
                                   String attribDefault = "";
                                   bool optional = false;
                                   if (commandDat.length == 2) {
                                     fullVariable = commandDat[1];
                                   }
                                   else {
                                     fullVariable = commandDat[2]; 
                                     hasDefault = commandDat[1] != "?";
                                     optional = !hasDefault;
                                     attribDefault = (!hasDefault ? "" : commandDat[1]);
                                   }
                                   
                                   dynamic paramDat = new QBExpression(fullVariable).exec(params, false);
                                   if (paramDat == null && hasDefault) paramDat = attribDefault;
                                   
                                   if (paramDat != null || hasDefault || optional) {
                                     String value = (paramDat != null ? "$fullVariable=\"${_convertToString(paramDat, false)}\"" : (hasDefault ? "$fullVariable=${attribDefault}" : ""));
                                     fileData = _makeReplacement(fileData, tagStart, x+1, value);
                                     x = tagStart + value.length;
                                   }
                                   else throw new ArgumentError("Parameter value does not exist or is null however no default value is supplied.");
                                 }
                                 break;
                               case r"$":
                                 if (!inIf && !inForEach) {
                                   String parameter;
                                   dynamic paramVal;
                                   if (commandDat.length == 2) { 
                                      parameter = commandDat[1]; 
                                      paramVal = new QBExpression(parameter).exec(params);
                                   }
                                   else {
                                        parameter = commandDat[2]; 
                                        paramVal = new QBExpression(parameter).exec(params, false);
                                        if (paramVal == null) {
                                          paramVal = (commandDat[1] == "?" ? "" : commandDat[1]);
                                        }
                                   }
                                   if (paramVal != null) {
                                     String value = paramVal != null ? _convertToString(paramVal) : "";
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
  
}

