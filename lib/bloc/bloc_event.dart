abstract class LoginEvent{}
class LoginReqEvent extends LoginEvent{
  String? username;
  String? password;
LoginReqEvent({this.username,this.password});
}