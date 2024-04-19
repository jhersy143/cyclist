import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addgroup_screen.dart';

import '../flutter_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'joinedgroup_screen.dart';
import 'groupdetails_screen.dart';
import 'groupmenu_screen.dart';
class MygroupsFormWidget extends StatefulWidget{
  @override
  MygroupsFormWidgetState createState(){
    return MygroupsFormWidgetState();
  }
}

class MygroupsFormWidgetState extends State<MygroupsFormWidget>{

  dynamic did;
  var goal;
  var type;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  TextEditingController textController = TextEditingController();
  @override
  Future<dynamic> _groups() async{
    did =  await FlutterSession().get('id');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Groups')
        .where('userID',isEqualTo: did)
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
  Future<dynamic> _groupID(groupID) async{

    session.set("groupid", groupID);


  }
  Widget build(BuildContext context){
    return
      Center(
          child:  FutureBuilder<dynamic>(
              future: _groups(),
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var list;
                if(snapshot.hasData){


                  list =
                      Flexible(

                        child: ListView.builder(
                            itemCount:   snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){
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
                                          leading: Icon(Icons.group, size: 40,),
                                          title: Text(snapshot.data[index]['group']),
                                          subtitle: Text(snapshot.data[index]['details']),

                                          onTap: () {
                                            _groupID(snapshot.data[index]['groupID']);
                                              setState(() {
                                                session.set("gid", snapshot.data[index]['groupID']);
                                                session.set("groupname", snapshot.data[index]['group']);
                                              });

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => groupMenuScreen(),
                                              ),
                                            ).then(
                                                    (value) { setState(() {});});
                                          },
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

                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: ElevatedButton(onPressed: (){
                            //     Navigator.pop(context);
                            //   }
                            //       , child: Text("Back")),
                            // ),


                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: ElevatedButton(onPressed: (){


                              }
                                  , child: Text("Your Group")),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: ElevatedButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => GroupJoinedScreen(),
                                  ),
                                );

                              }
                                  , child: Text("Other Group")),
                            ),
                            // Padding(
                            //   padding: const EdgeInsets.all(8.0),
                            //   child: ElevatedButton(onPressed: (){
                            //     Navigator.pop(context);
                            //   }
                            //       , child: Text("Back")),
                            // ),



                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Text("Your Group",
                                style:TextStyle(fontSize: 20),
                              )
                              ,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: ElevatedButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => addgroupScreen(),
                                  ),
                                ).then(
                                        (value) { setState(() {});});

                              }
                                  , child: Text("Create Group")),
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