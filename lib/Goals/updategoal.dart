

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'goal_screen.dart';
import '../flutter_session.dart';
class updategoalFormWidget extends StatefulWidget{
  @override
  updategoalFormWidgetState createState(){
    return updategoalFormWidgetState();
  }
}

class updategoalFormWidgetState extends State<updategoalFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController goalController = TextEditingController();
  TextEditingController percentageController = TextEditingController();
  dynamic did;
  var goalid;
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

  Future<dynamic> _goal() async{
    did =  await FlutterSession().get('goalid');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Goals')
        .where('goalID',isEqualTo: did)
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

  void _updategoal(String goal,String percentage) async{
    goalid =  await FlutterSession().get('goalid');

    await FirebaseFirestore.instance
        .collection('Goals')
        .doc(goalid)
        .update({'goal': goal,'percentage':percentage})
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    print(goalid);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully Saved!'),
    ));

  }
  @override
  Widget build(BuildContext context){
    return Form(
        key: _formKey,
        child:FutureBuilder<dynamic>(
      future: _goal(),
      builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
      List<Widget> children;
      if(snapshot.hasData){
        goalController.text = snapshot.data[0]['goal'];
        percentageController.text = snapshot.data[0]['percentage'].toString();
        children = [ Padding(
          padding: const EdgeInsets.all(8.0),
          child: TextFormField(
            controller: goalController,
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
              controller: percentageController,
              decoration: InputDecoration(
                  labelText: "Percentage"
              ),
              keyboardType:
              TextInputType.number,
              inputFormatters:[                        //only numeric keyboard.
               FilteringTextInputFormatter.digitsOnly,
                FilteringTextInputFormatter.allow(RegExp(r"^[1-9][0-9]?$|^100$"))
              ],
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
          _updategoal(goalController.text,percentageController.text);
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