import 'dart:ffi';
import 'dart:io';
import 'package:cyclista/Events/viewevent_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'viewmember_screen.dart';
class ViewEventWidget extends StatefulWidget{
  @override
  ViewEventWidgetState createState(){
    return ViewEventWidgetState();
  }
}

class ViewEventWidgetState extends State<ViewEventWidget>{
  @override
  void initState() {
    super.initState();
    joined = true;
    _eventMembers();
    WidgetsBinding.instance.addPostFrameCallback((_) =>  _profile());
  }
  final _formKey = GlobalKey<FormState>();
  var session = FlutterSession();
  var firstname;
  var middlename;
  var lastname;
  var address;
  var email;
  var pass;
  var url;
  var profileurl;
  var details;
  var did;
  var updateUrl;
  dynamic eid;
  var joined;
  PickedFile imageFile;
  TextEditingController eventController = TextEditingController();

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
  Future uploadImageToFirebase(BuildContext context,String details,String userID,String profileurl,String name) async {
    String fileName = basename(imageFile.path);
    FirebaseStorage firebaseStorageRef =  FirebaseStorage.instance;
    UploadTask uploadTask =  firebaseStorageRef.ref().child('profilepic/$fileName').putFile(File(imageFile.path));

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    updateUrl = await taskSnapshot.ref.getDownloadURL();
    print(updateUrl);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
    );
    await FirebaseFirestore.instance
        .collection('Events')
        .add({'url': updateUrl,
      'details':details,
      'userID':userID,
      'profile':profileurl,
      'name':name
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future<dynamic> _profile() async{

    eid =  await FlutterSession().get('id');
    List<dynamic> query=[];
    await FirebaseFirestore.instance
        .collection('Users')

        .where(FieldPath.documentId,isEqualTo: eid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) {

          query = [firstname = doc['firstname'],
            middlename = doc['middlename'],
            lastname = doc['lastname'],
            address = doc['lastname'],
            email = doc['emailAddress'],
            pass = doc['password'],
            profileurl =  doc['url']
          ];


        });

      }

    });
    return query;
  }
  Future<dynamic> _join(String name,String profileurl) async{
    eid =  await FlutterSession().get('eid');
    did =  await FlutterSession().get('id');
    await FirebaseFirestore.instance
        .collection('EventsMembers')
        .add({

      'userID':did,
      'profile':profileurl,
      'name':name,
      'eventID':eid
    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future<dynamic> _event() async{

    eid =  await FlutterSession().get('eid');
    List<dynamic> query=[];
    await FirebaseFirestore.instance
        .collection('Events')
        .where(FieldPath.documentId,isEqualTo: eid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) {


          query = [details = doc['details'],
          url  = doc['url']
          ];


        });
        //print(url);
      }

    });

    return query;

  }
  Future<dynamic> _eventMembers() async{
    did =  await FlutterSession().get('id');
    eid =  await FlutterSession().get('eid');
    List<dynamic> query=[];
    await FirebaseFirestore.instance
        .collection('EventsMembers')
        .where('eventID',isEqualTo: eid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) {
          if(doc['userID'].toString()==did){
            setState(() {
              joined = false;
            });
          }


        });
        //print(url);
      }

    });

    return query;

  }
  void _openCamera(BuildContext context)  async{
    final  pickedFile = await ImagePicker().getImage(
      source: ImageSource.camera,
    );
    setState(() {
      imageFile = pickedFile;
    });
    Navigator.pop(context);
  }
  void _openGallery(BuildContext context)  async{
    final  pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery ,
    );
    setState(() {
      imageFile = pickedFile;
    });
    Navigator.pop(context);
  }



  Future _showChoiceDialog(BuildContext context)
  {

    return showDialog(context: context,builder: (BuildContext context){

      return AlertDialog(
        title: Text("Choose option",style: TextStyle(color: Colors.blue),),
        content: SingleChildScrollView(
          child: ListBody(
            children: [
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openGallery(context);
                },
                title: Text("Gallery"),
                leading: Icon(Icons.account_box,color: Colors.blue,),
              ),

              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  _openCamera(context);
                },
                title: Text("Camera"),
                leading: Icon(Icons.camera,color: Colors.blue,),
              ),
              Divider(height: 1,color: Colors.blue,),
              ListTile(
                onTap: (){
                  Navigator.pop(context);
                },
                title: Text("Cancel"),
                leading: Icon(Icons.cancel,color: Colors.blue,),
              ),
            ],
          ),
        ),);
    });
  }

  @override
  Widget build(BuildContext context){

    return SingleChildScrollView(
        child:
        Form(
            key: _formKey, child:

        FutureBuilder<dynamic>(
            future: Future.wait([
              _event(),
              _profile()


            ]),
            builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              List<Widget> children;

              if(snapshot.hasData){
                eventController.text = details;

                children = [
                  Container(
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

              Align(
              alignment: Alignment.center,
              child:
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(

                    width: 350,
                    child:
                      Text(

                        details,
                        textAlign: TextAlign.justify,

                        )
                    ),

                  ),
              ),
           Padding(
             padding: const EdgeInsets.only(top:50.0),
                 child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: joined==true?(){
                          setState(() {
                            joined = false;
                          });
                          String name = firstname +" "+middlename+" "+lastname;

                          _join(name, profileurl);
                          //_profile();
                        }:null
                            , child: Text(joined==true?"Join":"Joined"),
                        style: ElevatedButton.styleFrom(
                           primary:  joined?Colors.blueAccent:Colors.grey),

                        ),

                      ),
                      // Padding(
                      //   padding: const EdgeInsets.all(8.0),
                      //   child: ElevatedButton(onPressed: (){
                      //     Navigator.pop(context);
                      //   }
                      //       , child: Text("Back")),
                      // ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ElevatedButton(onPressed: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(

                              builder: (context) => ViewMemberScreen(),
                            ),
                          ).then(
                                  (value) { setState(() {});});
                          //_profile();
                        }
                            , child: Text("Members")),
                      ),
                    ]
                    ,

                  ),
              )

                ];

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
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: children

              );
            }
        )

        )
    );
  }
}