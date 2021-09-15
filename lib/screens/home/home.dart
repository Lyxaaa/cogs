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
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // tells Flutter framework that something has changed in this State,
      // which causes it to rerun the build method below
      _counter++;
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
        actions: <Widget>[
          IconButton(onPressed: () {},
              icon: Icon(Icons.logout)),
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
