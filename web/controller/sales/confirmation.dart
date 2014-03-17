part of FreemansClient;

@NgComponent(
  selector: "[confirmation-document]",
  publishAs: "confirmation",
  templateUrl: "views/sales/confirmations.html",
  cssUrl: "views/sales/css/confirmation.css"
)
class ConfirmationDocument {

  String get currentTime => new DateTime.now().toString();
  @NgOneWay("customer-name")
  String customerName = "";

  @NgOneWay("date")
  DateTime date;

  @NgOneWay("requires-ammendment")
  bool requiresAmmendment;


  String get fullDate => new DateFormat("dd/MM/yyyy").format(date);
  String get fullDay => new DateFormat("EEEE").format(date).toUpperCase();
 // salesRow in confirmation.salesRow
  @NgOneWay("sales")
  List<SalesRow> salesRows;

  String get getLetterHead => state.getOption("Letter Heading");

  StateService state;

  ConfirmationDocument (StateService this.state) {
    print("New Document Found :)");
  }
}