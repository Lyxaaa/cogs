import 'package:flutter/material.dart';

class StartSession extends StatefulWidget {
  final String name;
  final String uid;
  const StartSession({Key? key, required this.name, required this.uid}) : super(key: key);

  @override
  _StartSessionState createState() => _StartSessionState();
}

class _StartSessionState extends State<StartSession> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('New Session with ' + widget.name)
      ],
    );
  }
}
