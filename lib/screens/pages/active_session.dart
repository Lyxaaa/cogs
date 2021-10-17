import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distraction_destruction/screens/auth/sign_in.dart';
import 'package:distraction_destruction/screens/global/load.dart';
import 'package:distraction_destruction/services/database.dart';
import 'package:flutter/material.dart';

//Display auth info, allowing users to login, register or await auto login
class ActiveSession extends StatefulWidget {
  const ActiveSession({Key? key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return "Welcome Back";
  }

  @override
  _ActiveSessionPage createState() => _ActiveSessionPage();
}

class _ActiveSessionPage extends State<ActiveSession>
    with AutomaticKeepAliveClientMixin {
  DatabaseService database = DatabaseService();
  int _counter = 0;

  String title() {
    return "Session in Progress";
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
    return StreamBuilder<DocumentSnapshot?>(
        //TODO set loading screen here to prevent error screen from momentarily showing
        stream: database.userDetailsStream,
        initialData: null,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Load();
          } else {
            var userInfo = snapshot.data!.data() as Map<String, dynamic>;
            return StreamBuilder<DocumentSnapshot?>(
                stream: database.getSessionStream(userInfo['session_uid']),
                builder: (context, sessionSnapshot) {
                  if (!sessionSnapshot.hasData) {
                    return Load();
                  } else {
                    var sessionInfo = sessionSnapshot.data!.data() as Map<String, dynamic>;
                    if (!sessionInfo[userInfo['session_uid']]) {
                      return waitingForAccept(userInfo['session_uid']);
                    } else if (!sessionInfo[database.uid]) {
                      return askToAccept(userInfo['session_uid']);
                    } else {
                      return active(userInfo['session_uid']);
                      print("session info: " + sessionInfo.toString());
                    }
                  }
                });
          }
        });
  }

  Scaffold askToAccept(String sessionUid) {
    return Scaffold(
      // backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Would you like to start a session with user?"), //TODO pull users name down here without another DB call
            ElevatedButton(
                onPressed: () {
                  database.acceptSession(sessionUid);
                },
                // TODO: Fire off session start from here
                child: Text("Start".toUpperCase()),
                style: ButtonStyle(
                    shape:
                    MaterialStateProperty.all(CircleBorder()),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.all(40)),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.amber)
                )
            ),
            ElevatedButton(
                onPressed: () {
                  database.endSession(sessionUid);
                },
                // TODO: Fire off session start from here
                child: Text("Decline".toUpperCase()),
                style: ButtonStyle(
                    shape:
                    MaterialStateProperty.all(CircleBorder()),
                    padding: MaterialStateProperty.all(
                        const EdgeInsets.all(40)),
                    backgroundColor:
                    MaterialStateProperty.all(Colors.amber)
                )
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Scaffold waitingForAccept(String sessionUid) {
      return Scaffold(
        // backgroundColor: Colors.lightBlue[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text("Waiting for user to accept session"), //TODO pull users name down here without another DB call
              ElevatedButton(
                  onPressed: () {
                    database.endSession(sessionUid);
                  },
                  // TODO: Fire off session start from here
                  child: Text("Cancel".toUpperCase()),
                  style: ButtonStyle(
                      shape:
                      MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.all(40)),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.amber))),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    }

  Scaffold active(String sessionUid) {
      return Scaffold(
        // backgroundColor: Colors.lightBlue[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                  onPressed: () {
                    database.endSession(sessionUid);
                  },
                  // TODO: Fire off session start from here
                  child: Text("Stop".toUpperCase()),
                  style: ButtonStyle(
                      shape:
                      MaterialStateProperty.all(CircleBorder()),
                      padding: MaterialStateProperty.all(
                          const EdgeInsets.all(40)),
                      backgroundColor:
                      MaterialStateProperty.all(Colors.amber))),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: _incrementCounter,
          tooltip: 'Increment',
          child: const Icon(Icons.add),
        ),
      );
    }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
