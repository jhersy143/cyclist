import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'activitiesmenu.dart';
class UsersGoalFormWidget extends StatefulWidget{
  @override
  UsersGoalFormWidgetState createState(){
    return UsersGoalFormWidgetState();
  }
}

class UsersGoalFormWidgetState extends State<UsersGoalFormWidget>{

  dynamic did;
  var goal;
  var type;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  TextEditingController textController = TextEditingController();
  @override
  Future<dynamic> _goal() async{
    did =  await FlutterSession().get('id');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Goals')
        .where('userID',isEqualTo: did)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        query =  querySnapshot.docs.map((doc) =>doc.data()).toList();
        print(query);
      }

    });
    return query;
  }
  Future<dynamic> _goalID(goalID) async{

    session.set("goalid", goalID);


  }
  Widget build(BuildContext context){
    return
      Center(
          child:  FutureBuilder<dynamic>(
              future: _goal(),
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var list;
                if(snapshot.hasData){


                  list =
                      Flexible(

                        child: ListView.builder(
                            itemCount:   snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){
                              var distanceGoal = snapshot.data[index]['distanceGoal'];
                              var distanceTravel = snapshot.data[index]['distanceTravel']/1000;
                              var percentage  = (distanceTravel/distanceGoal)*100;
                              var width = distanceTravel/distanceGoal;
                              var isFinished = false;
                              if(percentage>=100){
                                percentage = 100;
                                width = 1.0;
                                isFinished = true;
                              }
                              else{
                                isFinished = false;
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
                                          leading: Icon(Icons.flag, size: 40,color:percentage>=100?Colors.blue:Colors.red,),
                                          title: Text(snapshot.data[index]['distanceGoal'].toString()+" KM"),
                                          subtitle:   Column(
                                              crossAxisAlignment:CrossAxisAlignment.start,
                                              children:[

                                                Row(
                                                  mainAxisAlignment: MainAxisAlignment.start,
                                                  children:[Container(
                                                      height: 10,
                                                      width: 280,
                                                      constraints: BoxConstraints.tightFor(),
                                                      color: Colors.grey,
                                                      child:Row(
                                                        mainAxisAlignment: MainAxisAlignment.start,
                                                        children:[

                                                          Container(
                                                            height: 10,
                                                            width: 280 * width,
                                                            color: Colors.blue,


                                                          ) ,



                                                        ],
                                                      )


                                                  )],
                                                ),
                                                Row(children:[
                                                  Padding(
                                                      padding: EdgeInsets.only(top:10),
                                                      child:Container(
                                                        height: 20,
                                                        child:Text("Completed"+":"+(percentage).round().toString()+"%",style: TextStyle(fontSize: 14),) ,
                                                      )
                                                  ),

                                                ])


                                              ]
                                          ),


                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                              //${accounts[index].first_name}
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


                        ActivityMenuFormWidget(),


                        list ],)
                );
              }
          )


      );

  }
}