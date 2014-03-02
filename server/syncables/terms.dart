part of FreemansServer;

class Terms extends Syncable<Terms> {
  @IncludeSchema()

  DateTime timeCreated;

  @IncludeSchema()

  DateTime timeModified;

  String editSequence;

  @IncludeSchema(isOptional: true)

  String name;

  @IncludeSchema(isOptional: true)

  bool isActive;

  @IncludeSchema(isOptional: true)

  String stdDueDays;

  @IncludeSchema(isOptional: true)

  String stdDiscountDays;

  @IncludeSchema(isOptional: true)

  String discountPct;

  Terms(String listID, [bool isNew = false]):super((isNew ? 0 : -1), listID);

  Future<bool> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    if (isNew) {

    } else {

      return null;
    }
    return null;
  }

  static Future<bool> init() {
    ffpServerLog.info("Loading terms list from quickbooks");
    Completer c = new Completer();

    return c.future;
  }

}