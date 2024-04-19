import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'yourfriend.dart';

class yourfriendScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend"),
      ),
      body: YourFriendFormWidget(),
    );
  }
}