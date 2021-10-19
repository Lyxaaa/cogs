import 'package:distraction_destruction/screens/auth/sign_in.dart';
import 'package:distraction_destruction/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

//Display auth info, allowing users to login, register or await auto login
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return "Welcome Back";
  }

  @override
  _HomePage createState() => _HomePage();
}

class _HomePage extends State<Home> with AutomaticKeepAliveClientMixin {
  int _counter = 0;
  DatabaseService database = DatabaseService();
  String title() {
    return "Welcome Back " + database.name;
  }

  void _incrementCounter() {
    setState(() {
      // tells Flutter framework that something has changed in this State,
      // which causes it to rerun the build method below
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      body: Container(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            Text(
              title(),
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
