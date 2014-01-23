part of QuickbooksIntegration;


class XMLFileCached {
  static Map<String, XMLFileCached> fileCache = new Map<String, XMLFileCached>();
  String fileData = "";
  File f;
  XMLFileCached._new (String name) { 
    f = new File(name);
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
    XMLFileCached file = new XMLFileCached("quickbooks_integration/xml/$fileName.xml");
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
                                   else throw "forEach parameter is not a Map. ${forParam}";
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

                               String value = (containsKey ? "$parameter=\"${_escape(paramDat[1])}\"" : (hasDefault ? "$parameter=${attribDefault}" : ""));
                               fileData = _makeReplacement(fileData, tagStart, x+1, value);
                               x = tagStart + value.length;
                             }
                             else throw "Non optional parameter value was omitted: $parameter";
                             break;
                           case r"$":
                             bool optional = _isParameterOptional(commandDat[1]);
                             String fullVariable = commandDat[1];
                             
                             String parameter = (optional ? fullVariable.substring(0, fullVariable.length-1) : fullVariable); 
                             List paramDat = _containsParameter(params, parameter.split("."));
                             bool containsKey = paramDat[0];
                             if (containsKey || optional) {

                               String value = (containsKey ? _escape(paramDat[1]) : "");
                               fileData = _makeReplacement(fileData, tagStart, x+1, value);
                               x = tagStart + value.length;
                             }
                             else throw "Non optional parameter value was omitted: $parameter";
                             break;
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
  
  static List _containsParameter (val, List<String> params) {
    if (val is Map) { 
      if (val.containsKey(params[0])) {
        if (params.length > 1) return _containsParameter(val[params.removeAt(0)], params); 
        else return [true,val[params[0]]];
      }
      else return [false];
    }
    else return [false];
  }
  
  static String _escape (String val) {
    // TODO implement
    return val;
  }
  static String _makeReplacement(String input, int startX, int endX, String data) {
     return "${input.substring(0, startX)}${data}${input.substring(endX,input.length)}";
  }
  
  static bool _isParameterOptional (String parameter) {
    if (parameter[parameter.length - 1] == "?") return true;
    else return false;
  }
}