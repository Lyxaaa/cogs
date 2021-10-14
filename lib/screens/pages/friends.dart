import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distraction_destruction/screens/auth/sign_in.dart';
import 'package:distraction_destruction/screens/builders/friend_list.dart';
import 'package:distraction_destruction/screens/builders/overlay_popup.dart';
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
  final DatabaseService database = DatabaseService();
  final _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }


  void _addFriend() {
    setState(() {
      _add = !_add;
      addFriend = OverlayPopup(contents: FriendList(showAll: true));
    });
  }

  void _incrementCounter() {
    setState(() {
      // tells Flutter framework that something has changed in this State,
      // which causes it to rerun the build method below
      _counter++;
    });
  }

  String search = '';

  void setSearch(String search) {
    setState(() {
      this.search = search;
    });
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    String name = '';

    super.build(context);
    //Puts the cursor at the end of the search box after the setState build reset
    _textFieldController.selection = TextSelection.fromPosition(TextPosition(
        offset: _textFieldController.text.length));
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
                  TextFormField(
                    controller: _textFieldController,
                    decoration: InputDecoration(
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      filled: true,
                      fillColor: Colors.white,
                      labelText: 'Search Your Friends',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.clear),
                        onPressed: () { setState(() {
                          _textFieldController.clear();
                        });},
                      ),
                    ),
                    onChanged: (input) {
                      setState(() {
                        _textFieldController.text = input;
                      });
                    },
                  ),
                  Expanded(
                      child: FriendList(showAll: false, searchQuery: _textFieldController.text,)
                  ),
                ],
              ),
            ),
            /*floatingActionButton: FloatingActionButton(
              onPressed: () {showDialog(context: context, builder: (_) => OverlayPopup(contents: FriendList(showAll: true)));},
              tooltip: 'Add Friend',
              child: const Icon(Icons.person_add),
            ),*/
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