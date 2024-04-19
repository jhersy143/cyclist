import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'helpmap_screen.dart';
class neededforhelpWidget extends StatefulWidget{
  @override
  neededforhelpWidgetState createState(){
    return neededforhelpWidgetState();
  }
}

class neededforhelpWidgetState extends State<neededforhelpWidget>{

  dynamic did;
  var goal;
  var type;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  TextEditingController textController = TextEditingController();
  @override
  Future<dynamic> _emergency() async{
    did =  await FlutterSession().get('id');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Emergency')
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
  Future<dynamic> updateemergency() async {
    did =  await FlutterSession().get('id');

    await FirebaseFirestore.instance
        .collection('Emergency')
        .doc(did)
        .update({
      'status':'stop',

    })
        .then((value) => print("save"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future<dynamic> _goalID(goalID) async{

    session.set("goalid", goalID);


  }
  Widget build(BuildContext context){
    return
      Center(
          child:  FutureBuilder<dynamic>(
              future: _emergency(),
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
                                          leading: Icon(Icons.flag, size: 40,),
                                          title: Text(snapshot.data[index]['usersname']),


                                          onTap: () {
                                            updateemergency();
                                            session.set("emergencyID", snapshot.data[index]['emergencyID']);
                                            Navigator.push(context,
                                              MaterialPageRoute(builder: (context)=>HelpMapScreen()),
                                            );

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

                        list ],)
                );
              }
          )


      );

  }
}