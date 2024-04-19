import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'chat_screen.dart';
import 'package:cyclista/flutter_session.dart';
class AddFriendFormWidget extends StatefulWidget{
  @override
  AddFriendWidgetState createState(){
    return AddFriendWidgetState();
  }
}

class AddFriendWidgetState extends State<AddFriendFormWidget>{
  @override
  void initState() {
    enabled = true;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) =>  _profile());
  }
  final _formKey = GlobalKey<FormState>();
  var firstname;
  var middlename;
  var lastname;
  var address;
  var email;
  var pass;
  var url;
  var updateUrl;
  dynamic did;
  dynamic friendID;
  var enabled;
  PickedFile imageFile;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();
  var session = FlutterSession();
  String validateEmail(String value) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value) || value == null)
      return 'Enter a valid email address';
    else
      return null;
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
          if(doc['url']==""){
            url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
          }
          else{
            url  = doc['url'];
          }

          query = [firstname = doc['firstname'],
            middlename = doc['middlename'],
            lastname = doc['lastname'],
            address = doc['lastname'],
            email = doc['emailAddress'],
            pass = doc['password'],
            url
          ];


        });

      }

    });
    return query;
  }

  Future<dynamic> _friend() async{
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
    friendID =  await FlutterSession().get('friendID');

    List<dynamic> query=[];
    await FirebaseFirestore.instance
        .collection('Users')
        .where('userID',isEqualTo: friendID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) {
          if(doc['url']==""){
            url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
          }
          else{
            url  = doc['url'];
          }

          query = [firstname = doc['firstname'],
            middlename = doc['middlename'],
            lastname = doc['lastname'],
            address = doc['lastname'],
            email = doc['emailAddress'],
            pass = doc['password'],
            url
          ];


        });

      }

    });
    return query;
  }
 Future<dynamic> _addfriend(String usersname,String friendname,String userurl,String friendurl)async{
   await FirebaseFirestore.instance
       .collection('Followers')
       .add({'userurl': userurl,
     'friendurl': friendurl,
     'usersname':usersname,
     'userID':did,
     'friendname':friendname,
     'friendID':friendID,

   })
       .then((value) => print("User Updated"))
       .catchError((error) => print("Failed to update user: $error"));
 }


  Future<dynamic> _Followers() async{
    did =  await FlutterSession().get('id');
    friendID =  await FlutterSession().get('friendID');
var sample;
    List<dynamic> query;
    await FirebaseFirestore.instance.collection('Followers')
        .where('userID',isEqualTo: did)
        .where('fiendID',isEqualTo: friendID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {
        setState(() {
          enabled = false;
        });
        sample =  querySnapshot.docs.map((doc) =>doc.data()).toList();
        print(sample);
      }

    });
    return query;
  }

  @override
  Widget build(BuildContext context){

    return SingleChildScrollView(
        child:
        Form(
            key: _formKey, child:

        FutureBuilder<dynamic>(
            future: Future.wait([
              _friend(),
              _profile(),
              _Followers()
            ]

            ),
            builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;

              if(snapshot.hasData){
                var friendname = snapshot.data[0][0]+" "+snapshot.data[0][1]+" "+snapshot.data[0][2];
                var usersname = snapshot.data[1][0]+" "+snapshot.data[1][1]+" "+snapshot.data[1][2];
                var userurl = snapshot.data[1][6];
                var friendurl = snapshot.data[0][6];

                firstNameController.text = snapshot.data[0][0];
                middleNameController.text = snapshot.data[0][1];
                lastNameController.text = snapshot.data[0][2];
                addressController.text = snapshot.data[0][3];
                emailController.text = snapshot.data[0][4];
                passwordController.text = snapshot.data[0][5];
                confirmPasswordController.text = snapshot.data[0][5];
                children = [Container(
                    width: 400,
                    height: 300,
                    margin: EdgeInsets.only(bottom: 10, top: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child:
                    imageFile==null? Image.network(url.toString(), width: 350,
                        height: 300,
                        fit: BoxFit.fitWidth): Image.file(File(imageFile.path),width: 350,
                        height: 300,
                        fit: BoxFit.fitWidth)


                )
                  ,

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: firstNameController,
                      decoration: InputDecoration(
                          labelText: "First Name"
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "First name should not be empty.";
                        }
                        return null;
                      },
                    ),
                  ), Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: middleNameController,
                      decoration: InputDecoration(
                          labelText: "Middle Name"
                      ),

                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: lastNameController,
                      decoration: InputDecoration(
                          labelText: "Last Name"
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Last name should not be empty.";
                        }
                        return null;
                      },
                    ),
                  ), Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: addressController,
                      decoration: InputDecoration(
                          labelText: "Address"
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Address should not be empty.";
                        }
                        return null;
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      enabled: false,
                      controller: emailController,
                      decoration: InputDecoration(
                          labelText: "Email Address"
                      ),
                      validator: validateEmail,
                    ),
                  ),


                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),

                        child: ElevatedButton(
                            onPressed: enabled?(){
                              setState(() {
                                enabled = false;
                              });
                          _addfriend(usersname,friendname,userurl,friendurl);
                        }:null
                            , child: Text(enabled==true?"Follow":"Followed"),
                        style: ElevatedButton.styleFrom(
                            primary:  enabled?Colors.blueAccent:Colors.grey)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          session.set('friendID', friendID);
                          session.set('usersname', usersname);
                          session.set('friendname', friendname);
                          session.set('userurl', userurl);
                          session.set('friendurl', friendurl);
                          Navigator.push(context,

                              MaterialPageRoute(builder: (context)=>chatsScreen()));
                        }
                            , child: Text("Chat")),
                      ),

                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ElevatedButton(onPressed: (){
                      //     Navigator.pop(context);
                      //   }
                      //       , child: Text("Back")),
                      // ),



                    ]
                    ,

                  )
                  ,];

              }
              else if (snapshot.hasError) {
                children = <Widget>[
                  const Icon(
                    Icons.error_outline,
                    color: Colors.red,
                    size: 60,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 16),
                    child: Text('Error: ${snapshot.error}'),
                  )
                ];


              }
              else {
                children = const <Widget>[
                  SizedBox(
                    child: CircularProgressIndicator(),
                    width: 60,
                    height: 60,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: Text('Awaiting result...'),
                  )
                ];
              }

              return   Column(
                  crossAxisAlignment: CrossAxisAlignment.center,

                  children: children

              );
            }
        )

        )
    );
  }
}