import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'usersgoal.dart';

class UsersGoalScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Goal"),
      ),
      body: UsersGoalFormWidget(),
    );
  }
}