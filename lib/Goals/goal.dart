import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addgoal_screen.dart';
import 'updategoal_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'goalmap_screen.dart';
class MygoalFormWidget extends StatefulWidget{
  @override
  MygoalFormWidgetState createState(){
    return MygoalFormWidgetState();
  }
}

class MygoalFormWidgetState extends State<MygoalFormWidget>{

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
    print(did);
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

      }

    });
    return query;
  }
  void _updatestatus(String goalid) async{
    
    await FirebaseFirestore.instance
        .collection('Goals')
        .doc(goalid)
        .update({'status': 'started',})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));

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
                        height: 120,
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
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ElevatedButton(
                                        style:ButtonStyle(backgroundColor: MaterialStateProperty.all(isFinished?Colors.grey:Color(0xff00ABE1))),
                                          onPressed: isFinished?null:(){
                                          setState(() {
                                            session.set('goalID', snapshot.data[index]['goalID']);
                                          });
                                        _updatestatus(snapshot.data[index]['goalID']);

                                        Navigator.push(context, MaterialPageRoute(builder:
                                            (context)=>mapScreen(),
                                        ));

                                      }
                                          , child: Text(isFinished?"finished":"Start")),
                                    ),
                                  ])


                    ]
                                ),

                                onTap: () {
                                  //_goalID(snapshot.data[index]['goalID']);
                                  //Navigator.push(
                                   // context,
                                   // MaterialPageRoute(
                                    //  builder: (context) => updategoalScreen(),
                                   // ),
                                 // ).then(
                                      //    (value) { setState(() {});});
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
          Padding(
          padding: const EdgeInsets.all(8.0),
          child: ElevatedButton(onPressed: (){
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => addgoalScreen(),
              ),
            ).then(
                    (value) { setState(() {});});

          }
          , child: Text("Add Goal")),
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

            list ],)
        );
        }
    )


          );

  }
}