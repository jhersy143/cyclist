import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'signup.dart';
import 'profilemenu.dart';
class ProfileMenuScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Menu"),
      ),
      body: ProfileMenuFormWidget(),
    );
  }
}