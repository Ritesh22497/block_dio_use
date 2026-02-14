import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login Screen"),
      ),

      body: Column(children: [
        TextFormField(
          decoration: InputDecoration(
            label: Text("username")
          ),
        ),
        TextFormField(
          decoration: InputDecoration(
            label: Text("password")   
          ),
        ),
        ElevatedButton(onPressed: (){}, child: Text("Login"))
      ],),
    );
  }
}