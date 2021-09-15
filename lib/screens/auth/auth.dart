import 'package:distraction_destruction/screens/auth/sign_in.dart';
import 'package:flutter/material.dart';

//Display auth info, allowing users to login, register or await auto login
class Auth extends StatefulWidget {
  const Auth({Key? key}) : super(key: key);

  @override
  _AuthState createState() => _AuthState();
}

class _AuthState extends State<Auth> {
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SignIn(),
    );
  }
}
