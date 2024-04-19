import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../flutter_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:video_player/video_player.dart';
import '../feeds/VideoPlayerApp.dart';
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
  var content;
  VideoPlayerController _controller;
  Timer timer;
  int counter = 0;
  Future feeds;
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      'https://flutter.github.io/assets-for-api-docs/assets/videos/bee.mp4',
      videoPlayerOptions: VideoPlayerOptions(mixWithOthers: true),)  ..initialize().then((_) {
      setState(() { });
      _controller.setLooping(true);
      _controller.initialize();
    });

    feeds = _feeds();
    //timer = Timer.periodic(Duration(seconds: 10), (Timer t) => _refresh());
  }
  Future<dynamic> _refresh()
  {
    setState(() {
      feeds = _feeds();
    });

  }
  Future<dynamic> _feeds() async{
    did =  await FlutterSession().get('id');
    List<dynamic> query;
    await FirebaseFirestore.instance
        .collection('Feeds')
        .where('userID',isEqualTo: did)
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
  Future<dynamic> _deletefeed(String feedID) async{


    await FirebaseFirestore.instance
        .collection('Feeds')
        .doc(feedID)
        .delete()
        .then((value) => print("User Deleted"))
        .catchError((error) => print("Failed to delete user: $error"));
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
                                                        padding: EdgeInsets.only(bottom:10,top:10),
                                                        child:Text(
                                                          snapshot.data[index]['post'],
                                                          textAlign: TextAlign.left,
                                                          overflow: TextOverflow.ellipsis,
                                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                                        ),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: ElevatedButton(onPressed: (){
                                                          _deletefeed(snapshot.data[index]['feedID']);
                                                          print(snapshot.data[index]['feedID']);
                                                          setState(() {
                                                            feeds = _feeds();
                                                          });
                                                        }

                                                            , child: Text("DELETE")
                                                          ,style:ElevatedButton.styleFrom(primary: Colors.red),
                                                        ),
                                                      ),
                                                    ]
                                                ),)

                                            ]),
                                      ),
                                    ),
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
                return Container(
                    margin: EdgeInsets.only(top:50),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[



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