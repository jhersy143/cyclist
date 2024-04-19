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
import 'classUpdateProfile.dart';
import 'yourfriend_screen.dart';
import 'follower_screen.dart';
import 'userfeeds_screen.dart';
import 'activitiesmenu_screen.dart';
import 'usersgoal_screen.dart';
class MyProfileFormWidget extends StatefulWidget{
  @override
  MyProfileWidgetState createState(){
    return MyProfileWidgetState();
  }
}

class MyProfileWidgetState extends State<MyProfileFormWidget>{
  @override
  void initState() {
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
  PickedFile imageFile;
  TextEditingController firstNameController = TextEditingController();
  TextEditingController middleNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

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
  Future uploadImageToFirebase(BuildContext context,String address,String email,String firstname,String middlename,String lastname,String password) async {
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
        .collection('Users')
        .doc(did)
        .update({
        'url': updateUrl,
        'Address':address,
        'email':email,
        'firstname':firstname,
        'middlename':middlename,
        'lastname':lastname,
        'password':password

        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
    String name = firstname + "" + middlename + "" + lastname;
    Profile().updateEvent(name,did,updateUrl);
    Profile().updateFollowers(name, did, updateUrl);
    Profile().updateEventMembers(name, did, updateUrl);
    Profile().updateGroups(name, did, updateUrl);
    Profile().updateComments(name, did, updateUrl);

  }
  Future<dynamic> _profile() async{

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
          address = doc['address'],
          email = doc['emailAddress'],
          pass = doc['password'],
          url
          ];
          print(doc.id);

        });

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
              future: _profile(),
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                List<Widget> children;

                if(snapshot.hasData){
                  firstNameController.text = snapshot.data[0];
                  middleNameController.text = snapshot.data[1];
                  lastNameController.text = snapshot.data[2];
                  addressController.text = snapshot.data[3];
                  emailController.text = snapshot.data[4];
                  passwordController.text = snapshot.data[5];
                  confirmPasswordController.text = snapshot.data[5];
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
                      child: ElevatedButton(onPressed: (){
                        print(firstname);
                        _showChoiceDialog(context);
                      }
                          , child: Text("Upload")),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
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
                        controller: middleNameController,
                        decoration: InputDecoration(
                            labelText: "Middle Name"
                        ),

                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
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
                        controller: emailController,
                        decoration: InputDecoration(
                            labelText: "Email Address"
                        ),
                        validator: validateEmail,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: passwordController,
                        decoration: InputDecoration(
                            labelText: "Password"
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Password should not be empty.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        obscureText: true,
                        controller: confirmPasswordController,
                        decoration: InputDecoration(
                            labelText: "Confirm Password"
                        ),
                        validator: (value){
                          if(value == null || value.isEmpty){
                            return "Password should not be empty.";
                          }
                          else if(value != passwordController.text){
                            return "Password should match.";
                          }
                          return null;
                        },
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){
                            print(firstname);

                            uploadImageToFirebase(context,addressController.text,emailController.text,firstNameController.text,middleNameController.text,lastNameController.text,passwordController.text);

                            _profile();
                          }
                              , child: Text("Update")),
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
                            firstNameController.text = "";
                            middleNameController.text ="";
                            lastNameController.text = "";
                            addressController.text = "";
                            emailController.text = "";
                            passwordController.text = "";
                            confirmPasswordController.text = "";
                          }
                              , child: Text("Clear")),
                        )
                        ,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(

                                builder: (context) => feedScreen(),
                              ),
                            );
                          }
                              , child: Text("View Post")),
                        )
                        ,
                      ]
                      ,

                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(

                                builder: (context) => UsersGoalScreen(),
                              ),
                            );
                          }
                              , child: Text("Activities")),
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

                                builder: (context) => FollowerScreen(),
                              ),
                            );
                          }
                              , child: Text("Followers")),
                        )
                        ,
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(

                                builder: (context) => yourfriendScreen(),
                              ),
                            );
                          }
                              , child: Text("Following")),
                        )
                        ,
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