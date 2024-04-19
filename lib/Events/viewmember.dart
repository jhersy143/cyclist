import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'viewmember_screen.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ViewMemberWidget extends StatefulWidget{
  @override
  ViewMemberWidgetState createState(){
    return ViewMemberWidgetState();
  }
}

class ViewMemberWidgetState extends State<ViewMemberWidget>{

  dynamic did,eid;
  var goal;
  var type;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  TextEditingController textController = TextEditingController();
  @override


  Future<dynamic> _eventMember() async{

    eid =  await FlutterSession().get('eid');
    List<dynamic> querymembers=[];
    await FirebaseFirestore.instance
        .collection('EventsMembers')
        .where('eventID',isEqualTo: eid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querymembers =  querySnapshot.docs.map((doc) =>doc.data()).toList();
        print(querymembers);
      }

    });

    return querymembers;

  }

  Widget build(BuildContext context){
    return
      Center(
          child:  FutureBuilder<dynamic>(
              future: _eventMember(),
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var list;
                var url;
                if(snapshot.hasData){


                  list =
                      Flexible(

                        child: ListView.builder(
                            itemCount:   snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){
                              if(snapshot.data[index]['profile'].toString()==""){
                                url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
                              }
                              else{
                                url  = snapshot.data[index]['profile'];
                              }
                              return Padding(
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

                                        ListTile(
                                          leading:   Padding(
                                            padding: EdgeInsets.only(bottom:10,top:10,right: 10,left:10),
                                            child:   Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage(url),
                                                    fit: BoxFit.fill
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(snapshot.data[index]['name']),



                                        )
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
                                child: Text('Awaiting result...'),
                              ),]
                        ),
                      ),
                    ),
                  );



                }

                return   Container(
                    margin: EdgeInsets.only(top:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Members Joined",
                                style:TextStyle(fontSize: 20),
                              )
                              ,
                            ),



                          ],
                        ),


                        list ],)
                );
              }
          )


      );

  }
}