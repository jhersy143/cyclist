import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../home.dart';

import '../flutter_session.dart';
import 'goal_screen.dart';
class addgoalFormWidget extends StatefulWidget{
  @override
  addgoalFormWidgetState createState(){
    return addgoalFormWidgetState();
  }
}

class addgoalFormWidgetState extends State<addgoalFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController goalController = TextEditingController();
  dynamic did;

  String validateNumber(String value) {
    Pattern pattern = r"^[0-9]+$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid number';
    else
      return null;
  }
  void _goal(String distanceGoal) async{
    did =  await FlutterSession().get('id');
    var doc = FirebaseFirestore.instance.collection('Goals').doc();
    await FirebaseFirestore.instance
        .collection('Goals')
        .doc(doc.id)
        .set({'distanceGoal': int.parse(goalController.text) ,
      'dateCreated': DateTime.now(),
      'userID':did,
      'type':'personal',
      'goalID':doc.id,
      'status':'',
      'distanceTravel':0
    }
    );
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));
    print(did);

  }


  @override
  Widget build(BuildContext context){
    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: goalController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                    labelText: "distance in KM"
                ),
                validator:validateNumber,
              ),
            ),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    if(_formKey.currentState.validate()){
                      _goal(goalController.text);
                      Navigator.pop(
                        context,
                        MaterialPageRoute(
                          builder: (context) => goalScreen(),
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
                    goalController.text = "";

                  }
                      , child: Text("Clear")),
                ),

              ],
            ),

          ],
        )
    );
  }
}