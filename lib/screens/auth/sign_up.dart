import 'package:distraction_destruction/services/auth_svc.dart';
import 'package:flutter/material.dart';
import 'dart:developer'as dev;

class SignUp extends StatefulWidget {
  final Function toggle;

  SignUp({required this.toggle});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final AuthService _auth = AuthService();
  final _signUpKey = GlobalKey<FormState>();
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
        title: const Text("Sign up to Distraction Destruction"),
      ),
      body: Container(
        padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
        child: Form(
          key: _signUpKey,
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20.0,
              ),
              TextFormField(
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
                  if (_signUpKey.currentState!.validate()) {
                    dev.log(email, name: "email");
                    dynamic result = await _auth.signUp(email, password);
                    if (result == null) {
                      setState(() {
                        err = "Invalid Credentials";
                      });
                    }
                  }
                },
                child: const Text(
                  "Register",
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
                      widget.toggle();
                    },
                    child: const Text(
                      "Back to Sign In",
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
