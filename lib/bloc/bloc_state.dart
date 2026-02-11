abstract class LoginState{}
class LoginReqEvent extends LoginState {  
  String? username;
  String? password;
LoginReqEvent({this.username,this.password});
}


