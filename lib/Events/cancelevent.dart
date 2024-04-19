import 'package:cyclista/Events/event_screen.dart';
import 'package:cyclista/Events/map_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import '../sample.dart';
import '../flutter_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addevent_screen.dart';
import 'viewevent_screen.dart';
import '../flutter_session.dart';
import 'weather_screen.dart';
import 'dart:async';
class CanceleventFormWidget extends StatefulWidget{
  @override
  CanceleventFormWidgetState createState(){
    return CanceleventFormWidgetState();
  }
}

class CanceleventFormWidgetState extends State<CanceleventFormWidget>{
  List<dynamic> list ;
  dynamic did;
  var session = FlutterSession();
  var speedInMps;
  Future speed;
  void initState() {

    super.initState();
    Timer.periodic(Duration(seconds: 3), (Timer t) => _speed());
    _speed();
    _events();

  }
  Future<dynamic> _refresh(){
    if(mounted){
      setState(() {
        speed = _speed() ;
      });
    }
  }
  Future<dynamic> _deleteevent(String eventID) async{


    await FirebaseFirestore.instance
        .collection('Events')
        .doc(eventID)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
  }
  Future<dynamic> _speed() async{

    var geo = Geolocator.getPositionStream(
        forceAndroidLocationManager: true,
        intervalDuration: Duration(seconds:1),
        desiredAccuracy: LocationAccuracy.high)
        .listen((Position position) {
      setState((){
        speedInMps =
            position.speed.toString();
      });
      print(speedInMps);
      // this is your speed
    }).onError((e) {
      print(e);
    });

  }
  Future<dynamic> _events() async{
    did =  await FlutterSession().get('id');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Events')
        .where('userID', isEqualTo:did)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        query =  querySnapshot.docs.map((doc) =>doc.data()).toList();

      }

    });
    return query;
  }
  @override
  Widget build(BuildContext context){
    return

      Center(
          child: FutureBuilder<dynamic>(
              future: _events(),
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var list;
                if(snapshot.hasData){
                  list = Flexible(

                    child: ListView.builder(
                        itemCount:   snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:

                            Container(

                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                color:  Colors.white,
                                elevation: 3,
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,

                                  children: [
                                    Container(
                                      width: 350,
                                      margin: EdgeInsets.only(bottom:30),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child:

                                      ListTile(

                                        title:
                                        Column(
                                            children: <Widget>
                                            [
                                              Container(
                                                width:350,
                                                child:
                                                Row(
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                    children: <Widget>
                                                    [
                                                      Padding(
                                                        padding: EdgeInsets.only(bottom:10,top:10,right: 10,left:10),
                                                        child:   Container(
                                                          width: 50,
                                                          height: 50,
                                                          decoration: BoxDecoration(
                                                            shape: BoxShape.circle,
                                                            image: DecorationImage(
                                                                image: NetworkImage(snapshot.data[index]['profile'].toString()),
                                                                fit: BoxFit.fill
                                                            ),
                                                          ),
                                                        ),
                                                      ),

                                                      Padding(
                                                        padding: EdgeInsets.only(bottom:10,top:10),
                                                        child:Text(
                                                          snapshot.data[index]['name'],
                                                          textAlign: TextAlign.left,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                    ]
                                                ),

                                              ),


                                              Image.network(snapshot.data[index]['url'].toString(),fit: BoxFit.fitWidth,),
                                              Container(
                                                width:350,
                                                child: Column(
                                                    crossAxisAlignment: CrossAxisAlignment.start,
                                                    mainAxisAlignment: MainAxisAlignment.start,
                                                    children:[
                                                      Padding(
                                                          padding: EdgeInsets.only(bottom:10,top:10),
                                                          child:

                                                          Text(
                                                            snapshot.data[index]['details'],
                                                            textAlign: TextAlign.left,

                                                            overflow: TextOverflow.ellipsis,
                                                            style: const TextStyle(fontWeight: FontWeight.bold),
                                                          )


                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),

                                                        child: ElevatedButton(onPressed: (){
                                                          _deleteevent(snapshot.data[index]['eventID']);

                                                        }
                                                          , child: Text("Cancel")
                                                          ,style:ElevatedButton.styleFrom(primary: Colors.red),
                                                        ),

                                                      ),
                                                    ]
                                                ),)

                                            ]),


                                      ),),
                                  ],
                                ),
                              ),
                            ),
                          );
                          //${accounts[index].first_name}
                        }),
                  );
                }
                else {
                  list =  Padding(

                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color:  Colors.white,
                        elevation: 3,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              SizedBox(
                                child: CircularProgressIndicator(),
                                width: 60,
                                height: 40,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('No data...'),
                              ),]
                        ),
                      ),
                    ),
                  );



                }
                return Container(
                    margin: EdgeInsets.only(top:50),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[


                          list,



                        ]

                    )

                );
              }

          )



      )
    ;
  }
}