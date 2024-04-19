import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';

import 'addgroup_screen.dart';

import '../flutter_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'joinedgroup_screen.dart';
import 'groupdetails_screen.dart';
import 'viewmember_screen.dart';
import '../feeds/feed_screen.dart';
import 'routes_screen.dart';
import 'package:cyclista/Emergency/emergency_screen.dart';
class groupMenuFormWidget extends StatefulWidget{
  @override
  groupMenuFormWidgetState createState(){
    return groupMenuFormWidgetState();
  }
}

class groupMenuFormWidgetState extends State<groupMenuFormWidget>{

  dynamic did;
  var goal;
  var type;
  var group;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  TextEditingController textController = TextEditingController();
  @override

  void initState(){
    super.initState();
    _group();
  }
  Future<dynamic> _group() async{

    group =  await FlutterSession().get('groupname');

    return group;
  }
  Widget build(BuildContext context){
    return
      Center(
          child:  FutureBuilder<dynamic>(
              future: _group(),
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var grouptext;
                if(snapshot.hasData){
                  grouptext = Text(snapshot.data,style: TextStyle(fontSize: 20,fontWeight:FontWeight.bold),);
                }

                else {
                  grouptext = Text('');
                }

                return   Container(
                    margin: EdgeInsets.only(top:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Center(child:
                        Container(
                          width: 200,
                          height: 100,
                          child:
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: grouptext,
                          ),
                        ),
                        ),

                          Container(
                            width: 200,
                            height: 100,
                            child:
                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ElevatedButton(onPressed: (){

                              Navigator.push(
                                context,
                                MaterialPageRoute(

                                  builder: (context) => ViewMemberScreen(),
                                ),
                              ).then(
                                      (value) { setState(() {});});

                            }
                                , child: Text("Members")),
                          ),
                            ),
                    Container(
                      width: 200,
                      height: 100,
                      child:
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(onPressed: (){
                                setState(() {
                                  session.set('feedtype', 'groupfeeds');
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => feedScreen(),
                                  ),
                                );

                              }
                                  , child: Text("Feeds")),
                            ),
                    ),
                            Container(
                          width: 200,
                          height: 100,
                          child:

                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: ElevatedButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupRoutesScreen(),
                                  ),
                                ).then(
                                        (value) { setState(() {});});

                              }
                                  , child: Text("Routes")),
                            ),

                    )
                        ,Container(
                          width: 200,
                          height: 100,
                          child:

                          Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: ElevatedButton(onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmergencyScreen(),
                                ),
                              ).then(
                                      (value) { setState(() {});});

                            }
                                , child: Text("Send Help")),
                          ),

                        )

                        ],)
                );
              }
          )


      );

  }
}