import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'goalmap.dart';


class mapScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Map"),
      ),
      body: MymapFormWidget(),
    );
  }
}