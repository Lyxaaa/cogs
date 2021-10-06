import 'package:flutter/material.dart';
import 'dart:developer' as dev;

// onPressed: () {
//    showDialog(
//    context: context,
//    builder: (BuildContext context) => createDialog(context),
//  );
// },
class SessionPopup extends StatefulWidget {
  const SessionPopup({Key? key}) : super(key: key);

  @override
  _SessionPopupState createState() => _SessionPopupState();
}

class _SessionPopupState extends State<SessionPopup> {
  @override
  Widget build(BuildContext context) {
    return Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: EdgeInsets.fromLTRB(0, 10, 0, 20),
        child: FractionallySizedBox(
            widthFactor: 0.8,
            heightFactor: 1,
            child: Stack(children: <Widget>[
              Column(children: <Widget>[
                Expanded(
                  flex: 6,
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        color: Colors.white),
                    padding: EdgeInsets.fromLTRB(20, 20, 20, 20),
                    child: const Text("New Session",
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center),
                  ),
                ),
                Container(height: 48)
              ]),
              Positioned.fill(
                  bottom: 0, // Half of button size, approximately?
                  child: Align(
                      alignment: Alignment.bottomCenter,
                      child: ElevatedButton(
                          onPressed: () {},
                          // TODO: Fire off session start from here
                          child: Text("Start".toUpperCase()),
                          style: ButtonStyle(
                              shape: MaterialStateProperty.all(CircleBorder()),
                              padding: MaterialStateProperty.all(
                                  const EdgeInsets.all(40)),
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.amber)))))
            ])));
  }
}
