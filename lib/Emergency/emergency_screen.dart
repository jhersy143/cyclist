import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'sendemergency.dart';

class EmergencyScreen extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('Emergency'),
      ),
      body: EmergencyWidget(),
    );
  }
}