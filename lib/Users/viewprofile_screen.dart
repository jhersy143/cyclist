import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'viewprofile.dart';

class ViewProfileScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend"),
      ),
      body: ViewProfileFormWidget(),
    );
  }
}