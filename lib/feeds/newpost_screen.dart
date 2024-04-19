import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'newpost.dart';

class NewPostScreen extends StatelessWidget{
  @override
  void initState() {

  }
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("New Post"),

      ),
      body: NewPostWidget(),

    );
  }
}