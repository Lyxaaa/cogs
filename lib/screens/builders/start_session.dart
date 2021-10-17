import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distraction_destruction/screens/global/load.dart';
import 'package:distraction_destruction/services/database.dart';
import 'package:flutter/material.dart';
import 'package:numberpicker/numberpicker.dart';

class StartSession extends StatefulWidget {
  final String name;
  final String uid;

  const StartSession({Key? key, required this.name, required this.uid})
      : super(key: key);

  @override
  _StartSessionState createState() => _StartSessionState();
}

class _StartSessionState extends State<StartSession> {
  DatabaseService database = DatabaseService();
  TimeOfDay selectedTime = TimeOfDay(hour: 0, minute: 0);
  bool _userInSession = false;
  int _breaks = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'New Session with ' + widget.name,
          style: TextStyle(fontSize: 20.0),
        ),
        Text(
          'Set Session Length',
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    int hours = selectedTime.hour;
                    int mins = selectedTime.minute - 5;
                    if (mins < 0) {
                      if (hours != 0) {
                        mins += 60;
                        hours -= 1;
                      } else {
                        mins = 0;
                      }
                    }
                    selectedTime = TimeOfDay(hour: hours, minute: mins);
                  });
                },
                icon: Icon(Icons.remove_circle_outline)),
            ElevatedButton(
              onPressed: () {
                _selectTime(context);
              },
              child: Text(
                "${selectedTime.hour} hours, ${selectedTime.minute} minutes",
                style: TextStyle(fontSize: 15.0),
              ),
              style: ButtonStyle(),
            ),
            IconButton(
                onPressed: () {
                  setState(() {
                    int hours = selectedTime.hour;
                    int mins = selectedTime.minute + 5;
                    if (mins >= 60) {
                      mins -= 60;
                      hours += 1;
                    }
                    selectedTime = TimeOfDay(hour: hours, minute: mins);
                  });
                },
                icon: Icon(Icons.add_circle_outline))
          ],
        ),
        Text(
          'Set Breaks',
          style: TextStyle(
            fontSize: 12.0,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () {
                  setState(() {
                    _breaks = _breaks == 0 ? 0 : _breaks - 1;
                  });
                },
                icon: Icon(Icons.remove_circle_outline)),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  NumberPicker(
                    value: _breaks,
                    minValue: 0,
                    maxValue: 100,
                    onChanged: (value) => setState(() => _breaks = value),
                  );
                });
              },
              child: Text(
                _breaks.toString(),
                style: TextStyle(fontSize: 15.0),
              ),
              style: ButtonStyle(),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  _breaks = _breaks + 1;
                });
              },
              icon: Icon(Icons.add_circle_outline),
            ),
            Expanded(
              child: SizedBox(),
              flex: 1,
            ),
            ElevatedButton(
              onPressed: () {
                if (!_userInSession) {
                  print('starting session');
                  database.startSession(
                      widget.uid,
                      Timestamp.now(),
                      selectedTime.hour,
                      selectedTime.minute,
                      _breaks);
                }
                //TODO else {} Need to indicate to the user that the other user is already in an active session
                Navigator.pop(context, true);
              },
              child: StreamBuilder<DocumentSnapshot?>(
                  stream: database.getUserDocStream(widget.uid),
                  initialData: null,
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Load();
                    } else {
                      var otherUser = snapshot.data!.data() as Map<String, dynamic>;
                      _userInSession = otherUser['session_active'];
                      return Text('Start');
                    }
                  }
                  ),
            ),
          ],
        ),
      ],
    );
  }

  _selectTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        initialTime: selectedTime,
        initialEntryMode: TimePickerEntryMode.dial,
        helpText: 'Set Session Length',
        hourLabelText: 'Hours',
        minuteLabelText: 'Minutes',
        builder: (context, child) {
          return MediaQuery(
              data:
                  MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
              child: child!);
        });
    if (timeOfDay != null && timeOfDay != selectedTime) {
      setState(() {
        selectedTime = timeOfDay;
      });
    }
  }
}
