import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'searchfriend.dart';

class searchfriendScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend"),
      ),
      body: SearchFriendFormWidget(),
    );
  }
}