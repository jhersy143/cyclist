import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'userlist.dart';

class userlistScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Friend"),
      ),
      body: UserListFormWidget(),
    );
  }
}