import 'package:distraction_destruction/screens/builders/friend_item.dart';
import 'package:distraction_destruction/screens/global/load.dart';
import 'package:distraction_destruction/services/database.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'dart:developer' as dev;

class FriendList extends StatefulWidget {
  final bool showAll;
  final bool search;
  final String searchQuery;
  const FriendList({Key? key, this.showAll=false, this.searchQuery=''})
      : search = searchQuery != null,
        super(key: key);

  @override
  _FriendListState createState() => _FriendListState();
}

class _FriendListState extends State<FriendList> {
  final DatabaseService database = DatabaseService();

  @override
  Widget build(BuildContext context) {
    if (widget.showAll) {
      //Displays ALL users registered in the app, mostly for debug/testing purposes
      return StreamBuilder<QuerySnapshot?>(
          stream: database.userCollectionStream,
          initialData: null,
          builder: (context, userCollectionSnapshot) {
            if (userCollectionSnapshot.hasError) {
              return const Text("Something went wrong");
            } else if (userCollectionSnapshot.hasData || userCollectionSnapshot.data != null) {
                return ListView.separated(
                    itemBuilder: (context, index) {
                      var uid = userCollectionSnapshot.data!.docs[index].id;
                      var userList = userCollectionSnapshot.data!.docs[index].data() as Map<
                          String,
                          dynamic>;
                      String name = userList['name'];
                      return FriendItem(
                        uid: uid,
                        name: name,);
                    },
                    separatorBuilder: (context, index) =>
                    const SizedBox(height: 20.0),
                    itemCount: userCollectionSnapshot.data!.docs.length);
            } else {
              return const Text("A different something went wrong");
            }
          }
      );
    } else {
      //Displays all users that the current user is friends with
      return StreamBuilder<QuerySnapshot?>(
          stream: database.friendsCollectionStream,
          //TODO Change to friend list database collection
          initialData: null,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Load();
            } else if (snapshot.hasData || snapshot.data != null) {
              return ListView.separated(
                  itemBuilder: (context, index) {
                    var uid = snapshot.data!.docs[index].id;
                    dev.log(uid, name: "User ID Check");
                    var userInfo = snapshot.data!.docs[index].data() as Map<String, dynamic>;
                    Timestamp lastSession = userInfo['last_session'];
                    int score = userInfo['score'];
                    return FutureBuilder<DocumentSnapshot?>(
                    future: DatabaseService().getUserDocStream(uid),
                    initialData: null,
                    builder: (context, snapshot) {
                      if (snapshot.hasError) {
                        return Load();
                      } else if (snapshot.hasData || snapshot.data != null) {
                        dev.log(snapshot.data!.data().toString(), name: "friend_item.dart");
                        var userInfo = snapshot.data!.data() as Map<String,
                            dynamic>; //TODO Find out how to reference a doc cell
                        bool show = true;
                        if (widget.searchQuery.length > 2
                            && !userInfo['name'].toString().toLowerCase()
                                .contains(widget.searchQuery)) {
                          show = false;
                        }
                        return FriendItem(
                          uid: uid, lastSession: lastSession, score: score, name: userInfo['name'], show: show,);
                      } else {
                        return Load();
                      }
                    }
                    );
                  },
                  separatorBuilder: (context, index) =>
                  const SizedBox(height: 20.0),
                  itemCount: snapshot.data!.docs.length);
            } else {
              return Load();
            }
          }
      );
    }
  }
}
