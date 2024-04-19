import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';

import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class YourFriendFormWidget extends StatefulWidget{
  @override
  YourFriendFormWidgetState createState(){
    return YourFriendFormWidgetState();
  }
}

class YourFriendFormWidgetState extends State<YourFriendFormWidget>{

  dynamic did;
  var goal;
  var type;
  var search;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  var userlist;

  TextEditingController textController = TextEditingController();

  @override
  initState() {
    did =   FlutterSession().get('id');
    // at the beginning, all users are shown
    search = "";
    userlist = FirebaseFirestore.instance.collection('Users').where('userID',isNotEqualTo: did);
    print(userlist);

    super.initState();
  }
  void searchuser(String value) {
    setState(() {
      search = value;
    });

  }

  Future<dynamic> _Followers() async{
    did =  await FlutterSession().get('id');
    print(did);
    List<dynamic> query;
    await FirebaseFirestore.instance.collection('Followers')
        .where('userID',isEqualTo: did)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        query =  querySnapshot.docs.map((doc) =>doc.data()).toList();

      }

    });
    return query;
  }

  Widget build(BuildContext context){

    return
      Center(
          child:  FutureBuilder<dynamic>(
              future: _Followers(),
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var list;
                var url;
                if(snapshot.hasData){


                  list =
                      Flexible(

                        child: ListView.builder(
                            itemCount:   snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){
                              if(snapshot.data[index]['friendurl'].toString()==""){
                                url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
                              }
                              else{
                                url  = snapshot.data[index]['friendurl'];
                              }
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
                                          leading: Padding(
                                            padding: EdgeInsets.only(bottom:10,top:10,right: 10,left:10),
                                            child:   Container(
                                              width: 50,
                                              height: 50,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: NetworkImage(url),
                                                    fit: BoxFit.fill
                                                ),
                                              ),
                                            ),
                                          ),
                                          title: Text(snapshot.data[index]['friendname']),


                                          onTap: () {
                                            session.set('friendID', snapshot.data[index]['friendID']);

                                          },
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
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


                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('No Data'),
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



                        list],)
                );
              }
          )


      );

  }
}