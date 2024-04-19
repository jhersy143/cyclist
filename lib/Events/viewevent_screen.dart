import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'viewevent.dart';

class vieweventScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Event"),
      ),
      body: ViewEventWidget(),
    );
  }
}