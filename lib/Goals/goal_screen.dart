import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'goal.dart';

class goalScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Goal"),

      ),
      body: MygoalFormWidget(),
    );
  }
}