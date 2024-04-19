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

  dynamic did,gid;
  var goal;
  var type;
  Widget membersWidget;
  var url;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  TextEditingController textController = TextEditingController();

  Future<dynamic> futureMembers(userID) async{

    var groupmembers;
    await FirebaseFirestore.instance
        .collection('Users')
        .where('userID',isEqualTo: userID)
        .get()

        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

          groupmembers =  querySnapshot.docs.map((doc) =>doc.data()).toList();


      }

    });
    return groupmembers;
}
 Widget members(userID) {
   return FutureBuilder<dynamic>(
       future: futureMembers(userID),
      builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {

        print(snapshot.hasData);
   if(snapshot.hasData){

     if(snapshot.data[0]['url'].toString()==""){
       url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
     }
     else{
       url  = snapshot.data[0]['url'];
     }
   membersWidget =   Padding(
     padding: const EdgeInsets.all(8.0),
     child: Container(
       height: 80,
       child: Card(
           shape: RoundedRectangleBorder(
             borderRadius: BorderRadius.circular(8.0),
           ),
           color: Colors.white,
           elevation: 3,
           child: Column(
             mainAxisSize: MainAxisSize.min,

             children: [

               ListTile(
                 leading: Padding(
                   padding: EdgeInsets.only(
                       bottom: 10, top: 10, right: 10, left: 10),
                   child: Container(
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
                 title: Text(snapshot.data[0]['firstname']+" "+snapshot.data[0]['middlename']+" "+snapshot.data[0]['lastname']),


               ),
             ],
           ),
       ),
     ),
   );
     //${accounts[index].first_name}
   }
   else{
     return Text('');
   }

   return membersWidget;

   }
   );

  }
  Future<dynamic> _eventMember() async{

    gid =  await FlutterSession().get('gid');
    List<dynamic> querymembers=[];
    await FirebaseFirestore.instance
        .collection('GroupMembers')
        .where('groupID',isEqualTo: gid)
        .get()

        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querymembers =  querySnapshot.docs.map((doc) =>doc.data()).toList();

      }

    });

    return querymembers;

  }
  @override
  Widget build(BuildContext context){
    return
      Center(
          child:  FutureBuilder<dynamic>(
              future: _eventMember(),
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var list;

                if(snapshot.hasData){


                  list =
                      Flexible(

                        child: ListView.builder(
                            itemCount:   snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){


                                return members(snapshot.data[index]['userID']);
                                }
                                ),
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
                              child: ElevatedButton(onPressed: (){
                                Navigator.pop(context);
                              }
                                   , child: Text("Back")),
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