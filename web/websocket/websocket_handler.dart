library WebsocketHandler;

import "dart:async";
import "package:logging/logging.dart";
import "package:uuid/uuid.dart";
import "dart:html";
import "dart:convert";
import "dart:mirrors";
import "../utilities/state_service.dart";

part "client_packets.dart";
part "server_packets.dart";

class WebsocketHandler {
  StateService ss;
  static Logger websocketLogger = new Logger("WebsocketHandler");
  Map<String, Completer> rrcpCompleters = new Map<String, Completer>();
  WebSocket _socket;
  String socketAddress;
  bool get loaded {
    return _socket.readyState == 1;
  }
  void connect () {

    _socket = new WebSocket(socketAddress);
    _socket.onClose.listen(this.onDisconnect);
    _socket.onOpen.listen(this.onConnect);
    _socket.onMessage.listen(this.onData);
    _socket.onError.listen(this.onError);
  }
  WebsocketHandler(String this.socketAddress) {
  }
  
  void onError (Event event) {
    websocketLogger.severe("Websocket has encountered an error. ${_socket.readyState}");
  }
  
  void onConnect(Event event) {
    websocketLogger.info("Connection established sending any session data:");
    if (window.localStorage == null) { 
      print(window.localStorage);
    }
    this.send(new SendSessionClientPacket((window.localStorage.containsKey("FFPSESSID") ? window.localStorage["FFPSESSID"] : "" )));
  }
  
  void onDisconnect(CloseEvent event) {
    websocketLogger.info("Connection closed");
  }
  
  void onData (MessageEvent event) {
     try {
       dynamic response = JSON.decode(event.data);
       if (response is Map) {
        if (response.containsKey("ID") && response["ID"] is int) {
         ServerPacket sp = ServerPacket.getPacket(response["ID"], response);
         
         if (sp != null) {
           if (response.containsKey("rID") && response["rID"] is String && response["rID"].isNotEmpty) {
             if (rrcpCompleters.containsKey(response["rID"])) {
               rrcpCompleters[response["rID"]].complete(sp);
               rrcpCompleters.remove(response["rID"]);
             }
             else sp.handlePacket(this);
           }
           else sp.handlePacket(this);
         }
         else {
           websocketLogger.severe("Received malformed packet: $response");
         }
        }
       }
     }
     catch (E) {
       websocketLogger.warning("${E.toString()}");
       websocketLogger.severe("Received malformed packet - could not parse as JSON: ${event.data}");
     }
  }
  
  void send (ClientPacket packet) {
    if (_socket.readyState == 1) {
      _socket.send(JSON.encode(packet));
    }
    else {
      websocketLogger.severe("Could not send packet as the websocket is not ready for data.");
    }
  }
  
  Future<ServerPacket> sendGetResponse (RequireResponseClientPacket rrcp) {
    Completer c = new Completer();
    rrcpCompleters[rrcp.rID] = c;
    send (rrcp);
    return c.future;
  }
}