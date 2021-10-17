import 'package:quiver/async.dart';
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
  int _current = 0;
  bool _timerStarted = false;
  late CountdownTimer _timer;
  var _sub;

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
            // this contains info about the logged in user
            var userInfo = snapshot.data!.data() as Map<String, dynamic>;
            return StreamBuilder<DocumentSnapshot?>(
                stream: database.getSessionStream(userInfo['session_uid']),
                builder: (context, sessionSnapshot) {
                  if (!sessionSnapshot.hasData) {
                    return Load();
                  } else {
                    // this contains info about the current active session
                    var sessionInfo = sessionSnapshot.data!.data() as Map<String, dynamic>;
                    int breaks = sessionInfo['breaks'];
                    Timestamp startTime = sessionInfo['start'];
                    Timestamp endTime = sessionInfo['end'];
                    String thisUser = database.uid!;
                    String otherUser = userInfo['session_uid'];
                    int hours = sessionInfo['hours'];
                    int minutes = sessionInfo['minutes'];
                    //TODO Make this look pretty
                    if (!sessionInfo[userInfo['session_uid']]) {
                      return waitingForAccept(userInfo['session_uid']);
                    } else if (!sessionInfo[database.uid]) {
                      return askToAccept(userInfo['session_uid']);
                    } else {
                      return active(userInfo['session_uid'], hours, minutes, startTime, Timestamp.now().seconds);
                    }
                  }
                });
          }
        });
  }

  Scaffold askToAccept(String sessionUid) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text("Would you like to start a session with user?"), //TODO pull users name down here without another DB call
            ElevatedButton(
                onPressed: () {
                  database.acceptSession(sessionUid);
                },
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
      );
    }

  Scaffold active(String sessionUid, int hours, int minutes, Timestamp startTime, int now) {
      beginTimer(sessionUid, hours, minutes, startTime, now);
      return Scaffold(
        // backgroundColor: Colors.lightBlue[100],
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(_current.toString()),
              ElevatedButton(
                  onPressed: () {
                    database.endSession(sessionUid);
                  },
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
      );
  }

  void beginTimer(String otherUid, int hours, int minutes, Timestamp startTime, int now) {
    int durationNeeded = ((hours * 60 + minutes) * 60) - (now - startTime.seconds);
    print(durationNeeded);
    if (durationNeeded <= 0) {
      _current = 0;
    } else if (!_timerStarted) {
      _timerStarted = true;
      _timer = CountdownTimer(
          Duration(seconds: durationNeeded),
          Duration(seconds: 1)
      );
      _sub = _timer.listen(null);
      _sub.onData((duration) {
        setState(() {
          _current = durationNeeded - duration.elapsed.inSeconds as int;
        });
      });

      _sub.onDone(() {
        _sub.cancel();
        database.endSession(otherUid);
      });
    }

  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
