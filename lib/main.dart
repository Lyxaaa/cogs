import 'package:distraction_destruction/screens/wrapper.dart';
import 'package:distraction_destruction/services/auth_svc.dart';
import 'package:distraction_destruction/templates/user.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  dev.log("Main", name: 'main');
  runApp(const MyApp());
}

//Simply launches the app. Anything we need to prepare pre-launch should be
//done here, everything else can be put in Wrapper and its children
class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<AppUser?>.value(
      value: AuthService().user,
      initialData: null,
      child: MaterialApp(
        title: 'Distraction Part 2: Destruction Boogaloo',
        theme: ThemeData(
          //Theme of app here
          //Remember to take advantage of hot reload
          primarySwatch: Colors.blue,
        ),
        home: Wrapper(),
      ),
    );
  }
}