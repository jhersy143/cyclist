import 'package:cyclista/Emergency/emergency_screen.dart';

import 'Groups/groups_screen.dart';
import 'package:flutter/material.dart';
import 'Users/login_screen.dart';
import 'Users/signup.dart';
import 'Users/signup_screen.dart';
import 'Feeds/feed.dart';


import 'customer_list_screen.dart';
import 'customer_list_screen.dart';
import 'Feeds/feed_screen.dart';
import 'Goals/goal_screen.dart';
import 'Events/event_screen.dart';
import 'Users/login.dart';
import 'home.dart';
import 'Events/map_screen.dart';
import 'Users/profile_screen.dart';
import 'Groups/joinedgroup_screen.dart';
import 'Follow/searchfriend_screen.dart';
import 'flutter_session.dart';
class MyHome extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Cyclista',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),

      home: MyHomePage(title: 'Cyclista'),


    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var session = FlutterSession();
  int _selectedIndex = 0;
  List<Widget> _pages = <Widget>[
   feedScreen(),
    ProfileScreen(),
    eventScreen(),
    goalScreen(),
    groupsScreen(),
    searchfriendScreen(),
  ];

  _onItemTapped (int index){
    setState(() {
      _selectedIndex = index;
      if(_selectedIndex==0){
        session.set('feedtype', 'publicfeeds');

      }


    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    session.set('feedtype', 'publicfeeds');
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
          // Here we take the value from the MyHomePage object that was created by
          // the App.build method, and use it to set our appbar title.
          title:
            Row(
                children:[

                Text(widget.title),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: (){

                      Navigator.push(context,
                          MaterialPageRoute(builder: (context)=>EmergencyScreen()));
                    }
                      , child: Text("EMERGENCY")
                      ,style:ElevatedButton.styleFrom(primary: Colors.red),
                    ),
                  ),
                ]
            ),
          leading:

              GestureDetector(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context)=>LoginScreen()));

                },
                child: Icon(
                  Icons.logout,  // add custom icons also
                ),
              ),



        ),
        bottomNavigationBar: BottomNavigationBar(
          unselectedItemColor: Colors.grey,
          selectedItemColor: Colors.blueAccent,
          //type: BottomNavigationBarType.fixed,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home),
                label: "Feed"),
            BottomNavigationBarItem(icon: Icon(Icons.person),
                label: "Profile"),
            BottomNavigationBarItem(icon: Icon(Icons.event),
                label: "Event"),
            BottomNavigationBarItem(icon: Icon(Icons.flag),
                label: "Goal"),
            BottomNavigationBarItem(icon: Icon(Icons.group),
                label: "Group"),
            BottomNavigationBarItem(icon: Icon(Icons.person_search_rounded),
                label: "Friends"),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
        ),
        body: Center(
          child: _pages.elementAt(_selectedIndex),
        )
    );
  }
}

// Column(
// crossAxisAlignment: CrossAxisAlignment.start,
// children: [
// Row(
// children: [
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: ElevatedButton(onPressed: (){
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => LoginScreen())
// );
// }, child: Text("Open Login Form")),
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: ElevatedButton(onPressed: (){
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => SignupScreen())
// );
// }, child: Text("Open Signup Form")),
// ),
// ],
// ),
// Padding(
// padding: const EdgeInsets.all(8.0),
// child: ElevatedButton(onPressed: (){
// Navigator.push(
// context,
// MaterialPageRoute(builder: (context) => AccountListScreen())
// );
// }, child: Text("Open Account List")),
// ),
// ],
// )