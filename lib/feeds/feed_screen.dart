import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'feed.dart';
import '../flutter_session.dart';
class feedScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
          appBar:AppBar(
              title: Text("Feeds"
          ),

          ),
      body: MyfeedFormWidget(),
    );
  }
}