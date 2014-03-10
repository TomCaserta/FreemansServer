library functions;

import "package:intl/intl.dart";

String str_repeat(String s, int repeat) {
  StringBuffer sb = new StringBuffer();
  for (int x = 0; x < repeat; x++) {
    sb.write(s);
  }
  return sb.toString();
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