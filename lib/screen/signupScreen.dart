// import 'package:block_dio_use/core/my_button.dart';
// import 'package:block_dio_use/go_router.dart';
// import 'package:block_dio_use/screen/google_login_screen.dart';
// import 'package:flutter/material.dart';

// class SignupScreen extends StatelessWidget {
//   const SignupScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("SignUp Screen"),
//       ),

//       body: Column(children: [
//         TextField(
//           autocorrect: true,
//           keyboardType: TextInputType.text,
//           decoration: InputDecoration(

//             prefix: Icon(Icons.email),
//             label: Text("Enter your name"),
//             contentPadding: EdgeInsets.all(15)
//           ),
//         ),
//         TextField(
//           autocorrect: true,
//           keyboardType: TextInputType.emailAddress,
//           decoration: InputDecoration(

//             prefix: Icon(Icons.email),
//             label: Text("Enter your email"),
//             contentPadding: EdgeInsets.all(15)
//           ),
//         ),
//         TextField(
//           autocorrect: true,
//           keyboardType: TextInputType.visiblePassword,
//           decoration: InputDecoration(

//             prefix: Icon(Icons.email),
//             label: Text("Enter your password"),
//             contentPadding: EdgeInsets.all(15)
//           ),
//         ),
              
//         CustomButton(onTap: (){},text: "SignUP",),
//         Row(children: [Spacer(),Text("Already have an account? "),GestureDetector(
//           onTap: (){
//             NavigationHelper.push(context, LoginScreen());
//           },
//           child: Text("Login",style: TextStyle(fontWeight: FontWeight.bold),))],)
       
//       ],),
//     );
//   }
// }

import 'package:block_dio_use/core/my_button.dart';
import 'package:block_dio_use/go_router.dart';
import 'package:block_dio_use/screen/google_login_screen.dart';
import 'package:block_dio_use/service/auth_providder.dart';
import 'package:block_dio_use/service/auth_service.dart';
import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';
class SignupScreen extends ConsumerWidget {
  const SignupScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formState = ref.watch(authFormProvider);
    final formNotifer = ref.read(authFormProvider.notifier);
    final authMethod = ref.read(authMethodProvider);
    void sigup() async {
      formNotifer.setLoading(true);
      final res = await authMethod.signUpUser(
        email: formState.email,
        password: formState.password,
        name: formState.name,
      );
      formNotifer.setLoading(false);
      if (res == "success" && context.mounted) {
        NavigationHelper.pushReplacement(context, UserLoginScreen());
        // showAppSnackbar(
        //   context: context,
        //   type: SnackbarType.success,
        //   description: "Sinup Up Successful. Now turn to login",
        // );
      } else {
        if (context.mounted) {
          // showAppSnackbar(
          //   context: context,
          //   type: SnackbarType.error,
          //   description: res,
          // );
        }
      }
    }
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ListView(
          children: [
            Container(
              height: height / 2.4,
              width: double.maxFinite,
              decoration: BoxDecoration(),
              child: Image.asset("assets/77881.jpg", fit: BoxFit.cover),
            ),
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
                  TextField(
                    autocorrect: false,
                    onChanged: (value) => formNotifer.updateName(value),
                    keyboardType: TextInputType.text,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.person),
                      labelText: "Enter your name",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15),
                      errorText: formState.nameError,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    autocorrect: false,
                    onChanged: (value) => formNotifer.updateEmail(value),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.email),
                      labelText: "Enter your email",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15),
                      errorText: formState.emailError,
                    ),
                  ),
                  SizedBox(height: 15),
                  TextField(
                    autocorrect: false,
                    onChanged: (value) => formNotifer.updatePassword(value),
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: formState.isPasswordHidden,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.lock),
                      labelText: "Enter your password",
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(15),
                      errorText: formState.passwordError,
                      suffixIcon: IconButton(
                        onPressed: () => formNotifer.togglePasswordVisibility(),
                        icon: Icon(
                          formState.isPasswordHidden
                              ? Icons.visibility_off
                              : Icons.visibility,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  formState.isLoading
                      ? Center(child: CircularProgressIndicator())
                      : CustomButton(
                          onTap: formState.isFormValid ? sigup : null,
                          text: "Sign Up",
                        ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Spacer(),
                      Text("Already have an account?"),
                      GestureDetector(
                        onTap: () {
                          NavigationHelper.push(context, UserLoginScreen());
                        },
                        child: Text(
                          "Login",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}