import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distraction_destruction/screens/auth/sign_in.dart';
import 'package:distraction_destruction/screens/builders/friend_list.dart';
import 'package:distraction_destruction/screens/builders/session_popup.dart';
import 'package:distraction_destruction/services/database.dart';
import 'package:distraction_destruction/templates/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Display auth info, allowing users to login, register or await auto login
class Friends extends StatefulWidget {
  const Friends({Key? key}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return "Your Friends";
  }

  @override
  _FriendList createState() => _FriendList();
}

class _FriendList extends State<Friends> with AutomaticKeepAliveClientMixin {
  int _counter = 0;
  Widget addFriend = SizedBox(height: 0,);
  bool _add = false;

  void _addFriend() {
    setState(() {
      _add = !_add;
      addFriend = SessionPopup(contents: FriendList(showAll: true));
    });
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
    final user = Provider.of<AppUser?>(context);
    final DatabaseService database = DatabaseService();
    String name = '';

    super.build(context);
    return FutureBuilder<DocumentSnapshot?>(
      future: database.userDataFuture, //TODO Change to friend list database collection
      initialData: null,
      builder: (context, snapshot) {
        if(snapshot.hasError) {
          return Text("Something went wrong");
        } else if (snapshot.hasData || snapshot.data != null) {
          var info = snapshot.data!.data() as Map<String, dynamic>;
          name = info['name'];
          return Scaffold(
            backgroundColor: Colors.lightBlue[100],
            body: Center(
              // Center is a layout widget. It takes a single child and positions it
              // in the middle of the parent.
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(
                    widget.toString(),
                  ),
                  Text(
                    '$name',
                    style: Theme.of(context).textTheme.headline4,
                  ),
                  Expanded(
                      child: FriendList(showAll: false,)
                  ),
                ],
              ),
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {showDialog(context: context, builder: (_) => SessionPopup(contents: FriendList(showAll: true)));},
              tooltip: 'Add Friend',
              child: const Icon(Icons.person_add),
            ),
          );
        } else {
          return Text("Something else went wrong");
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}