import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../home.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MySignupFormWidget extends StatefulWidget{
  @override
  MySignupFormWidgetState createState(){
    return MySignupFormWidgetState();
  }
}

class MySignupFormWidgetState extends State<MySignupFormWidget>{
  final _formKey = GlobalKey<FormState>();
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

  void _signup() async{
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
    var doc =  FirebaseFirestore.instance.collection('Users').doc();
    await FirebaseFirestore.instance
        .collection('Users')
        .doc(doc.id)
        .set({'firstname': firstNameController.text,
      'middlename': middleNameController.text,
      'lastname': lastNameController.text,
      'address': addressController.text,
      'emailAddress': emailController.text,
      'password': passwordController.text,
      'userStatus': "Active",
      'dateCreated': DateTime.now(),
      'userID':doc.id,
      'url':""
    }
    ).then((value) =>  Navigator.pushReplacement(context,
      MaterialPageRoute(builder: (context)=>LoginScreen()),
    ));

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text('Successfully Registered!'),
    ));

  }

  @override
  Widget build(BuildContext context){
    return
      SingleChildScrollView(
        child:Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            ),  Padding(
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
            ),   Padding(
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
                    if(_formKey.currentState.validate()){
                      _signup();
                    }
                  }
                      , child: Text("Register")),
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
                    Navigator.pushReplacement(context,
                    MaterialPageRoute(builder: (context)=>LoginScreen()),
                    );
                  }
                      , child: Text("Login")),
                ),
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
                ),

              ],
            ),

          ],
        )
    ),
      );
  }
}