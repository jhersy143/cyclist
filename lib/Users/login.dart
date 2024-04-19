import 'package:cyclista/main.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../home.dart';
import 'signup_screen.dart';
import '../flutter_session.dart';
import 'package:firebase_auth/firebase_auth.dart';
class MyLoginFormWidget extends StatefulWidget{
  @override
  MyLoginFormWidgetState createState(){
    return MyLoginFormWidgetState();
  }
}

class MyLoginFormWidgetState extends State<MyLoginFormWidget>{
  final _formKey = GlobalKey<FormState>();
  var session = FlutterSession();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

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

Future<dynamic> _users(String email,String pass) async{

  await FirebaseFirestore.instance
      .collection('Users')
      .where('emailAddress',isEqualTo: email)
      .where('password',isEqualTo: pass)
      .get()
      .then((QuerySnapshot querySnapshot) {

        if(querySnapshot.docs.isEmpty)
          {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('Wrong Username Or Password!'),
            ));

          }
        else
          {
            querySnapshot.docs.forEach((doc) {
              setState(() {
                var name = doc["firstname"]+" "+doc["middlename"]+" "+doc["lastname"];
                session.set("id", doc.id);
                session.set("profileurl", doc["url"]);
                session.set("name", name);
                session.set('feedtype', 'publicfeeds');
              });


            });

            Navigator.push(
                context,
            MaterialPageRoute(builder: (context)=>MyHome()));
          }

  });
}


  @override
  Widget build(BuildContext context){

    return Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    labelText: "Email"
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
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    if(_formKey.currentState.validate()){
                      //_read(emailController.text, passwordController.text);
                      _users(emailController.text,passwordController.text);


                    }

                  }
                      , child: Text("Login")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context)=>SignupScreen()));

                  }
                      , child: Text("Register")),
                ),
              ],
            )



            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: ElevatedButton(onPressed: (){
            //     Navigator.pop(context);
            //   }
            //       , child: Text("Back")),
            // )
          ],
        )
    );
  }
}