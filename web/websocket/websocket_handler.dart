part of FreemansClient;

class WebsocketHandler {
  static Logger websocketLogger = new Logger("WebsocketHandler");
  Map<String, Completer> rrcpCompleters = new Map<String, Completer>();
  WebSocket _socket;
  WebsocketHandler(String socketAddress) {
    _socket = new WebSocket(socketAddress);
    _socket.onClose.listen(this.onDisconnect);
    _socket.onOpen.listen(this.onConnect);
    _socket.onMessage.listen(this.onData);
  }
  void onConnect(Event event) {
    
  }
  
  void onDisconnect(CloseEvent event) {
    
  }
  
  void onData (MessageEvent event) {
       
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
    
    return c.future;
  }
}