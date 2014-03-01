part of FreemansServer;


class WebsocketHandler {
  
  // Holds all our clients currently connected
  Map<int, Client> clients = new Map<int, Client>();
  // Decoder used to decode JSON packets
  JsonDecoder decoder = new JsonDecoder(null);
  JsonEncoder encoder = new JsonEncoder(null);
  void start (InternetAddress ipAddress, int port) {
    ffpServerLog.info ("Starting HTTP/Websocket server on $ipAddress:$port");
    
    // Listen to HTTP Connections on the specified port
    HttpServer.bind(ipAddress, port).then((HttpServer server) {
      
        // Create a new stream controller to handle our websocket connections separately from our normal http connections
        var sc = new StreamController();
        
        // Transform and listen to the stream
        sc.stream.transform(new WebSocketTransformer()).listen((WebSocket conn) {
          Client cli;
          if (!clientExists(conn)) cli = addClient(conn);
          else cli = getClientFromSocket(conn);
          
          void onMessage(message) {
            try { 
              // Parse the sent message into JSON
              dynamic obj = decoder.convert(message);
              if (obj is Map) {
                if (obj.containsKey("ID") && obj["ID"] is int) {
                  // Construct our client packet
                  ClientPacket c = ClientPacket.getPacket(obj["ID"], obj);
                  print(obj);
                  // Send the client and websocket handler to the packet and ask it to handle the packet.
                  if (c != null) {
                    if (obj.containsKey("rID") && obj["rID"] is String) {
                      String rID = obj["rID"];
                      if (cli.isResponse(rID)) {
                        cli.foundResponse(obj["rID"], this, c);
                      }
                      else c.handlePacket(this, cli);
                    }
                    else c.handlePacket(this, cli);
                  }
                }
              }
            }
            catch (e) {
              print("Error when parsing packet $e");
            }
          }
          // Listen to the websocket for messages
          conn.listen(onMessage,
              onDone: () => removeClient(cli),
              onError: (e) => removeClient(cli)
          );
        });
        
      // Listen to normal http connections and upgrade them to a websocket connection
      server.listen((HttpRequest request) { 
        ffpServerLog.info ("New connection to server");
        print(request.uri.path);
        if (request.uri.path == "/websocket") {
          ffpServerLog.info ("Websocket request found... forwarding...");
               sc.add(request);
        }
      });
      
    });
  }
  
  /// Sends an object to all clients on the WebSocket
  void sendPacketToAll (ServerPacket message) {
    sendStringToAll(encoder.convert(message));
  }
  
  /// Sends a string to all clients on the WebSocket
  void sendStringToAll (String message) {
    clients.forEach((k, v) { 
      v.s.add(message);
    });
  }
  
  
  /// Removes a client from the WebSocket client map
  void removeClient (Client cli) {
    if (clients.containsKey(cli.s.hashCode)) {
      clients.remove(cli.s.hashCode);
    }
  }
  
  /// Checks if a WebSocket is currently added to the WebSocket client map
  bool clientExists (WebSocket s) { 
    return clients.containsKey(s.hashCode);
  }
  
  /// Adds a client to the WebSocket client map
  Client addClient (WebSocket s) {
    Client t =  new Client(s, this);
    clients[s.hashCode] = t;
    return t;
  }
  
  /// Gets a [client] from the WebSocket client map from the socket connection
  Client getClientFromSocket (WebSocket s) {
    if (clients.containsKey(s.hashCode)) {
      return clients[s];
    }
  }
  
}
