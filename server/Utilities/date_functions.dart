part of FreemansServer;


String dateToFFPD (DateTime d) {
  StringBuffer sb = new StringBuffer();
  sb.write(d.year);
  sb.write("/");
  sb.write(d.month);
  sb.write("/");
  sb.write(d.day);
  return sb.toString();
}

DateTime FFPDToDate (String d) {
  List<String> splitD = d.split("/");
  if (splitD.length == 3) { 
    int year = int.parse(splitD[0], onError: (e) {});
    int month = int.parse(splitD[1], onError: (e) {});
    int day = int.parse(splitD[2], onError: (e) {});
    DateTime date = new DateTime(year, month, day);
    return date;
  }
}