import 'package:distraction_destruction/screens/auth/auth.dart';
import 'package:distraction_destruction/screens/pages/friends.dart';
import 'package:distraction_destruction/screens/pages/sessions.dart';
import 'package:flutter/material.dart';
import 'dart:developer' as dev;

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    dev.log("Create Home", name: "screens.home.home");
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

class _MyHomePageState extends State<MyHomePage> {
  int _selectedIndex = 0;

  //Everything in the BottomNavigationBar should go here
  //If we have 3 items in the navbar, this list should have 3 widget elements
  static const List<Widget> _pages = <Widget>[
    //TODO Change the pages that are linked here
    Sessions(),
    Friends(),
    Friends(),
  ];

  void _onItemTapped(int index) {
    //setState() should be called EVERY TIME something that could impact the UI
    //is changed
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // rerunning build methods is extremely fast
    // just rebuild anything that needs updating rather than
    // individually changing instances of widgets.
    return Scaffold(
      backgroundColor: Colors.lightBlue[100],
      appBar: AppBar(
        //Since this was called by _MyHomePageState, which was created
        // in MyHomePage, we can access all of the states variables through
        // widget.#{}
        title: Text(widget.title),
        backgroundColor: Colors.lightBlueAccent[400],
        elevation: 0.0,
        //Logout, Profile or Settings button
        //TODO Implement functionality, this should either logout or take the user somewhere
        actions: <Widget>[
          IconButton(onPressed: () {},
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const<BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.schedule),
            label: 'Sessions',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Friends',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
