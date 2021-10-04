import 'package:distraction_destruction/screens/auth/auth.dart';
import 'package:distraction_destruction/screens/main_scaffold/main_scaffold.dart';
import 'package:distraction_destruction/templates/user.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

import 'package:provider/provider.dart';

//Holds the screens of the application
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dev.log("Init Wrapper", name: 'screens.wrapper');

    //Forces anything that relies on the status of User to be triggered upon change
    final user = Provider.of<AppUser?>(context);

    dev.log("Obtained user: " + user.toString());
    return user == null ? Auth() : Home();
    //Return Home/Auth widget
    //return Auth();
  }
}
