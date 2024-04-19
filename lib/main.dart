import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'home.dart';
import 'Users/login_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'Emergency/neededforhelp_screen.dart';
const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

      ),  home: MyHomeWidget()

    );
  }
}
class MyHomeWidget extends StatefulWidget{

  @override
  MyHomeWidgetState createState(){
    return MyHomeWidgetState();
  }
}

class MyHomeWidgetState extends State<MyHomeWidget>{

  void initState() {
    super.initState();

    var initSetttings = InitializationSettings(
        );

    //flutterLocalNotificationsPlugin.initialize(initSetttings,
       // onSelectNotification: onSelectNotification);
  }
  Future onSelectNotification(String payload) {
    Navigator.push(context,
      MaterialPageRoute(builder: (context)=>neededforhelpScreen()),
    );
  }

  @override
  Widget build(BuildContext context){
    return Scaffold(

        body: Center(
          child: Container(

              constraints: BoxConstraints.expand(),
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage(
                          "assets/homeimage.png"),
                      fit:BoxFit.cover
                  )
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
             // for(var i = 0; i <3;i++)
              Container(
              margin: EdgeInsets.only(bottom:100),
              child: ConstrainedBox(
                      constraints: BoxConstraints.tightFor(width: 300, height: 80),

                      child:

                      Padding(

                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(

                            style:ElevatedButton.styleFrom(
                              side: BorderSide(width: 5.0, color: Color.fromRGBO(0, 160, 227, 1)),
                              primary: Color.fromRGBO(33,33,33,1),

                            ),
                            onPressed: (){
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(builder: (context) => LoginScreen(),
                                  ));
                            },

                            child: Text("Get Started")

                        ),

                      ),
                    ),
              )

                  ]

              )

          ),
        ),
    );

  }
}