import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:distraction_destruction/screens/auth/auth.dart';
import 'package:distraction_destruction/screens/builders/friend_list.dart';
import 'package:distraction_destruction/screens/builders/overlay_popup.dart';
import 'package:distraction_destruction/screens/pages/friends.dart';
import 'package:distraction_destruction/screens/pages/sessions.dart';
import 'package:distraction_destruction/screens/pages/stats.dart';
import 'package:distraction_destruction/services/auth_svc.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:distraction_destruction/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:developer' as dev;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dev.log("Create Home", name: "screens.main_scaffold.main_scaffold");
    return Container(
      child: MyHomePage(title: "Distraction Destruction"),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  // config for the state
  // holds the values (title below) provided by parent (App widget above)
  // used by build method of the State
  // Fields in a Widget subclass are always marked "final"

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with AutomaticKeepAliveClientMixin {
  final AuthService _auth = AuthService();
  final DatabaseService database = DatabaseService();

  int _selectedIndex = 0;

  //Everything in the BottomNavigationBar should go here
  //If we have 3 items in the navbar, this list should have 3 widget elements
  static final List<Widget> _pages = <Widget>[
    //TODO Change the pages that are linked here
    Friends(),
    Sessions(),
    Stats(),
  ];

  PageController _controller = PageController(
    initialPage: 0,
  );
  
  void _onItemTapped(int index) {
    //setState() should be called EVERY TIME something that could impact the UI
    //is changed
    setState(() {
      _controller.jumpToPage(index);
      _selectedIndex = index;
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    //DatabaseService().userPreferences.map((querySnapshot) => querySnapshot.docs.map((doc) => Task))
    // rerunning build methods is extremely fast
    // just rebuild anything that needs updating rather than
    // individually changing instances of widgets.
    return StreamProvider<DocumentSnapshot?>.value(
      //TODO set loading screen here to prevent error screen from momentarily showing
      value: database.userDetailsStream,
      initialData: null,
      child: Scaffold(
        backgroundColor: Colors.lightBlue[100],
        appBar: AppBar(
          //Since this was called by _MyHomePageState, which was created
          // in MyHomePage, we can access all of the states variables through
          // widget.#{}
          title: Text(/*DatabaseService().userInfo.get().toString() + */
              (!_controller.hasClients
                      ? _pages[0]
                      : _pages[(_controller.page ?? _controller.initialPage)
                          .round()])
                  .toString()),
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          //Logout, Profile or Settings button
          //TODO Implement functionality, this should either logout or take the user somewhere
          actions: <Widget>[
            IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.account_circle),
              color: Colors.black87,
            ),
            IconButton(
              onPressed: () async {
                await _auth.signOut();
              },
              icon: Icon(Icons.person_search),
              color: Colors.black87,
            ),
            const Expanded(child: SizedBox()),
            IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (_) =>
                        OverlayPopup(contents: FriendList(showAll: true)));
              },
              icon: Icon(Icons.person_add),
              color: Colors.black87,
            ),
          ],
        ),
        body: Center(
            child: PageView(
          controller: _controller,
          children: _pages,
          onPageChanged: _onItemTapped,
        )
            // child: _pages.elementAt(_selectedIndex),
            ),
        bottomNavigationBar: Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only( topRight: Radius.circular(30), topLeft: Radius.circular(30))
          ),
        child: Material(
          elevation: 0.0,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30.0)),
          child: BottomNavigationBar(
            showSelectedLabels: false,
            showUnselectedLabels: false,
            iconSize: 24,
            elevation: 0,
            backgroundColor: Colors.transparent,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.people, semanticLabel: "Friends Page"),
                label: 'Friends',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.alarm_on, semanticLabel: "Start Session"),
                label: 'Sessions',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.bar_chart, semanticLabel: "Statistics Page"),
                label: 'Stats',
              ),
            ],
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
          ),
        // This trailing comma makes auto-formatting nicer for build methods.
        ))
      ),
    );
  }

  @override
  // TODO: implement wantKeepAlive
  bool get wantKeepAlive => true;
}
