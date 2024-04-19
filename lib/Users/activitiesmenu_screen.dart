import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
import 'profile.dart';
import 'activitiesmenu.dart';
class ActivityMenuScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Profile"),
      ),
      body: ActivityMenuFormWidget(),
    );
  }
}