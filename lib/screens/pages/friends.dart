import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distraction_destruction/screens/builders/friend_code.dart';
import 'package:distraction_destruction/screens/builders/friend_list.dart';
import 'package:distraction_destruction/screens/global/load.dart';
import 'package:distraction_destruction/screens/pages/active_session.dart';
import 'package:distraction_destruction/services/database.dart';
import 'package:distraction_destruction/templates/user.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

//Display auth info, allowing users to login, register or await auto login
class Friends extends StatefulWidget {
  final bool add;
  const Friends({Key? key, this.add=false}) : super(key: key);

  @override
  String toString({DiagnosticLevel minLevel = DiagnosticLevel.info}) {
    // TODO: implement toString
    return "Your Friends";
  }

  @override
  _FriendList createState() => _FriendList();
}

class _FriendList extends State<Friends> with AutomaticKeepAliveClientMixin {
  bool _add = false;
  final DatabaseService database = DatabaseService();
  final _textFieldController = TextEditingController();

  @override
  void dispose() {
    _textFieldController.dispose();
    super.dispose();
  }

  String search = '';

  void setSearch(String search) {
    setState(() {
      this.search = search;
    });
  }

  Row filterFriends(String text) {
    return Row(
      children: <Widget>[
        Expanded(child:
        TextFormField(
          controller: _textFieldController,
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.search),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15)
            ),
            filled: true,
            // fillColor: Colors.white,
            labelText: text,
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
          flex: 5,
        )
      ],
    );
  }


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<AppUser?>(context);
    String name = '';

    super.build(context);
    //Puts the cursor at the end of the search box after the setState build reset
    _textFieldController.selection = TextSelection.fromPosition(TextPosition(
        offset: _textFieldController.text.length));
    return StreamBuilder<DocumentSnapshot?>(
      //TODO set loading screen here to prevent error screen from momentarily showing
      stream: database.userDetailsStream,
      initialData: null,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Load();
        } else {
          var info = snapshot.data!.data() as Map<String, dynamic>;
          name = info['name'];
          //setSessionState(info['session_active']);
          if (info['session_active']) {
            return ActiveSession();
          } else {
            return Scaffold(
              // backgroundColor: widget.add ? Colors.transparent : Theme.of(context).colorScheme.background,
              body: Container(
                padding: EdgeInsets.symmetric(
                    horizontal:widget.add ? 0 : 30,
                    vertical: widget.add ? 0 : 20),
                // Center is a layout widget. It takes a single child and positions it
                // in the middle of the parent.
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                      //// QRCODE Scanner
                      Visibility(visible:widget.add,
                          child: IconButton(
                              // TODO: Break this function out.
                              onPressed: () async {

                                String code = await friendScan();
                                AppUser? user = await DatabaseService().getAppUser(code);
                                bool added = await DatabaseService().safelyAddFriend(code);

                                final snackBar;
                                if (added) {
                                  snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text("Now friends with ${user!.name ?? 'an unknown individual'}."),
                                    action: SnackBarAction(
                                      label: 'Undo',
                                      onPressed: () {}, // TODO: Implement friendship with <x> ended.
                                    ),
                                  );
                                } else {
                                  snackBar = SnackBar(
                                    behavior: SnackBarBehavior.floating,
                                    content: Text("Not a valid user."),
                                    action: SnackBarAction(
                                      label: 'Try Again', // TODO: Implement restart this scan.
                                      onPressed: () {},
                                    ),
                                  );
                                }

                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar);
                              },
                              icon: Icon(Icons.camera)
                          )),
                      ///// QR Generator
                      Visibility(visible:widget.add,
                          child: IconButton(
                              onPressed: () {
                                AppUser? user = Provider.of<AppUser?>(context, listen: false);
                                if ( user != null) {
                                  showDialog(
                                      context: context,
                                      builder: (_) => SimpleDialog(
                                        // title: Text(user.name ?? 'Nameless One'),
                                        children:[FriendCode(
                                            user)],
                                      ));
                                }},
                              icon: Icon(Icons.qr_code))),
                    ],),
                    filterFriends(widget.add ? 'Add Friend' : 'Filter Friends'),
                    SizedBox(height: 20.0,),
                    Expanded(
                      flex: 5,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 7.5,
                            vertical: 20),
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(15),
                            color: Theme.of(context).backgroundColor,
                        ),
                        child: FriendList(add: widget.add,
                          searchQuery: _textFieldController.text,),
                      ),
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
          }
        }
      },
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}