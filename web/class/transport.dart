part of FreemansClient;

class Surcharge {
  DateTime dateBefore;
  int surcharge;
  Surcharge (DateTime this.dateBefore, this.surcharge);

  List toJson () { 
          return [dateBefore.millisecondsSinceEpoch, surcharge];
  }
}


class Transport {
  List<Surcharge> surcharges = new List<Surcharge>();
  String name = "";
  String quickbooksName = "";
  String transportSheetEmail = "";
  String remittanceEmail = "";
  
}