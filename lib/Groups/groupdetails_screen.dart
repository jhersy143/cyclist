import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'groupdetails.dart';

class GroupDetailsScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Group"),

      ),
      body: GroupDetailsFormWidget(),
    );
  }
}