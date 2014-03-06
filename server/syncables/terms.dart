part of FreemansServer;

class Terms extends Syncable<Terms> {
  @IncludeSchema()
  DateTime timeCreated;

  @IncludeSchema()
  DateTime timeModified;

  String editSequence;

  @IncludeSchema()
  String name;

  @IncludeSchema()
  int stdDueDays;

  @IncludeSchema(isOptional: true)
  int stdDiscountDays;

  @IncludeSchema(isOptional: true)
  num discountPct;

  Terms(String listID, [bool isNew = false]):super((isNew ? 0 : -1), listID);
  

  Terms.fromJson (Map params):super.fromJson(params);
  
  void mergeJson (Map jsonMap) {
    this.timeCreated = new DateTime.fromMillisecondsSinceEpoch(jsonMap["timeCreated"], isUtc: true);
    this.timeModified = new DateTime.fromMillisecondsSinceEpoch(jsonMap["timeModified"], isUtc: true);
    this.name = jsonMap["name"];
    this.stdDueDays = jsonMap["stdDueDays"];
    this.stdDiscountDays = jsonMap["stdDiscountDays"];
    this.discountPct = jsonMap["discountPct"];
    super.mergeJson(jsonMap);
  }
  
  Future<bool> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    if (isNew) {
      QBStandardTerms term = new QBStandardTerms();
      term.timeCreated = this.timeCreated;
      term.timeModified = this.timeModified; // Why does this even have a time modified if it cant be modified... seriously.
      term.editSequence = this.editSequence;
      term.name = this.name;
      term.stdDueDays = this.stdDueDays;
      term.stdDiscountDays = this.stdDiscountDays;
      term.discountPct = new QBPercent(this.discountPct);
    } else {
      // Yeah really... It is literally the *ONLY* method without an update 
      ffpServerLog.warning("Did not update term $name as there is no valid implementation available in the quickbooks SDK");  
    }
    return c.future;
  }

  static Future<bool> init() {
    ffpServerLog.info("Loading terms list from quickbooks");
    Completer c = new Completer();
    new QBStandardTermsList(qbHandler).forEach().listen((QBStandardTerms term) { 
      Terms t = new Terms(term.listID);      
      t.timeCreated = term.timeCreated;
      t.timeModified = term.timeModified;
      t.editSequence = term.editSequence;
      t.name = term.name;
      t.isActive = term.isActive;
      t.stdDueDays = term.stdDueDays;
      t.stdDiscountDays = term.stdDiscountDays;
      if (t.discountPct != null) {
        t.discountPct = term.discountPct.value;
      }
    }, onDone: () {
      c.complete(true);
    });
    return c.future;
  }
  
  Map toJson () {
    return super.toJson()..addAll({  "timeCreated": timeCreated.millisecondsSinceEpoch,  "timeModified": timeModified.millisecondsSinceEpoch,  "name": name,  "stdDueDays": stdDueDays,  "stdDiscountDays": stdDiscountDays,  "discountPct": discountPct });
  }
  
}