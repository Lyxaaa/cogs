import 'package:distraction_destruction/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:developer' as dev;

class FriendItem extends StatefulWidget {
  final String uid;
  final Timestamp? lastSession;
  final int score;
  final String name;
  const FriendItem({Key? key, required this.uid, this.lastSession, this.score=-1, required this.name}) : super(key: key);

  @override
  _FriendItemState createState() => _FriendItemState();
}

class _FriendItemState extends State<FriendItem> {
  @override
  Widget build(BuildContext context) {
    final friends = Provider.of<QuerySnapshot?>(context);
    dev.log(friends?.docs.toString() ?? "Friends Empty", name: "screens.pages.friend_list.build");
    return FutureBuilder<DocumentSnapshot?>(
    future: DatabaseService().getUserDocStream(widget.uid),
    initialData: null,
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return const Text("Something went wrong when creating friend list");
      } else if (snapshot.hasData || snapshot.data != null) {
        dev.log("Data Found", name: "friend_item.dart");
        //var userInfo = snapshot.data!.data() as Map<String, dynamic>; //TODO Find out how to reference a doc cell
        if (widget.score == -1) {
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.person,
                  size: 40,
                ),
                const SizedBox(width: 20,),
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
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Row(
              children: <Widget>[
                const Icon(
                  Icons.person,
                  size: 40,
                ),
                const SizedBox(width: 20,),
                Column(
                  children: [
                    Text(widget.name),
                    Text(
                      "Last Session: " + DateFormat('MMMd').format(widget.lastSession!.toDate()),
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    )
                  ],
                ),
                const Spacer(),
                Text(widget.score.toString()),
              ],
            ),
          );
        }
      } else {
        return const Text("Something else went wrong when creating friend list");
      }
    });
  }
}
