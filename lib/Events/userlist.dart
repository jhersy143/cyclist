import 'package:cyclista/Follow/yourfriend_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserListFormWidget extends StatefulWidget{
  @override
  UserListFormWidgetState createState(){
    return UserListFormWidgetState();
  }
}

class UserListFormWidgetState extends State<UserListFormWidget>{

  dynamic did;
  var goal;
  var type;
  var search;
  var firstname;
  var middlename;
  var lastname;
  var address;
  var email;
  var pass;
  var url;
  var updateUrl;
  dynamic friendID;
  var userurl,friendurl,username,friendname;
  QuerySnapshot querySnapshotdata;
  List<dynamic> listItem;
  var session = FlutterSession();
  var userlist;
  Future<dynamic> userlistFuture;
  TextEditingController textController = TextEditingController();

  @override
  initState() {
    did =   FlutterSession().get('id');
    // at the beginning, all users are shown
    search = "";
    userlist = FirebaseFirestore.instance.collection('Users').where('userID',isNotEqualTo: did);
    userlistFuture = _usersAll();
    _profile();
    super.initState();
  }
  void searchuser(String value) {
    setState(() {
      if(value==""){
        userlistFuture = _usersAll();
      }
      else
        {
          userlistFuture = _userOne(value);
        }


    });

  }
  Future<dynamic> _profile() async{
    try {
      UserCredential userCredential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: "a@gmail.com",
          password: "password"
      );
      // Disable persistence on web platforms

    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        print('No user found for that email.');
      } else if (e.code == 'wrong-password') {
        print('Wrong password provided for that user.');
      }
    }
    did =  await FlutterSession().get('id');
    List<dynamic> query=[];
    await FirebaseFirestore.instance
        .collection('Users')
        .where(FieldPath.documentId,isEqualTo: did)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) {
          setState(() {
            if(doc['url']==""){
              url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
            }
            else{
              url  = doc['url'];
            }

            firstname = doc['firstname'];
            middlename = doc['middlename'];
            lastname = doc['lastname'];
            address = doc['lastname'];
            email = doc['emailAddress'];
            pass = doc['password'];

          });


        });

      }

    });
    return query;
  }  Future<dynamic> _usersAll() async{
    did =  await FlutterSession().get('id');
    print(did);
    List<dynamic> query;
    await FirebaseFirestore.instance.collection('Users')
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
  Future<dynamic> _userOne(String firstname) async{
    did =  await FlutterSession().get('id');
    print(did);
    List<dynamic> query;
    await FirebaseFirestore.instance.collection('Users')
        .where('firstname',isEqualTo: firstname)
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
  Future<dynamic> _addchat(String friendID,String friendname,String friendurl)async{
    did =  await FlutterSession().get('id');
    var place = await FlutterSession().get('PLACE');
    var weather = await FlutterSession().get('WEATHER');
    var description = await FlutterSession().get('DESCRIPTION');
    var temperature = await FlutterSession().get('TEMPERATURE');
    var message = place + "\n" + weather + "\n" + description + "\n" + temperature;
    username =  firstname + " " + middlename +" "+lastname;

    userurl =  url;

    await FirebaseFirestore.instance
        .collection('Chats')
        .add({'userurl': userurl,
      'friendurl': friendurl,
      'username':username,
      'friendname':friendname,
      'userID':did,
      'friendID':friendID,
      'datetime':DateTime.now(),
      'message':message,
      'type':'sent',
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));

    await FirebaseFirestore.instance
        .collection('Chats')
        .add({'userurl': friendurl,
      'friendurl': userurl,
      'username':friendname,
      'friendname':username,
      'userID':friendID,
      'friendID':did,
      'datetime':DateTime.now(),
      'message':message,
      'type':'received',
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Widget build(BuildContext context){

    return
      Center(
          child:  FutureBuilder<dynamic>(
              future: userlistFuture,
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var list;
                var url;
                if(snapshot.hasData){


                  list =
                      Flexible(

                        child: ListView.builder(
                            itemCount:   snapshot.data.length,
                            itemBuilder: (BuildContext context, int index){
                              if(snapshot.data[index]['url'].toString()==""){
                                url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
                              }
                              else{
                                url  = snapshot.data[index]['url'];
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
                                          title: Text(snapshot.data[index]['firstname']),

                                          trailing:    Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: ElevatedButton(onPressed: (){
                                              var friendID = snapshot.data[index]['userID'];
                                              var friendname = snapshot.data[index]['firstname']+" "+snapshot.data[index]['middlename']+" "+snapshot.data[index]['lastname'];
                                              var friendurl = snapshot.data[index]['url'];
                                              _addchat(friendID,friendname,friendurl);
                                              //_profile();
                                            }
                                                , child: Text("Send")),
                                          ),

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

                              SizedBox(
                                child: CircularProgressIndicator(),
                                width: 60,
                                height: 40,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 10),
                                child: Text('Awaiting result...'),
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

                        Container(
                          margin: EdgeInsets.only(top:10),
                          child:

                          TextField (
                            onChanged: (value) => searchuser(value),
                            decoration: InputDecoration(
                                border: InputBorder.none,
                                labelText: 'Search',suffixIcon: Icon(Icons.search),
                                hintText: 'Search'
                            ),
                          ),



                        ),

                        list],)
                );
              }
          )


      );

  }
}