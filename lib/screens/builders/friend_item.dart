import 'package:distraction_destruction/screens/builders/start_session.dart';
import 'package:distraction_destruction/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

import 'overlay_popup.dart';

class FriendItem extends StatefulWidget {
  final String uid;
  final Timestamp? lastSession;
  final int score;
  final String name;

  const FriendItem(
      {Key? key,
      required this.uid,
      this.lastSession,
      this.score = -1,
      required this.name})
      : super(key: key);

  @override
  _FriendItemState createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<QuerySnapshot?>(context);
    dev.log(widget.uid, name: "User ID before Future");
    if (widget.score == -1) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.person,
              size: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            Text(widget.name),
            const Spacer(),
            ElevatedButton(
                onPressed: () {
                  DatabaseService().addFriend(widget.uid);
                },
                child: const Text("add friend"))
          ],
        ),
      );
    } else {
      return InkWell(
        onTap: () {
          showDialog(
              context: context,
              builder: (_) =>
                  OverlayPopup(contents: StartSession(name: widget.name, uid: widget.uid,)));
        },
          child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Row(
          children: <Widget>[
            const Icon(
              Icons.person,
              size: 40,
            ),
            const SizedBox(
              width: 20,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: TextStyle(fontSize: 20),
                ),
                Text(
                  "Last Session: " +
                      DateFormat('MMMd').format(widget.lastSession!.toDate()),
                  style: TextStyle(
                    fontSize: 10,
                  ),
                )
              ],
            ),
            const Spacer(),
            Text(
              widget.score.toString(),
              style: TextStyle(fontSize: 30),
            ),
          ],
        ),
          ),
      );
    }
  }
}
