library DataObjects;

import "dart:async";
import "package:intl/intl.dart";
import "../utilities/permissions.dart";
import "../utilities/date_functions.dart";
import "../websocket/websocket_handler.dart";

part "customer.dart";
part "product.dart";
part "supplier.dart";
part "transport.dart";
part "user.dart";
part "terms.dart";
part "location.dart";
part "transport_haulage_costs.dart";
part "purchase_row.dart";
part "sales_row.dart";

abstract class Syncable {
  static Map<int,Map<int, Syncable>> _cached = new Map<int, Map<int, Syncable>>();
  final int type = 0;
  int ID = 0;
  String Uuid = "";
  bool isActive = true;
  String name;
  dynamic key;

  Syncable();
  Syncable.fromJson (Map jsonMap) {
    this.mergeJson(jsonMap);
  }

  static Syncable get (int type, int ID) => (_cached.containsKey(type) ? (_cached[type].containsKey(ID) ? _cached[type][ID] : null) : null);
  static bool exists (int type, int ID) => get(type,ID) != null;

  void mergeJson (Map jsonMap) {
    if (!_cached.containsKey(this.type)) {
      _cached[this.type] = new Map<int, Syncable>();
    }
    this.ID = jsonMap["ID"];
    _cached[type][ID] = this;

    this.Uuid = jsonMap["Uuid"];

    this.isActive = jsonMap["isActive"];
    this.key = jsonMap["key"];
  }
  
  Future<ActionResponseServerPacket> update(WebsocketHandler wsh) {
    return wsh.sendGetResponse(new SyncableModifyClientPacket(false, this.type, this.toJson()));
  }
  
  Future<ActionResponseServerPacket> insert(WebsocketHandler wsh) {
    return wsh.sendGetResponse(new SyncableModifyClientPacket(true, this.type, this.toJson()));
  }
    
  Map toJson () {
    return { "type": type, "Uuid": Uuid, "ID": ID, "isActive": isActive, "key": key };
  }
}