import 'package:cyclista/Events/event_screen.dart';
import 'package:cyclista/Events/map_screen.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import '../sample.dart';
import '../flutter_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../flutter_session.dart';

import 'dart:async';
import 'activitiesmenu.dart';
class UserEventFormWidget extends StatefulWidget{
  @override
  UserEventFormWidgetState createState(){
    return UserEventFormWidgetState();
  }
}

class UserEventFormWidgetState extends State<UserEventFormWidget>{

  dynamic did;
  var session = FlutterSession();
  var speedInMps;
  Future speed;
  var list;
  void initState() {

    super.initState();


  }
  Future<dynamic> _eventsMembers() async{
    did =  await FlutterSession().get('id');
    List<dynamic> eventsmembers;
    await FirebaseFirestore.instance
        .collection('EventsMembers')
        .where('userID', isEqualTo:did)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        eventsmembers =  querySnapshot.docs.map((doc) =>doc.data()).toList();

      }

    });

    return eventsmembers;
  }
  Widget _listofEvents(String eventID){
     return FutureBuilder<dynamic>(
        future: _events(eventID),
        builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {

          print(snapshot.hasData);
          if(snapshot.hasData){
            list = Padding(
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
                                                          image: NetworkImage(snapshot.data[0]['profile'].toString()),
                                                          fit: BoxFit.fill
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(bottom:10,top:10),
                                                  child:Text(
                                                    snapshot.data[0]['name'],
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ]
                                          ),

                                        ),


                                        Image.network(snapshot.data[0]['url'].toString(),fit: BoxFit.fitWidth,),
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
                                                      snapshot.data[0]['details'],
                                                      textAlign: TextAlign.left,

                                                      overflow: TextOverflow.ellipsis,
                                                      style: const TextStyle(fontWeight: FontWeight.bold),
                                                    )


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
                          child: Text('Awaiting result...'),
                        ),]
                  ),
                ),
              ),
            );



          }
          return list;

        }

    );
  }
  Future<dynamic> _events(String eventID) async{

    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Events')
        .where('eventID', isEqualTo:eventID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        query = querySnapshot.docs.map((doc) => doc.data()).toList();

      }

    });

    return query;
  }
  @override
  Widget build(BuildContext context){
    return

      Center(
          child: FutureBuilder<dynamic>(
              future: _eventsMembers(),
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {

                print(snapshot.hasData);
                if(snapshot.hasData){
                  list = Flexible(

                    child: ListView.builder(
                        itemCount:   snapshot.data.length,
                        itemBuilder: (BuildContext context, int index){
                          return _listofEvents(snapshot.data[index]['eventID']);
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
                                child: Text('Awaiting result...'),
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


                          ActivityMenuFormWidget(),
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