import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addgroup_screen.dart';

import '../flutter_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'joinedgroup_screen.dart';
import 'groupdetails_screen.dart';
import 'groupmap_screen.dart';
import 'viewroutes_screen.dart';
class GroupRoutesFormWidget extends StatefulWidget{
  @override
  GroupRoutesFormWidgetState createState(){
    return GroupRoutesFormWidgetState();
  }
}

class GroupRoutesFormWidgetState extends State<GroupRoutesFormWidget>{

  dynamic did;
  var goal;
  var type;
  var gid;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  TextEditingController textController = TextEditingController();
  @override
  Future<dynamic> _routes() async{
    gid =  await FlutterSession().get('gid');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Routes')
        .where('groupID',isEqualTo: gid)
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
              future: _routes(),
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
                                          title: Text(snapshot.data[index]['startDestination']+ " To "
                                              +snapshot.data[index]['endDestination']),
                                          subtitle: Text(snapshot.data[index]['distance']+" KM"),

                                          onTap: () {
                                            setState(() {
                                              session.set("routeID", snapshot.data[index]['routeID']);
                                            });

                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) => viewRoutesScreen(),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [

                            Padding(
                              padding: const EdgeInsets.all(6.0),
                              child: ElevatedButton(onPressed: (){
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => mapScreen(),
                                  ),
                                ).then(
                                        (value) { setState(() {});});

                              }
                                  , child: Text("Create Routes")),
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