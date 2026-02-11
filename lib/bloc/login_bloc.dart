
    import 'package:http/http.dart' as http;
    
    class LoginBloc {
      Future<void> login() async {
        await http.post(Uri.parse('https://example.com/login'));
      }
    }