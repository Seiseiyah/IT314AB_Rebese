import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Social',

      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121317),
        fontFamily: 'Arial',
      ),

      home: const SocialPage(),
    );
  }
}

class Friend {
  String name;
  String status;
  String device;
  String section;
  bool isPlaying;
  bool isOnline;

  Friend({
    required this.name,
    required this.status,
    required this.device,
    required this.section,
    required this.isOnline,
    required this.isPlaying,
});
}




class SocialPage extends StatelessWidget {
  const SocialPage({super.key});

  @override
  Widget build(BuildContext context)
{

Friend friend1 = Friend(
     name: "MissYouLikeKrazy",
   status: "Online - Valorant",
   device: "computer",
   section: "VALORANT",
   isPlaying: false,
   isOnline: true,
 );

Friend friend2 = Friend(
  name: "bread",
  status: "Playing - Valorant",
  device: "computer",
  section: "Valorant",
  isPlaying: true,
  isOnline: true,
);

Friend friend3 = Friend(
  name: "The14th",
  status: "Playing - Valorant",
  device: "computer",
  section: "Valorant",
  isPlaying: true,
  isOnline: true,
);

Friend friend4 = Friend(
  name: "Calvenldish",
  status: "Away - Riot Mobile",
  device: "phone",
  section: "Online",
  isPlaying: false,
  isOnline: false,
);

Friend friend5 = Friend(
  name: "D1yah",
  status: "Away - Riot Mobile",
  device: "phone",
  section: "Online",
  isPlaying: false,
  isOnline: false,
);

//FRIEND LIST

  List<Friend> friends = [
    friend1,
    friend2,
    friend3,
    friend4,
    friend5,
  ];

  //SECTION

  List<Friend> valorantFriends = friends
  .where((friend) => friend.section == "VALORANT")
  .toList();

  List<Friend> onlineFriends = friends
      .where((friend) => friend.section == "Online")
      .toList();

  //UI

  return Scaffold(
    body: SafeArea(child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [

        const Padding(padding: EdgeInsets.only(
          left: 30,
          top: 10,
          bottom: 10,
        ),
        child: Text(
          "Social",

          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        ),
      ],
    ))
  );
}
}




class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          //
          // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
          // action in the IDE, or press "p" in the console), to see the
          // wireframe for each widget.
          mainAxisAlignment: .center,
          children: [
            const Text('You have pushed the button this many times:'),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
