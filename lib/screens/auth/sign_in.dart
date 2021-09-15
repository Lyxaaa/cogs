import 'package:distraction_destruction/services/auth_svc.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[200],
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[400],
        elevation: 0.0,
        title: const Text("Sign in to Distraction Destruction"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: ElevatedButton(
          child: const Text("Sign in Anonymously"),
          onPressed: () async {
            dynamic result = await _auth.signInAnon();
            if (result == null) {
              dev.log("Error signing in Anonymously", name: "screens.auth.sign_in");
            } else {
              dev.log("Signed in Anonymously: " + result.uid, name: "screens.auth.sign_in");
            }
          },
        ),
      ),
    );
  }
}
