import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distraction_destruction/screens/auth/sign_in.dart';
import 'package:distraction_destruction/screens/global/load.dart';
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
    print("BUILDING HOME");
    super.build(context);
    return StreamBuilder<DocumentSnapshot?>(
      stream: database.userDetailsStream,
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Load();
        } else {
          print("session a: " + snapshot.data!.data().toString());
          var userInfo = snapshot.data!.data() as Map<String, dynamic>;
          return Scaffold(
            body: Container(
              alignment: Alignment.topCenter,
              child: Column(
                children: [
                  Text(
                    title(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  lastSessionInfo(userInfo['session_uid'], userInfo['session_active']),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  StreamBuilder lastSessionInfo(String sessionUid, bool inSession) {
    return StreamBuilder<DocumentSnapshot?>(
      stream: database.getSessionStream(sessionUid),
      initialData: null,
      builder: (context, snapshot) {
        print("session: " + snapshot.data!.data().toString());
        if (!snapshot.hasData) {
          return const Load();
        } else if (snapshot.data == null){
          return Container(
            margin: EdgeInsets.all(20.0),
            color: Theme.of(context).cardColor,
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text('You have no session history',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text('Head over to the friends screen to get started!',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          );
        } else {
          var sessionInfo = snapshot.data!.data() as Map<String, dynamic>;
          int breaks = sessionInfo['breaks'];
          Timestamp startTime = sessionInfo['start'];
          Timestamp endTime = sessionInfo['end'];
          String thisUser = database.uid;
          String otherName = sessionInfo[sessionUid+'name'];
          int hours = sessionInfo['hours'];
          int minutes = sessionInfo['minutes'];
          int totalSeconds = endTime.seconds - startTime.seconds;
          int totalHours = (totalSeconds/3600).floor();
          int totalMinutes = (totalSeconds/60).floor().remainder(60);
          return Container(
            margin: EdgeInsets.all(20.0),
            color: Theme.of(context).cardColor,
            padding: EdgeInsets.all(20.0),
            alignment: Alignment.topCenter,
            child: Column(
              children: [
                Text(inSession
                    ? 'You\'re still in a session with $otherName!'
                    : 'Your last session with $otherName',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.0,
                  ),
                ),
                Text(inSession
                    ? 'Head back to your friends screen to continue your session'
                    : 'Your session lasted '
                    '${totalHours > 0 ? '${totalHours.toString()} hours ' : ''}'
                    '${totalHours > 0 && totalMinutes > 0 ? 'and ' : ''}'
                    '${totalHours == 0 || totalMinutes > 0 ? '${totalMinutes.toString()} minute' : ''}'
                    '${totalMinutes != 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15.0,
                  ),
                ),
              ],
            ),
          );
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
