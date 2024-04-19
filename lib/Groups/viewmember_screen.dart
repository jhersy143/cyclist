import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'viewmember.dart';

class ViewMemberScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text("Group"),
      ),
      body: ViewMemberWidget(),
    );
  }
}