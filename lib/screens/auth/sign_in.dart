import 'package:distraction_destruction/services/auth_svc.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class SignIn extends StatefulWidget {
  final Function toggle;

  SignIn({required this.toggle});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final AuthService _auth = AuthService();
  final _signInKey = GlobalKey<FormState>();
  String email = '';
  String password = '';
  String err = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent[400],
        elevation: 0.0,
        title: const Text("Sign in to Distraction Destruction"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _signInKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                //TODO decoration: put all the fancy ladida designer stuff here :)
                validator: (input) => input!.isEmpty ? "enter email": null,
                onChanged: (input) {
                  setState(() {
                    email = input;
                  });
                },
              ),
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
                validator: (input) => input!.length < 6 ? "enter password (min 6 characters)": null,
                onChanged: (input) {
                  setState(() {
                    password = input;
                  });
                },
                obscureText: true,
              ),
              const SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  if (_signInKey.currentState!.validate()) {
                    dev.log(email, name: "email");
                    dynamic result = await _auth.signIn(email, password);
                    if (result == null) {
                      setState(() {
                        err = "Invalid Credentials";
                      });
                    }
                  }
                },
                child: const Text(
                  "Sign In",
                  style: TextStyle(color: Colors.white),
                ),
                //style: ButtonStyle(),
              ),
              SizedBox(height: 20.0,),
              Text(
                err,
                style: TextStyle(color: Colors.red, fontSize: 14.0),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: ElevatedButton(
                    onPressed: () {
                      dev.log("Switch pressed");
                      widget.toggle();
                    },
                    child: const Text(
                      "Don't have an account? Register Here",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/*
ElevatedButton(
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
 */
