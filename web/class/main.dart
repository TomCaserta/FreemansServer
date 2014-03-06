library DataObjects;

import "dart:async";
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

abstract class Syncable {
  final int type = 0;
  int ID = 0;
  String Uuid = "";
  bool isActive = false;
  String name;
  dynamic key;
  Syncable();
  Syncable.fromJson (Map jsonMap) {
    this.mergeJson(jsonMap);
  }
  
  void mergeJson (Map jsonMap) {
    this.ID = jsonMap["ID"];
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