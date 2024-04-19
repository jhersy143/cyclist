import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';

import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'dart:math' show cos, sqrt, asin;
import 'package:cloud_firestore/cloud_firestore.dart';
import '../flutter_session.dart';
class HelpMapFormWidget extends StatefulWidget{
  @override
  HelpMapFormWidgetState createState(){
    return HelpMapFormWidgetState();
  }
}

class HelpMapFormWidgetState extends State<HelpMapFormWidget>{
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;
  Position _currentPosition;
  String _currentAddress = '';
  var session = FlutterSession();
  var emergencyID;
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
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  Widget _textField({
    TextEditingController controller,
    FocusNode focusNode,
    String label,
    String hint,
    double width,
    Icon prefixIcon,
    Widget suffixIcon,
    Function(String) locationCallback,
  }) {
    return Container(
      width: width * 0.8,
      child: TextField(
        onChanged: (value) {
          locationCallback(value);
        },
        controller: controller,
        focusNode: focusNode,
        decoration: new InputDecoration(
          prefixIcon: prefixIcon,
          suffixIcon: suffixIcon,
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.grey.shade400,
              width: 2,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(10.0),
            ),
            borderSide: BorderSide(
              color: Colors.blue.shade300,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.all(15),
          hintText: hint,
        ),
      ),
    );
  }

  // Method for retrieving the current location
  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        print('currentloc');
        _currentPosition = position;
        //print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _emergency();

    }).catchError((e) {
      print(e);
    });
   // print('CURRENT POS: $_currentPosition');

  }

  // Method for retrieving the address


  // Method for calculating the distance between two places


  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277


  // Create the polylines for showing the route between two places
  _createPolylines(
      double startLatitude,
      double startLongitude,
      double destinationLatitude,
      double destinationLongitude,
      ) async {
    polylinePoints = PolylinePoints();
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      "AIzaSyAkvPCKZl44OIqpWkfdRZKBKo1RUPE1P1M", // Google Maps API Key
      PointLatLng(startLatitude, startLongitude),
      PointLatLng(destinationLatitude, destinationLongitude),
      travelMode: TravelMode.driving,
    );

    if (result.points.isNotEmpty) {

      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }
    else{

      print(result.errorMessage);
    }

    PolylineId id = PolylineId('poly');
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );
    polylines[id] = polyline;

  return result;

  }

  @override
  void initState() {

    super.initState();
    //_determinePosition();
    //_getCurrentLocation();
    //Timer.periodic(Duration(seconds: 3), (Timer t) => _getCurrentLocation());
    Timer(Duration(seconds: 3),()=>_getCurrentLocation());
    //Timer(Duration(seconds: 6),()=>_emergency());
  }
 _emergency() async{
   emergencyID =  await FlutterSession().get('emergencyID');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Emergency')
        .where('emergencyID',isEqualTo: emergencyID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {

        print('no data');
      }
      else
      {

        querySnapshot.docs.forEach((doc) {
          _createPolylines(_currentPosition.latitude,
              _currentPosition.longitude, doc['latitude'],doc['longitude']);
          String startCoordinatesString = '($_currentPosition.latitude, $_currentPosition.latitude)';
          var locationlatitude = doc['latitude'];
          var locationlongitude = doc['longitude'];
          var usersname = doc['usersname'];
          String destinationCoordinatesString =
              '($locationlatitude, $locationlongitude)';
          Marker startMarker = Marker(
            markerId: MarkerId(startCoordinatesString),
            position: LatLng(_currentPosition.latitude, _currentPosition.longitude),
            infoWindow: InfoWindow(
              title: 'Start $startCoordinatesString',
              snippet: _startAddress,
            ),
            icon: BitmapDescriptor.defaultMarker,
          );
          Marker destinationMarker = Marker(
            markerId: MarkerId(destinationCoordinatesString),
            position: LatLng(locationlatitude, locationlongitude),
            infoWindow: InfoWindow(
              title: usersname,
              snippet: _startAddress,
            ),
            icon: BitmapDescriptor.defaultMarker,
          );
          markers.add(startMarker);
          markers.add(destinationMarker);
          print(_currentPosition.latitude);
          print(_currentPosition.longitude);
        });


      }

    });
    print('emergency');

    return query;
  }

  @override
  void dispose() {
    mapController.dispose();
    Geolocator.getPositionStream().listen((event) { }).cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;



    return Container(

      width: width,
      child: Scaffold(
        key: _scaffoldKey,
        body: Stack(
          children: <Widget>[
            // Map View
            GoogleMap(
              markers: Set<Marker>.from(markers),
              initialCameraPosition: _initialLocation,
              myLocationEnabled: true,
              myLocationButtonEnabled: false,
              mapType: MapType.normal,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: false,
              polylines: Set<Polyline>.of(polylines.values),
              onMapCreated: (GoogleMapController controller) {
                mapController = controller;
                _getCurrentLocation();


              },
            ),
            // Show zoom buttons
            SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[

                    SizedBox(height: 20),
                    ClipOval(
                      child: Material(
                        color: Colors.blue.shade100, // button color
                        child: InkWell(
                          splashColor: Colors.blue, // inkwell color
                          child: SizedBox(
                            width: 50,
                            height: 50,
                            child: Icon(Icons.remove),
                          ),
                          onTap: () {
                            mapController.animateCamera(
                              CameraUpdate.zoomOut(),
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            // Show the place input fields & button for
            // showing the route

            // Show current location button

          ],
        ),
      ),
    );
  }
}