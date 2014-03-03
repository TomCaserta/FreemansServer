part of QuickbooksIntegration;


class QBExpression {
 static Map<String, Function> OPERATORS = {
      '+': (a,b) => a + b,
      '-':(a,b) => a - b,
      '*':(a,b) => a * b,
      '/':(a,b) => a / b,
      '%':(a,b) => a % b,
      '^':(a,b) => a ^ b,
      '==':(a,b) => a == b,
      '!=':(a,b) => a != b,
      '<':(a,b) => a < b,
      '>':(a,b) => a > b,
      '<=':(a,b) => a <= b,
      '>=':(a,b) => a >= b,
      '&&':(a,b) => a && b,
      '||':(a,b) => a || b,
      '&':(a,b) => a & b,
      '|':(a,b) => a | b,
      '!':(a,b) => !a
 };
 
 static isValidIdentifierStart (int charCode) {
   return (charCode >= 65 && charCode <= 90) || (charCode >= 97 && charCode <= 122);
 }
 static isValidIdentifierBody (int charCode) {
   return isValidIdentifierStart(charCode) || charCode == 46 || charCode == 137 || (charCode >= 48 && charCode <= 57);
 }
 static List<String> OPERATOR_STARTS = ["+","-","*","/","%","^","=","!",">","<","&","|"];
 static isValidOperatorStart (String character) { 
   return OPERATOR_STARTS.contains(character);
 }
 static List<String> OPERATOR_BODY = ["=","&","|"];
 static isValidOperatorBody (String character) { 
   return OPERATOR_BODY.contains(character);
 }
 
 static isValidOperator (String character) {
   return OPERATORS.containsKey(character);
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
 
  
 dynamic exec ([dynamic identifierValues = const {}, bool doThrow = true]) {
   if (parsedExpression.length == 0) parse(identifierValues, doThrow);
   dynamic currentOutputValue = null;
   for (int x = 0; x < parsedExpression.length; x++) {
     bool isLast = x == parsedExpression.length - 1;
     var e = parsedExpression[x];
     if (e is QBIdentifier) {
       currentOutputValue = e.value;
     }     
     else if (e is num) {
       currentOutputValue = e;
     }
     else if (e is QBOperator) {
       // TODO: FOLLOW BODMAS NOT ORDER OF OPERANDS
       // Should be relatively simple to do, loop over the operators implementation above
       currentOutputValue = OPERATORS[e.op](currentOutputValue, (isLast ? 0 : parsedExpression[x+1].value));
       if (!isLast) x+=1;
     }
   }
   return currentOutputValue;
 }
 void parse ([dynamic identifierValues = const {}, bool doThrow = true]) {
   String prev = "";
   String char = "";
   List<String> opBuffer = [];
   List<String> identifierBuffer = [];
   List<String> otherBuffer = [];
   int charCode = 0;
   for (i = 0; i < input.length; i++) {
     char = input[i];
     charCode = char.codeUnitAt(0);
     if (!isWhitespace(char)) {
       
       if (isValidOperatorStart(char)) {
         for (int x = i; x < input.length; x++) {
           opBuffer.add(input[x]);
           if ((eof(x) && isValidOperator(opBuffer.join())) || !isValidOperatorBody(get(x+1))) {
             if (isValidOperator(opBuffer.join())) {
               parsedExpression.add(new QBOperator(opBuffer.join()));
               opBuffer.clear();
               i = x;
             }
             else throw new Exception("Invalid Operator ${opBuffer.join()} (Full expression: $input Peek ahead: ${get(x+1)})");
             break;
           }
         }
         if (opBuffer.length > 0) throw "Invalid operator: ${opBuffer.join()}";
         continue;
       }
       if (isValidIdentifierStart(charCode)) {
         for (int x = i; x < input.length; x++) {
           identifierBuffer.add(get(x)); 
           if (!isValidIdentifierBody(get(x+1).codeUnitAt(0)) || eof(x)) {
              String identifier = identifierBuffer.join();
              identifierBuffer.clear();
              parsedExpression.add(new QBIdentifier(identifier, identifierValues, doThrow));
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
  dynamic value;
  QBIdentifier(this.identifier, dynamic m, bool doThrow) {
      switch (identifier) { 
        case "true":
          value = true;
          break;
        case "false": 
          value = 0;
          break;
        case "null":
          value = null;
          break;
        default:
          List param = _containsParameter(m, identifier.split("."));
          if (param[0]) {
            value = param[1];
          }
          else 
            if (doThrow == true) throw new ArgumentError("No such identifier '$identifier'");
          break;
    }
  }
  
  List _containsParameter (val, List<String> params) {
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
  
  String toString() => identifier;
}

class QBOperator {
  String op;
  QBOperator(String this.op);
  String toString() => op;
}