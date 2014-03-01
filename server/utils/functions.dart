library functions;


String dateToFFPD (DateTime d) {
  d = d.toUtc();
  StringBuffer sb = new StringBuffer();
  sb.write(d.year);
  sb.write("/");
  sb.write(add_padding(d.month,"0",2));
  sb.write("/");
  sb.write(add_padding(d.day,"0",2));
  return sb.toString();
}

String add_padding (dynamic val, String paddChar, int amt) {
  String value = val.toString();
  StringBuffer sb = new StringBuffer();
  sb.write(str_repeat(paddChar, (amt - value.length)));
  sb.write(value);
  return sb.toString();
}


String str_repeat(String s, int repeat) {
  StringBuffer sb = new StringBuffer();
  for (int x = 0; x < repeat; x++) {
    sb.write(s);
  }
  return sb.toString();
}


DateTime FFPDToDate (String d) {
  List<String> splitD = d.split("/");
  if (splitD.length == 3) {
    int year = int.parse(splitD[0], onError: (e) {});
    int month = int.parse(splitD[1], onError: (e) {});
    int day = int.parse(splitD[2], onError: (e) {});
    DateTime date = new DateTime.utc(year, month, day);
    return date;
  }
}