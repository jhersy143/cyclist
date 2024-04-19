import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import '../flutter_session.dart';
import 'groups_screen.dart';
import 'viewmember_screen.dart';
class GroupDetailsFormWidget extends StatefulWidget{
  @override
  GroupDetailsFormWidgetState createState(){
    return GroupDetailsFormWidgetState();
  }
}

class GroupDetailsFormWidgetState extends State<GroupDetailsFormWidget>{
  final _formKey = GlobalKey<FormState>();
  TextEditingController groupController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  dynamic groupID;
  List<dynamic> query;
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

  Future<dynamic> _groups() async{
    groupID =  await FlutterSession().get('groupdID');
    await new Future.delayed(const Duration(seconds: 3));
    List<dynamic> listItem=[];
    await FirebaseFirestore.instance
        .collection('Groups')
        .where('groupID',isEqualTo: groupID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {


      }
      else {

        query = querySnapshot.docs.map((doc) => doc.data()).toList();
        groupController.text = query[0]['group'];
        detailsController.text = query[0]['details'];
        nameController.text = query[0]['name'];
        print(query);

      }
    });

    return  query;
  }

  @override
  Widget build(BuildContext context){
    _groups();

    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                enabled: false,
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
                enabled: false,
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                enabled: false,
                controller: nameController,
                decoration: InputDecoration(
                    labelText: "Admin"
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

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ViewMemberScreen(),
                        ),
                      );
                    }
                  }
                      , child: Text("Members")),
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

          ],
        )
    );
  }
}