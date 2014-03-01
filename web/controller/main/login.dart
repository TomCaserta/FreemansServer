part of FreemansClient;

@NgController(
    selector: '[login]',
    publishAs: 'login'
)
class Login {
  String username = "";
  String password = "";
  bool loggingin = false;
  bool get error {
    return errors.length > 0 ? true : false;
  }
  List<String> errors = new List<String>();
  
  static String USERNAME_EMPTY = "Username field is blank.";
  static String PASSWORD_EMPTY = "Password field is blank.";
  StateService service;
  Login(this.service);
  
  void done() {
    bool req = true;
    if (this.username == "") {
      req = false;
      addError(USERNAME_EMPTY);
    }
    if (this.password == "") {
      req = false;
      addError(PASSWORD_EMPTY);
    }
    if (req) {
      errors = new List<String>();
      service.wsh.sendGetResponse(new AuthenticateClientPacket(this.username, this.password)).then((ServerPacket packet) { 
        if (packet is ActionResponseServerPacket) { 
          packet.payload.forEach((e) {
            if (e is String) addError(e);
          });
        }
        else if (packet is LoggedInServerPacket) {
             loggingin = true;  
             service.loggedIn = true;
             service.currUser = new User.fromJson(packet.user); 
             service.wsh.sendGetResponse(new InitialDataRequestClientPacket()).then((ServerPacket packet) {
               if (packet is InitialDataResponseServerPacket) {
                  service.parseInitializationPacket(packet);
                }               
             });
        }
      });
    }
    
  }
  
  void change (String field) { 
    if (field == "username") {
      if (this.username != "") {
        removeError(USERNAME_EMPTY);
      }
    }
    else if (field == "password") {
      if (this.password != "") {
        removeError(PASSWORD_EMPTY);
      }
    }
  }
  
  void removeError (String error) {
    if (errors.contains(error)) errors.remove(error);
  }
  
  void addError (String error) {
    if (!errors.contains(error)) {
      errors.add(error);
    }
  }
}