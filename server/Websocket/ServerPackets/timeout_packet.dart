part of FreemansServer;

class ResponsePacketTimeoutServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.RESPONSE_PACKET_TIMEOUT;
  ResponsePacketTimeoutServerPacket ();
  toJson () {
    return { "ID": ID };
  }
}

