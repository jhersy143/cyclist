import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../flutter_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'newpost_screen.dart';
import 'package:video_player/video_player.dart';
import 'VideoPlayerApp.dart';
import 'dart:async';
import 'dart:convert';
class MyfeedFormWidget extends StatefulWidget{
  @override
  MyfeedFormWidgetState createState(){
    return MyfeedFormWidgetState();
  }
}

class MyfeedFormWidgetState extends State<MyfeedFormWidget>{
List<dynamic> list ;
dynamic did;
dynamic gid;
var content;
VideoPlayerController _controller;
Timer timer;
int counter = 0;
Future feeds;
var feedtype;
var profileurl;
var name;
var url;
TextEditingController chatController = TextEditingController();
void initState() {
  super.initState();

  _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
    videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),)  ..initialize().then((_) {
    setState(() { });
    _controller.setLooping(true);
    _controller.initialize();
  });
  _feedtype();


  //timer = Timer.periodic(Duration(seconds: 10), (Timer t) => _refresh());
}
Future<dynamic> _addcomment(String message,String feedID)async{
  did =  await FlutterSession().get('id');
  profileurl =  await FlutterSession().get('profileurl');
  name =  await FlutterSession().get('name');
  await FirebaseFirestore.instance
      .collection('Comments')
      .add({'userurl': profileurl,
    'username':name,
    'userID':did,
    'datetime':DateTime.now(),
    'feedID':feedID,
    'comment':message

  })
      .then((value) => chatController.text="")
      .catchError((error) => print("Failed to update user: $error"));
}
Future<dynamic> _feedtype()async
{
  feedtype =   await FlutterSession().get('feedtype');
  setState(() {
    if(feedtype == "groupfeeds"){
      feeds= _groupfeeds();
    }
    else{
      feeds=_feeds();
    }
  });
print(feedtype);
}
Widget _comments(String feedID){
  return FutureBuilder<dynamic>(
      future: _SelectComments(feedID),
      builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
        var com;
        if(snapshot.hasData){


          com =
              Flexible(

                child: ListView.builder(
                    itemCount:   snapshot.data.length,
                    itemBuilder: (BuildContext context, int index){
                      if(snapshot.data[index]['userurl'].toString()==""){
                        url = 'https://firebasestorage.googleapis.com/v0/b/cyclista-f4d3b.appspot.com/o/profilepic%2Fdefault.jpg?alt=media&token=ddda3cd3-47af-4878-8584-006f2f6c74dd';
                      }
                      else{
                        url  = snapshot.data[index]['userurl'];
                      }

                      return  Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 80,
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            color: Colors.white,
                            elevation: 1,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,

                              children: [

                                ListTile(
                                  leading: Padding(
                                    padding: EdgeInsets.only(
                                        bottom: 10, top: 10, right: 10, left: 10),
                                    child: Container(
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
                                  title: Text(snapshot.data[index]['username']),

                                  subtitle: Text(snapshot.data[index]['comment']),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );

                    }),
              );


        }

        else {
          com =  Text('');


        }

        return   Container(
            height: 200,
            margin: EdgeInsets.only(top:10),
            child: Column(
              //crossAxisAlignment: CrossAxisAlignment.center,
              //mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[


                com ],)
        );
      }
  );
}

Future<dynamic> _groupfeeds() async{
  gid =  await FlutterSession().get('gid');
  List<dynamic> query;
  await FirebaseFirestore.instance
      .collection('GroupFeeds')
      .where("groupID",isEqualTo: gid)
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
Future<dynamic> _SelectComments(String feedID) async{

  List<dynamic> query;
  await FirebaseFirestore.instance
      .collection('Comments')
      .where('feedID',isEqualTo:feedID)
      .orderBy('datetime',descending: true)
      .get()
      .then((QuerySnapshot querySnapshot) {
    if(querySnapshot.docs.isEmpty)
    {


    }
    else
    {

      query =  querySnapshot.docs.map((doc) =>doc.data()).toList();
      print(query);
    }

  });


  return query;
}
Future<dynamic> _feeds() async{
  did =  await FlutterSession().get('id');
  List<dynamic> query;
  await FirebaseFirestore.instance
      .collection('Feeds')
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

  @override
  Widget build(BuildContext context){

    return

       Center(
        child: FutureBuilder<dynamic>(
           future: feeds,
          builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          var list;
          if(snapshot.hasData){

            list = Flexible(

              child: ListView.builder(
                  itemCount:   snapshot.data.length,
                  itemBuilder: (BuildContext context, int index){

                    if(snapshot.data[index]['filetype']=='image')
                    {
                     content =  Image.network(snapshot.data[index]['url'].toString());
                    }
                    else{



                      content =  VideoPlayerScreen(url:snapshot.data[index]['url'].toString());
                    }

                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(

                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          color:  Colors.white,
                          elevation: 3,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,

                            children: [
                              Container(
                                width: 350,
                                margin: EdgeInsets.only(bottom:30),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                child:
                                 Card(
                                  semanticContainer: true,
                                  shape:RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(15.0),
                                  ),

                                  child:Column(
                                      children: <Widget>
                                      [
                                        Container(
                                          width:350,
                                          child:
                                          Row(
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              crossAxisAlignment: CrossAxisAlignment.center,
                                              children: <Widget>
                                              [
                                                Padding(
                                                  padding: EdgeInsets.only(bottom:10,top:10,right: 10,left:10),
                                                  child:   Container(
                                                    width: 50,
                                                    height: 50,
                                                    decoration: BoxDecoration(
                                                      shape: BoxShape.circle,
                                                      image: DecorationImage(
                                                          image: NetworkImage(snapshot.data[index]['profile'].toString()),
                                                          fit: BoxFit.fill
                                                      ),
                                                    ),
                                                  ),
                                                ),

                                                Padding(
                                                  padding: EdgeInsets.only(bottom:10,top:10),
                                                  child:Text(
                                                    snapshot.data[index]['name'],
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ]
                                          ),

                                        ),
                                        content,

                                        Container(
                                          width:350,
                                          child: Column(
                                              crossAxisAlignment: CrossAxisAlignment.start,
                                              mainAxisAlignment: MainAxisAlignment.start,
                                              children:[
                                                Padding(
                                                  padding: EdgeInsets.only(right:20,bottom:20,top:10),
                                                  child:Text(
                                                    snapshot.data[index]['post'],
                                                    textAlign: TextAlign.left,
                                                    overflow: TextOverflow.ellipsis,
                                                    style: const TextStyle(fontWeight: FontWeight.bold),
                                                  ),
                                                ),
                                              ]
                                          ),),


                                      ]),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Container(
                                    width: 200,
                                    child: TextFormField(
                                      maxLines: 2,
                                      enabled: true,

                                      controller: chatController,
                                      decoration: InputDecoration(
                                          labelText: "Comment"
                                      ),

                                    ),),
                                  Padding(
                                    padding: const EdgeInsets.all(3.0),
                                    child: IconButton(
                                      iconSize: 30.0,
                                      icon: Icon(Icons.send,color: Colors.blueAccent,
                                      ),
                                      onPressed: () {

                                        _addcomment(chatController.text, snapshot.data[index]['feedID']);

                                      },

                                    ),
                                  ),
                                ],
                              ),
                              Padding(padding: const EdgeInsets.only(top:10.0),)
                              ,
                              _comments(snapshot.data[index]['feedID']),
                            ],

                          ),
                        ),
                      ),
                    );

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
            return Container(
            margin: EdgeInsets.only(top:50),
            child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[

              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(onPressed: (){
                  _controller.pause();
                Navigator.push(context,
                MaterialPageRoute(builder: (context)=>NewPostScreen(),
                )
                ) ;

                }

                    , child: Text("New Post")),
              ),

                list,



            ]

            )

            );
                }

                )



    )
      ;
  }
@override
void dispose() {
  _controller.dispose();
  super.dispose();
}
}