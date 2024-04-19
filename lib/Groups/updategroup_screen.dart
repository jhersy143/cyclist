import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'updategroup.dart';
class updategroupScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Group"),
      ),
      body: updategroupFormWidget(),
    );
  }
}