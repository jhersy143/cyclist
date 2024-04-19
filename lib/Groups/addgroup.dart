import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';


import '../flutter_session.dart';
import 'groups_screen.dart';
class addgroupFormWidget extends StatefulWidget{
  @override
  addgroupFormWidgetState createState(){
    return addgroupFormWidgetState();
  }
}

class addgroupFormWidgetState extends State<addgroupFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController groupController = TextEditingController();
  TextEditingController detailsController = TextEditingController();

  dynamic did;

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
  void _group() async{
    did =  await FlutterSession().get('id');
    var doc = FirebaseFirestore.instance.collection('Groups').doc();
    var name =  await FlutterSession().get('name');
    await FirebaseFirestore.instance
        .collection('Groups')
        .doc(doc.id)
        .set({'group': groupController.text,
      'dateCreated': DateTime.now(),
      'userID':did,
      'groupID':doc.id,
      'details': detailsController.text,
      'name':name

    }
    );
    await FirebaseFirestore.instance
        .collection('GroupMembers')
        .doc(doc.id)
        .set({'group': groupController.text,
      'dateCreated': DateTime.now(),
      'userID':did,
      'groupID':doc.id,
      'details': detailsController.text,
    }
    );
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
                controller: groupController,
                decoration: InputDecoration(
                    labelText: "group"
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
                      _group();
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
            ),

          ],
        )
    );
  }
}