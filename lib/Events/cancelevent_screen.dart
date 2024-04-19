import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'cancelevent.dart';

class CancelEventScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Event"),
      ),
      body:CanceleventFormWidget(),
    );
  }
}