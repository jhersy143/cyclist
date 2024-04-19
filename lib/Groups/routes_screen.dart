import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'routes.dart';

class GroupRoutesScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('Routes'),),
      body: GroupRoutesFormWidget(),
    );
  }
}