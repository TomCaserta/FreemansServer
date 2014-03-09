part of FreemansServer;


class WorkbookDay extends Syncable<WorkbookDay> {
  static int _auto_inc = 0;

  List<WorkbookRow> workbook_data = new List<WorkbookRow>();

  WorkbookDay._loadTimePeriod (DateTime timeFrom, DateTime timeTo):super(_auto_inc, "${timeFrom.millisecondsSinceEpoch};${timeTo.millisecondsSinceEpoch}") {
    _auto_inc++;

  }

  static exists(DateTime timeFrom, DateTime timeTo) => Syncable.exists(WorkbookDay, ("${timeFrom.millisecondsSinceEpoch};${timeTo.millisecondsSinceEpoch}"));

  static get(DateTime timeFrom, DateTime timeTo) => Syncable.get(WorkbookDay, "${timeFrom.millisecondsSinceEpoch};${timeTo.millisecondsSinceEpoch}");

  factory WorkbookDay (DateTime timeFrom, DateTime timeTo) {
    if (exists(timeFrom, timeTo)) {
      return get(timeFrom, timeTo);
    } else {
      return new WorkbookDay._loadTimePeriod(timeFrom, timeTo);
    }
  }

  Future<bool> updateDatabase(DatabaseHandler dbh, QuickbooksConnector qbc) {
    Completer c = new Completer();
    List<Future<bool>> futures = new List<Future<bool>>();
    // Fake completer/future to ensure that we always have atleast one future waiting on.
    // Whilst its a bit hacky its easier than doing a check.
    Completer fakeCompleter = new Completer();
    futures.add(fakeCompleter.future);
    workbook_data.forEach((WorkbookRow wr) {
      futures.add(wr.updateDatabase(dbh, qbc));
    });
    Future.wait(futures).then((List<bool> returns) {
      if (returns.every((e) => e)) {
        c.complete(true);
      } else {
        ffpServerLog.severe("Could not update database.");
      }
    }).catchError((e) => c.completeError(e));
    fakeCompleter.complete(true);
    return c.future;
  }

}