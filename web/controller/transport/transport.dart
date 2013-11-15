part of FreemansClient;

@NgComponent(
    selector: 'transport',
    templateUrl: '/views/transport/transport.html',
    cssUrl: '/views/transport/transport.css',
    publishAs: 'ctrl'
)
class TransportSheets {
  Map<String, TransportDay> selectedDay = new Map<String, TransportDay>();
  DateTime currentDate = new DateTime.now();
  
}

/// Transport day holds a list of collections and stock for a specific date.
class TransportDay {
  List<TransportItem> collections = new List<TransportItem>();
  List<TransportItem> stock = new List<TransportItem>();
}

/// Holds data for the deliveries.
class TransportItem {
  String supplier = "";
  num pallets = 0.00;
  num quantity = 0;
  String item = "";
  String customer = "";
  String destination = "";  
}