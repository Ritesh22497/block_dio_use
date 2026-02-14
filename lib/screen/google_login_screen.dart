// import 'package:block_dio_use/core/my_button.dart';
// import 'package:block_dio_use/go_router.dart';
// import 'package:block_dio_use/screen/signupScreen.dart';
// import 'package:flutter/material.dart';

// class LoginScreen extends StatelessWidget {
//   const LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Login Screen"),
//       ),

//       body: Column(children: [
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
      
//         CustomButton(onTap: (){},text: "Login",),
//         Row(children: [Spacer(),Text("Don't have an account? "),GestureDetector(
//           onTap: (){
//             NavigationHelper.push(context, SignupScreen());
//           },
//           child: Text("SingnUp",style: TextStyle(fontWeight: FontWeight.bold),))],)
       
//       ],),
//     );
//   }
// }

import 'package:block_dio_use/core/my_button.dart';
import 'package:block_dio_use/go_router.dart';
import 'package:block_dio_use/screen/MainHomeScreen.dart';
import 'package:block_dio_use/screen/signupScreen.dart';
import 'package:block_dio_use/service/auth_providder.dart';
import 'package:block_dio_use/service/auth_service.dart';
import 'package:flutter/material.dart';


import 'package:flutter_riverpod/flutter_riverpod.dart';
class UserLoginScreen extends ConsumerWidget {
  const UserLoginScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    double height = MediaQuery.of(context).size.height;
    final formState = ref.watch(authFormProvider);
    final formNotifer = ref.read(authFormProvider.notifier);
    final authMethod = ref.read(authMethodProvider);
    void login() async {
      formNotifer.setLoading(true);
      final res = await authMethod.loginUser(
        email: formState.email,
        password: formState.password,
      );
      formNotifer.setLoading(false);
      if (res == "success") {




        



        NavigationHelper.pushReplacement(context, MainHomeScreen());
        // mySnackBar(message: "Successful Login.", context: context);
        // showAppSnackbar(
        //   context: context,
        //   type: SnackbarType.success,
        //   description: "Successful Login",
        // );
      } else {
        //    showAppSnackbar(
        //   context: context,
        //   type: SnackbarType.error,
        //   description: res,
        // );
      }
    }
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: height / 2.1,
              width: double.maxFinite,
              child: Image.asset("assets/2752392.jpg", fit: BoxFit.cover),
            ),
            Padding(
              padding: EdgeInsets.all(15),
              child: Column(
                children: [
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
                          onTap: formState.isFormValid ? login : null,
                          text: "Login",
                        ),
                  SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: Container(height: 1, color: Colors.black26),
                      ),
                      Text(" or "),
                      Expanded(
                        child: Container(height: 1, color: Colors.black26),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  // for google auth
                //  GoogleLoginScreen(),
                  SizedBox(height: 15),
                  Row(
                    children: [
                      Spacer(),
                      Text("Don't have an account? "),
                      GestureDetector(
                        onTap: () {
                          NavigationHelper.push(context, SignupScreen());
                        },
                        child: Text(
                          "SignUp",
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