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
import 'usersgoal_screen.dart';
import 'usersevent_screen.dart';
import 'package:cyclista/Events/event_screen.dart';
class ActivityMenuFormWidget extends StatefulWidget{
  @override
  ActivityMenuWidgetState createState(){
    return ActivityMenuWidgetState();
  }
}

class ActivityMenuWidgetState extends State<ActivityMenuFormWidget>{
  @override
  void initState() {
    super.initState();

  }






  @override
  Widget build(BuildContext context){

    return Container(
        child:

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
            children:[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(

                      builder: (context) => UsersGoalScreen(),
                    ),
                  );
                }
                    , child: Text("Goal")),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(

                      builder: (context) => UsersEventScreen(),
                    ),
                  );
                }
                    , child: Text("Events")),
              ),
            ],



        )

    );
  }
}