import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class Profile
{

  Future updateEvent(String name,String userID,String profilePic) async{
    await FirebaseFirestore.instance
        .collection('Events')
        .where('userID',isEqualTo: userID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) async{
          await FirebaseFirestore.instance
              .collection('Events')
              .doc(doc.id)
              .update({
            'profile': profilePic,
            'name':name,


          })
              .then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));

        });

      }

    });


  }
  Future updateComments(String name,String userID,String profilePic) async{
    await FirebaseFirestore.instance
        .collection('Comments')
        .where('userID',isEqualTo: userID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) async{
          await FirebaseFirestore.instance
              .collection('Comments')
              .doc(doc.id)
              .update({
            'userurl': profilePic,
            'usersname':name,


          })
              .then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));

        });

      }

    });


  }
  Future updateFollowers(String name,String userID,String profilePic) async{
    await FirebaseFirestore.instance
        .collection('Followers')
        .where('userID',isEqualTo: userID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) async{
          await FirebaseFirestore.instance
              .collection('Followers')
              .doc(doc.id)
              .update({
            'userurl': profilePic,
            'usersname':name,


          })
              .then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));

        });

      }

    });


  }
  Future updateEventMembers(String name,String userID,String profilePic) async{
    await FirebaseFirestore.instance
        .collection('EventsMembers')
        .where('userID',isEqualTo: userID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) async{
          await FirebaseFirestore.instance
              .collection('EventsMembers')
              .doc(doc.id)
              .update({
            'profile': profilePic,
            'name':name,


          })
              .then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));

        });

      }

    });


  }
  Future updateGroups(String name,String userID,String profilePic) async{
    await FirebaseFirestore.instance
        .collection('Groups')
        .where('userID',isEqualTo: userID)
        .get()
        .then((QuerySnapshot querySnapshot) {
      if(querySnapshot.docs.isEmpty)
      {


      }
      else
      {

        querySnapshot.docs.forEach((doc) async{
          await FirebaseFirestore.instance
              .collection('Groups')
              .doc(doc.id)
              .update({

            'name':name,


          })
              .then((value) => print("User Updated"))
              .catchError((error) => print("Failed to update user: $error"));

        });

      }

    });


  }
}