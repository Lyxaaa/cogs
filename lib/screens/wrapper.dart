import 'package:distraction_destruction/screens/home/home.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

//Holds the screens of the application
class Wrapper extends StatelessWidget {
  const Wrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dev.log("Init Wrapper", name: 'screens.wrapper');
    //Return Home/Auth widget
    return Home();
  }
}
