import 'package:flutter/widgets.dart';
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
  void dispose() {
    _timer.cancel();
    super.dispose();
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
                    var sessionInfo =
                        sessionSnapshot.data!.data() as Map<String, dynamic>;
                    int breaks = sessionInfo['breaks'];
                    Timestamp startTime = sessionInfo['start'];
                    Timestamp endTime = sessionInfo['end'];
                    String thisUser = database.uid!;
                    String otherUser = userInfo['session_uid'];
                    String otherName = sessionInfo['name'];
                    int hours = sessionInfo['hours'];
                    int minutes = sessionInfo['minutes'];
                    //TODO Make this look pretty
                    if (!sessionInfo[userInfo['session_uid']]) {
                      return waitingForAccept(userInfo['session_uid'], otherName);
                    } else if (!sessionInfo[database.uid]) {
                      return askToAccept(userInfo['session_uid'], otherName);
                    } else {
                      return active(userInfo['session_uid'], otherName, hours, minutes,
                          startTime, Timestamp.now().seconds);
                    }
                  }
                });
          }
        });
  }

  Scaffold askToAccept(String sessionUid, String name) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(name + ' wants to \nstart a session with you!',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      database.endSession(sessionUid);
                    },
                    // TODO: Fire off session start from here
                    child: Text("Decline".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(CircleBorder()),
                        padding:
                        MaterialStateProperty.all(const EdgeInsets.all(40)),
                        backgroundColor: MaterialStateProperty.all(Colors.amber)
                    )
                ),
                ElevatedButton(
                    onPressed: () {
                      database.acceptSession(sessionUid);
                    },
                    child: Text("Start".toUpperCase(),
                      style: const TextStyle(
                        fontSize: 25.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    style: ButtonStyle(
                        shape: MaterialStateProperty.all(CircleBorder()),
                        padding:
                        MaterialStateProperty.all(const EdgeInsets.all(40)),
                        backgroundColor: MaterialStateProperty.all(Colors.green)
                    )
                ),
              ],
            ),
            const Expanded(
              child: SizedBox(),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Scaffold waitingForAccept(String sessionUid, String name) {
    return Scaffold(
      // backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Waiting for ' + name + '\nto Accept your Invite',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            ElevatedButton(
                onPressed: () {
                  database.endSession(sessionUid);
                },
                child: Text("Cancel".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 25.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                    shape: MaterialStateProperty.all(CircleBorder()),
                    padding:
                        MaterialStateProperty.all(const EdgeInsets.all(40)),
                    backgroundColor: MaterialStateProperty.all(Colors.amber)
                )
            ),
            const Expanded(
              child: SizedBox(),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  Scaffold active(
      String sessionUid, String name, int hours, int minutes,
      Timestamp startTime, int now) {
    beginTimer(sessionUid, hours, minutes, startTime, now);
    return Scaffold(
      // backgroundColor: Colors.lightBlue[100],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Your Session with ' + name,
              style: const TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            Text(
              durationRemaining,
              style: const TextStyle(
                fontSize: 50.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            ElevatedButton(
                onPressed: () {
                  database.endSession(sessionUid);
                },
                child: Text(
                  "Stop".toUpperCase(),
                  style: const TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ButtonStyle(
                  shape: MaterialStateProperty.all(CircleBorder()),
                  padding: MaterialStateProperty.all(const EdgeInsets.all(40)),
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                )),
            const Expanded(
              child: SizedBox(),
              flex: 1,
            ),
          ],
        ),
      ),
    );
  }

  String get durationRemaining {
    String duration = '';
    if (_timer.remaining.inHours > 0)
      duration += _timer.remaining.inHours.toString() + ':';
    if (_timer.remaining.inHours > 0 && _timer.remaining.inMinutes.remainder(60) < 10) duration += '0';
    duration += _timer.remaining.inMinutes.remainder(60).toString() + ':';
    if (_timer.remaining.inSeconds.remainder(60) < 10) duration += '0';
    duration += _timer.remaining.inSeconds.remainder(60).toString();
    return duration;
  }

  void beginTimer(
      String otherUid, int hours, int minutes, Timestamp startTime, int now) {
    int durationNeeded =
        ((hours * 60 + minutes) * 60) - (now - startTime.seconds);
    if (durationNeeded <= 0) {
      _current = 0;
    } else if (!_timerStarted) {
      _timerStarted = true;
      _timer = CountdownTimer(
          Duration(seconds: durationNeeded), Duration(seconds: 1));
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
