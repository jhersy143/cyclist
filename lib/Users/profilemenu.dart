import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'classUpdateProfile.dart';
import 'yourfriend_screen.dart';
import 'follower_screen.dart';
import 'userfeeds_screen.dart';
class ProfileMenuFormWidget extends StatefulWidget{
  @override
  ProfileMenuWidgetState createState(){
    return ProfileMenuWidgetState();
  }
}

class ProfileMenuWidgetState extends State<ProfileMenuFormWidget>{
  @override
  void initState() {
    super.initState();

  }




  @override
  Widget build(BuildContext context){

    return SingleChildScrollView(
        child:
              Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

              // Padding(
              //   padding: const EdgeInsets.all(8.0),
              //   child: ElevatedButton(onPressed: (){
              //     Navigator.pop(context);


              Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(

              builder: (context) => feedScreen(),
              ),
              );
              }
              , child: Text("View Post")),
              )
              ,

              Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){

              }
              , child: Text("Activity")),
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
              Navigator.push(
              context,
              MaterialPageRoute(

              builder: (context) => FollowerScreen(),
              ),
              );
              }
              , child: Text("Followers")),
              )
              ,
              Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){
              Navigator.push(
              context,
              MaterialPageRoute(

              builder: (context) => yourfriendScreen(),
              ),
              );
              }
              , child: Text("Following")),
              )
              ,

              ]
                ,

              ),
        );


  }
}