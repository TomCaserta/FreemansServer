part of FreemansClient;

class WebsocketHandler {
  static Logger websocketLogger = new Logger("WebsocketHandler");
  Map<String, Completer> rrcpCompleters = new Map<String, Completer>();
  WebSocket _socket;
  bool get loaded {
    return _socket.readyState == 1;
  }
  WebsocketHandler(String socketAddress) {
    _socket = new WebSocket(socketAddress);
    _socket.onClose.listen(this.onDisconnect);
    _socket.onOpen.listen(this.onConnect);
    _socket.onMessage.listen(this.onData);
    _socket.onError.listen(this.onError);
  }
  
  void onError (Event event) {
    websocketLogger.severe("Websocket has encountered an error. ${_socket.readyState}");
  }
  
  void onConnect(Event event) {
    websocketLogger.info("Connection established");
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
           if (response.containsKey("rID") && response["rID"] is String) {
             if (rrcpCompleters.containsKey(response["rID"])) {
               rrcpCompleters[response["rID"]].complete(sp);
               rrcpCompleters.remove(response["rID"]);
             }
             else sp.handlePacket();
           }
           else sp.handlePacket();
         }
         else {
           websocketLogger.severe("Received malformed packet: $response");
         }
        }
       }
     }
     catch (E) {
       websocketLogger.severe("Received malformed packet: ${event.data}");
     }
  }
  
  void send (ClientPacket packet) {
    if (_socket.readyState == 1) {
      
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