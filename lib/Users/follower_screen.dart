import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'follower.dart';

class FollowerScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Follower"),
      ),
      body: FollowerFormWidget(),
    );
  }
}