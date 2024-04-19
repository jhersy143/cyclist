
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'neededforhelp_screen.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
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
class EmergencyWidget extends StatefulWidget{
  @override
  EmergencyWidgetState createState(){
    return EmergencyWidgetState();
  }
}

class EmergencyWidgetState extends State<EmergencyWidget>{

  var did;
  var name;
  var profileurl;
  Future notif;
  Timer timer;
  int counter = 0;
  Future update;
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  Position _currentPosition;
  String _currentAddress = '';

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  Set<Marker> markers = {};
  var speedInMps;
  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];
  var geolocator = Geolocator();
  void initState() {
    super.initState();

    notif = _emergency();
    timer = Timer.periodic(Duration(seconds: 2), (Timer t) => _refresh());
    Timer.periodic(Duration(seconds: 4), (Timer t) => _refreshUpdate());
    _determinePosition();
    _getCurrentLocation();
  }
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {


      setState(() async{
        _currentPosition = position;
        List<Placemark> p = await placemarkFromCoordinates(
            _currentPosition.latitude, _currentPosition.longitude);

        Placemark place = p[0];
        _currentAddress =
        "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });

    }).catchError((e) {
      print(e);
    });
    print('CURRENT POS: $_currentPosition');
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }
  Future<dynamic> _emergency() async{
    //did =  await FlutterSession().get('id');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Emergency')
        .where('status',isEqualTo: 'pending')
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {
        querySnapshot.docs.forEach((doc) {
          showNotification(doc['dateCreated'],doc['currentLocation']);
        });

        query =  querySnapshot.docs.map((doc) =>doc.data()).toList();
        print(query);
      }

    });
    return query;
  }
  Future<dynamic> _refresh() async{
    if(mounted){
      setState(() {
        notif = _emergency();
      });
    }


  }
  Future<dynamic> _refreshUpdate()async{
    if(mounted){
      setState(() {
        update = updateemergency();
      });
    }
}
  Future<dynamic> addemergency() async {
    did =  await FlutterSession().get('id');
    var doc =  FirebaseFirestore.instance.collection('Emergency').doc(did);
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mma').format(now);

    name = await FlutterSession().get('name');
    profileurl = await FlutterSession().get('profileurl');
    await FirebaseFirestore.instance
        .collection('Emergency')
        .doc(doc.id)
        .set({'profileurl': profileurl,
      'usersname':name,
      'userID':did,
      'status':'pending',
      'latitude':_currentPosition.latitude,
      'longitude':_currentPosition.longitude,
      'emergencyID':doc.id,
      'dateCreated':formattedDate,
      'currentLocation':_currentAddress

    })
        .then((value) => print(""))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future<dynamic> updateemergency() async {
    did =  await FlutterSession().get('id');
    name = await FlutterSession().get('name');
    name = await FlutterSession().get('name');
    await FirebaseFirestore.instance
        .collection('Emergency')
        .doc(did)
        .update({
      'status':'stop',

    })
        .then((value) => print(""))
        .catchError((error) => print("Failed to update user: $error"));
  }
  void showNotification(String formattedDate,String currentAddress) async{

    flutterLocalNotificationsPlugin.show(
        0,
        "EMERGENCY\n"+""+formattedDate,
        currentAddress,
        NotificationDetails(
            android: AndroidNotificationDetails(channel.id, channel.name, channel.description,
                importance: Importance.high,
                color: Colors.blue,
                playSound: true,
                icon: '@mipmap/launcher_icon')));
  }


  @override
  Widget build(BuildContext context){
    return Center(

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 200, height: 60,
              margin: EdgeInsets.only(bottom:5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child:
              Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("EMERGENCY"
                    ,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),
                  )
              ),
            ),
            Container(
              width: 200, height: 60,
              margin: EdgeInsets.only(bottom:5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: addemergency
                    , child: Text("CALL FOR HELP")
                  ,style:ElevatedButton.styleFrom(primary: Colors.red),
                ),
              ),
            ),
            Container(
              width: 200, height: 60,
              margin: EdgeInsets.only(bottom:5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
              ),
              child:
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){
                  Navigator.push(context,
                    MaterialPageRoute(builder: (context)=>neededforhelpScreen()),
                  );
                }
                    , child: Text("WHO NEEDS HELP")
                    ,style:ElevatedButton.styleFrom(primary: Colors.red),

                ),
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(onPressed: (){
            //     Navigator.pop(context);
            //   }
            //       , child: Text("Back")),
            // )
          ],
        )
    );
  }
}