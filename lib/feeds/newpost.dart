import 'dart:ffi';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import '../flutter_session.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'videopost.dart';
class NewPostWidget extends StatefulWidget{
  @override
  NewPostWidgetState createState(){
    return NewPostWidgetState();
  }
}

class NewPostWidgetState extends State<NewPostWidget>{
  @override

  //VideoPlayerController _controller;
  final _formKey = GlobalKey<FormState>();
  var firstname;
  var middlename;
  var lastname;
  var address;
  var email;
  var pass;
  var url;
  var updateUrl;
  var filetype;
  dynamic did;
  var session = FlutterSession();
  var videopost;
  PickedFile imageFile;
  var  pickedFile;
  var feedtype;
  var gid;
  TextEditingController postController = TextEditingController();
  void initState() {
    super.initState();
    //_controller;
    //WidgetsBinding.instance.addPostFrameCallback((_) =>  _profile());

    url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
    filetype = "image";

  }

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
  Future groupUpload(BuildContext context,String post,
      String userID,String profileurl,String name,String filetype) async {
    gid =  await FlutterSession().get('gid');

    String fileName = basename(imageFile.path);
    FirebaseStorage firebaseStorageRef =  FirebaseStorage.instance;
    UploadTask uploadTask =  firebaseStorageRef.ref().child('profilepic/$fileName').putFile(File(imageFile.path));

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    updateUrl = await taskSnapshot.ref.getDownloadURL();
    print(updateUrl);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
    );
    var doc = FirebaseFirestore.instance.collection('Feeds').doc();
    await FirebaseFirestore.instance
        .collection('GroupFeeds')
        .doc(doc.id)
        .set({'url': updateUrl,
      'post':post,
      'userID':userID,
      'profile':profileurl,
      'name':name,
      'filetype':filetype,
      'feedID':doc.id,
      'groupID':gid

    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future uploadImageToFirebase(BuildContext context,String post,
      String userID,String profileurl,String name,String filetype) async {
    String fileName = basename(imageFile.path);
    FirebaseStorage firebaseStorageRef =  FirebaseStorage.instance;
    UploadTask uploadTask =  firebaseStorageRef.ref().child('profilepic/$fileName').putFile(File(imageFile.path));

    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);
    updateUrl = await taskSnapshot.ref.getDownloadURL();
    print(updateUrl);
    taskSnapshot.ref.getDownloadURL().then(
          (value) => print("Done: $value"),
    );
    var doc = FirebaseFirestore.instance.collection('Feeds').doc();
    await FirebaseFirestore.instance
        .collection('Feeds')
        .doc(doc.id)
        .set({'url': updateUrl,
              'post':post,
              'userID':userID,
              'profile':profileurl,
              'name':name,
              'filetype':filetype,
              'feedID':doc.id

        })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  Future<dynamic> _newpost(String name) async{
    var feedtype = await session.get('feedtype');
    if(feedtype == "groupfeeds"){
      groupUpload(this.context,postController.text,did,url,name,filetype);
    }
    else{
      uploadImageToFirebase(this.context,postController.text,did,url,name,filetype);


    }
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


          query = [firstname = doc['firstname'],
            middlename = doc['middlename'],
            lastname = doc['lastname'],
            address = doc['lastname'],
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
      filetype = "image";
      imageFile = pickedFile;
    });
    Navigator.pop(context);
  }
  void _openGallery(BuildContext context)  async{
    final  pickedFile = await ImagePicker().getImage(
      source: ImageSource.gallery ,
    );
    setState(() {
      filetype = "image";
      imageFile = pickedFile;
    });
    Navigator.pop(context);
  }

  void _openVideo(BuildContext context)  async{
    final  pickedFile = await ImagePicker().getVideo(
      source: ImageSource.gallery ,
    );


    setState(() {
      if(pickedFile!=null){
        filetype = "video";
        imageFile = pickedFile;
        videopost = VideoPost(imageFile:imageFile);
      }


    });

    Navigator.pop(context,
        MaterialPageRoute(
        builder: (context) => NewPostWidget(),
    ),
    );
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
                  _openVideo(context);
                },
                title: Text("Video"),
                leading: Icon(Icons.play_circle,color: Colors.blue,),
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
  Future newport(String firstname,String middlename,String lastname,String post) async {
    did =  await FlutterSession().get('id');
    await FirebaseFirestore.instance
        .collection('Feeds')
        .add({
      'url': updateUrl,
      'firstname':firstname,
      'middlename':middlename,
      'lastname':lastname,
      'post':post,
      'dateCreated':DateTime.now(),

    })
        .then((value) => print("User Updated"))
        .catchError((error) => print("Failed to update user: $error"));
  }
  @override
  void dispose() {
    super.dispose();
    pickedFile.dispose();
    filetype = "image";
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
                var fileViewer;
                if(filetype == "image")
                {
                  fileViewer = imageFile==null? Image.network(url.toString(), width: 350,
                      height: 300,
                      fit: BoxFit.fitWidth): Image.file(File(imageFile.path),width: 350,
                      height: 300,
                      fit: BoxFit.fitWidth);
                }
                if(filetype == "video")
                {
                    fileViewer =  videopost;
                }

                children = [
                 fileViewer,


                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(onPressed: (){
                      setState(() {
                        videopost = Image.network(url.toString(), width: 350,
                            height: 300,
                            fit: BoxFit.fitWidth);


                      });
                      print(firstname);
                      _showChoiceDialog(context);
                    }
                        , child: Text("Upload")),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      controller: postController,
                      maxLines: 6,
                      decoration: InputDecoration(
                          labelText: "Post"
                      ),
                      validator: (value){
                        if(value == null || value.isEmpty){
                          return "Post should not be empty.";
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
                          String name = firstname +" "+middlename+" "+lastname;
                          _profile();
                          _newpost(name);
                        }
                            , child: Text("Post")),
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
                          postController.text = "";

                        }
                            , child: Text("Clear")),
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