import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'groups_screen.dart';
class updategroupFormWidget extends StatefulWidget{
  @override
  updategroupFormWidgetState createState(){
    return updategroupFormWidgetState();
  }
}

class updategroupFormWidgetState extends State<updategroupFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController groupController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  dynamic did;
  var groupid;
  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
  }

  Future<dynamic> _group() async{
    did =  await FlutterSession().get('groupid');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Groups')
        .where('groupID',isEqualTo: did)
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

  void _updategrouo(String group,String details) async{
    groupid =  await FlutterSession().get('groupid');

    await FirebaseFirestore.instance
        .collection('Groups')
        .doc(groupid)
        .update({'group': group,'details':details})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    print(groupid);

  }
  @override
  Widget build(BuildContext context){
    return Form(
        key: _formKey,
        child:FutureBuilder<dynamic>(
            future: _group(),
            builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;
              if(snapshot.hasData){
                groupController.text = snapshot.data[0]['group'];
                detailsController.text = snapshot.data[0]['details'];
                children = [ Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: groupController,
                    decoration: InputDecoration(
                        labelText: "goal"
                    ),
                    validator: (value){
                      if(value == null || value.isEmpty){
                        return "Last name should not be empty.";
                      }
                      return null;
                    },
                  ),
                ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: detailsController,
                      decoration: InputDecoration(
                          labelText: "details"
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Last name should not be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          if(_formKey.currentState.validate()){
                            _updategrouo(groupController.text,detailsController.text);
                            Navigator.pop(
                              context,
                              MaterialPageRoute(
                                builder: (context) => groupsScreen(),
                              ),
                            );
                          }
                        }
                            , child: Text("Submit")),
                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ElevatedButton(onPressed: (){
                      //     Navigator.pop(context);
                      //   }
                      //       , child: Text("Back")),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          groupController.text = "";
                          detailsController.text = "";
                        }
                            , child: Text("Clear")),
                      ),

                    ],
                  ),];

              }
              else if (snapshot.hasError) {

                children = [Padding(

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
                            const Icon(
                              Icons.error_outline,
                              color: Colors.red,
                              size: 60,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 16),
                              child: Text('Error: ${snapshot.error}'),
                            ),]
                      ),
                    ),
                  ),


                )];

              }
              else{
                children =  [Padding(

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
                )


                ];
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: children,


              );
            }
        )

    );
  }
}