part of FreemansServer;

abstract class ServerPacket {
   static int ID;
   toJson();
}
abstract class ResponsePacket extends ServerPacket {
  
}


class UserPassIncorrectServerPacket extends ResponsePacket {
  static int ID = SERVER_PACKET_IDS.USER_PASS_INCORRECT_ID;
  String RID;
  UserPassIncorrectServerPacket (this.RID);
  
  toJson () {
    return { "ID": ID, "RID": RID };
  }
}


class DisconnectServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.DISCONNECT_SERVER;
  String reason;
  DisconnectServerPacket(this.reason);
  toJson () {
    return { "ID": ID, "reason": reason };
  }
}

class LoggedInServerPacket extends ServerPacket {
  static int ID = SERVER_PACKET_IDS.LOGGED_IN;
  LoggedInServerPacket();
  //TODO: Send connection and negotiate information
  toJson () {
    return { "ID": ID };
  }
}

class SERVER_PACKET_IDS {
  static const int USER_PASS_INCORRECT_ID = 1;
  static const int RESPONSE_PACKET_TIMEOUT = 2;
  static const int DISCONNECT_SERVER = 3;
  static const int LOGGED_IN = 4;
}
