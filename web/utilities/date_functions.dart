library DateFunctions;

import 'package:intl/intl.dart';


String getOrd (int num){
    if(num % 1 >= 1) return "$num";
    int s= num%100;
    if(s > 3 && s < 21) return '${num}th';
    switch(s%10){
        case 1: return '${num}st';
        case 2: return '${num}nd';
        case 3: return '${num}rd';
        default: return '${num}th';
    }
}

String longDateFormat (DateTime date) {
return  new DateFormat("EEEE, ### of MMMM y").format(date).replaceAll("###", getOrd(date.day));
}


String dateToFFPD (DateTime d) {
  return new DateFormat("yyyy-MM-dd").format(d);
}


DateTime FFPDToDate (String d) {
  if (d != null && d.isNotEmpty) {
    return new DateFormat("yyyy-MM-dd").parse(d);
  }
  return null;
}