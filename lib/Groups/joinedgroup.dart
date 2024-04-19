import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'addgroup_screen.dart';
import 'updategroup_screen.dart';
import 'viewmember_screen.dart';
import '../flutter_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'dart:async';
import 'dart:convert';
import 'joinedgroup_screen.dart';
import 'groupmenu_screen.dart';
class GroupJoinedWidget extends StatefulWidget{
  @override
  GroupJoinedWidgetState createState(){
    return GroupJoinedWidgetState();
  }
}

class GroupJoinedWidgetState extends State<GroupJoinedWidget>{

  dynamic did;
  var goal;
  var type;
  List<dynamic> joinedquery;
  List<dynamic> query;
  List<dynamic> queryall;
  QuerySnapshot querySnapshotdata;
  var search;
  var url;
  var session = FlutterSession();
  Timer timer;
  int counter = 0;
  TextEditingController textController = TextEditingController();
  @override
  initState() {
    did =   FlutterSession().get('id');
    url =   FlutterSession().get('profileurl');
    // at the beginning, all users are shown
   Timer.periodic(Duration(seconds: 3), (Timer t) => search==""?_groupsAll() :_groups(search));

    search = "";
    super.initState();
  }
  Future<dynamic> _groups(String group) async{
    did =  await FlutterSession().get('id');
    await new Future.delayed(const Duration(seconds: 3));
    List<dynamic> listItem=[];
    await FirebaseFirestore.instance
        .collection('Groups')
        .where('userID',isNotEqualTo: did)
        .where('group',isEqualTo: group)
        .get()

        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {


      }
      else {

        query = querySnapshot.docs.map((doc) => doc.data()).toList();



      }
    });

    return  query;
  }
  Future<dynamic> _groupsAll() async{
    did =  await FlutterSession().get('id');
    await new Future.delayed(const Duration(seconds: 3));
    List<dynamic> listItem=[];
    await FirebaseFirestore.instance
        .collection('Groups')
        .where('userID',isNotEqualTo: did)
        .get()

        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {


      }
      else {

        queryall = querySnapshot.docs.map((doc) => doc.data()).toList();



      }
    });

    return  queryall;
  }
  Future<dynamic> _profile() async{
    did =  await FlutterSession().get('id');
    var profile;

    List<dynamic> listItem=[];
    await FirebaseFirestore.instance
        .collection('Users')
        .where('userID',isNotEqualTo: did)
        .get()

        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {


      }
      else {

        profile = querySnapshot.docs.map((doc) => doc.data()).toList();



      }
    });

    return  profile;
  }
  Future<dynamic> _selectJoinedGroup(String groupIDid) async{
    did =  await FlutterSession().get('id');

    await FirebaseFirestore.instance
        .collection('GroupMembers')
        .where('groupID',isEqualTo: groupIDid)
        .where('userID',isEqualTo: did)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if (querySnapshot.docs.isEmpty) {


      }
      else {

        joinedquery = querySnapshot.docs.map((doc) => doc.data()).toList();



      }
    });

    return  joinedquery;

  }

  Future<dynamic> _groupID(groupID) async{

    session.set("groupid", groupID);


  }
  void _joinedgroup(String group,String details, String groupid) async{
    did =  await FlutterSession().get('id');
    var name =  await FlutterSession().get('name');
    var doc = FirebaseFirestore.instance.collection('Groups').doc();
    await FirebaseFirestore.instance
        .collection('GroupMembers')
        .doc(doc.id)
        .set({'group': group,
      'dateCreated': DateTime.now(),
      'userID':did,
      'name':name,
      'groupID':groupid,
      'details': details,

    }
    );



  }
  void searchuser(String value) {
    setState(() {
      search = value;
    });

  }

  Widget build(BuildContext context){

    return
      Center(
          child:  FutureBuilder<dynamic>(
              future:search==""?_groupsAll() :_groups(search),

              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var list;

                if(snapshot.hasData){

                  list =
                      Flexible(

                        child: ListView.builder(
                            itemCount:   snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){

                             return  FutureBuilder<dynamic>(
                                  future:
                                    _selectJoinedGroup(snapshot.data[index]['groupID']),

                                  builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot2) {


                                  if(snapshot2.hasData){


                                  if(snapshot2.data[0]!=null&&snapshot2.data[0]['groupID']==snapshot.data[index]['groupID']){

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 80,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          color:  Colors.white,
                                          elevation: 3,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.group, size: 40,),
                                                title: Text(snapshot.data[index]['group']),
                                                subtitle: Text(snapshot.data[index]['details']),
                                                trailing:  Padding(
                                                  padding: const EdgeInsets.all(8.0),

                                                  child:

                                                  ElevatedButton(onPressed: (){
                                                    _joinedgroup(snapshot.data[index]['group'],snapshot.data[index]['details'],snapshot.data[index]['groupID']);
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => GroupJoinedScreen(),
                                                      ),
                                                    ); }
                                                      , child: Text("Joined")),
                                                ),
                                                onTap: () {
                                                  session.set("groupname", snapshot.data[index]['group']);
                                                  session.set("gid", snapshot.data[index]['groupID']);
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(

                                                      builder: (context) => groupMenuScreen(),
                                                    ),
                                                  ).then(
                                                          (value) { setState(() {});});
                                                  //_groupID(snapshot.data[index]['groupID']);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                  }
                                  else{


                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 80,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          color:  Colors.white,
                                          elevation: 3,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.group, size: 40,),
                                                title: Text(snapshot.data[index]['group']),
                                                subtitle: Text(snapshot.data[index]['details']),
                                                trailing:  Padding(
                                                  padding: const EdgeInsets.all(8.0),

                                                  child:

                                                  ElevatedButton(onPressed: (){
                                                    _joinedgroup(snapshot.data[index]['group'],snapshot.data[index]['details'],snapshot.data[index]['groupID']);
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => GroupJoinedScreen(),
                                                      ),
                                                    );  }
                                                      , child: Text("Join Group")),
                                                ),
                                                onTap: () {
                                                  setState(() {

                                                    session.set("gid", snapshot.data[index]['groupID']);

                                                  });

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(

                                                      builder: (context) => ViewMemberScreen(),
                                                    ),
                                                  ).then(
                                                          (value) { setState(() {});});
                                                  //_groupID(snapshot.data[index]['groupID']);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );

                                  } }
                                    else{
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        height: 80,
                                        child: Card(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(8.0),
                                          ),
                                          color:  Colors.white,
                                          elevation: 3,
                                          child: Column(
                                            mainAxisSize: MainAxisSize.min,

                                            children: [
                                              ListTile(
                                                leading: Icon(Icons.group, size: 40,),
                                                title: Text(snapshot.data[index]['group']),
                                                subtitle: Text(snapshot.data[index]['details']),
                                                trailing:  Padding(
                                                  padding: const EdgeInsets.all(8.0),

                                                  child:

                                                  ElevatedButton(onPressed: (){
                                                    _joinedgroup(snapshot.data[index]['group'],snapshot.data[index]['details'],snapshot.data[index]['groupID']);
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => GroupJoinedScreen(),
                                                      ),
                                                    ); }
                                                      , child: Text("Join Group")),
                                                ),
                                                onTap: () {
                                                  setState(() {

                                                    session.set("gid", snapshot.data[index]['groupID']);

                                                  });

                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(

                                                      builder: (context) => groupMenuScreen(),
                                                    ),
                                                  ).then(
                                                          (value) { setState(() {});});
                                                  //_groupID(snapshot.data[index]['groupID']);
                                                },
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                    );
                                    }

                                  });






                              //${accounts[index].first_name}
                            }),
                      );




                }

                else {
                  list =  Padding(

                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 80,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        color:  Colors.white,
                        elevation: 3,
                        child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [

                              SizedBox(
                                child: CircularProgressIndicator(),
                                width: 60,
                                height: 40,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Loading...'),
                              ),]
                        ),
                      ),
                    ),
                  );



                }

                return   Container(
                    margin: EdgeInsets.only(top:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[

                        TextField (
                          onChanged: (value) => searchuser(value),
                          decoration: InputDecoration(
                              border: InputBorder.none,
                              labelText: 'Search',suffixIcon: Icon(Icons.search),
                              hintText: 'Search'
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Other Group",
                            style:TextStyle(fontSize: 20),
                          )
                          ,
                        ),
                        list ],)
                );
              }
          )


      );

  }
}