import 'package:cyclista/Events/event_screen.dart';
import 'package:cyclista/Events/map_screen.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
//import '../sample.dart';
import '../flutter_session.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'addevent_screen.dart';
import 'viewevent_screen.dart';
import '../flutter_session.dart';
import 'package:weather/weather.dart';
import 'userlist_screen.dart';
class weatherFormWidget extends StatefulWidget{
  @override
  weatherFormWidgetState createState(){
    return weatherFormWidgetState();
  }
}

class weatherFormWidgetState extends State<weatherFormWidget>{
  List<dynamic> list ;
  dynamic did;
  var session = FlutterSession();
  var data;
  var city;
  List<dynamic> weatherlist;
  TextEditingController searchController = TextEditingController();
  WeatherFactory wf = new WeatherFactory("f397a4a6917cd65c495a7cad4507572d");
  initState() {
   city = "";
     super.initState();
  }
  Future<dynamic> _weather(String city) async{
    Weather forecast = await wf.currentWeatherByCityName(city);
    weatherlist = forecast.toList();
    return weatherlist;
  }
  void changCIty(){
    setState(() {
      city = searchController.text;
    });
  }
  @override
  Widget build(BuildContext context){
    return

      Center(
          child: FutureBuilder<dynamic>(
              future: _weather(city),
              builder:(BuildContext context, AsyncSnapshot<dynamic> snapshot) {
                var list;

                if(snapshot.hasData){
                  print(snapshot.data[0]);
                  list = Flexible(

                    child: ListView.builder(
                        itemCount:   1,
                        itemBuilder: (BuildContext context, int index){
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child:

                            Container(

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

                                      margin: EdgeInsets.only(bottom:30),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child:

                                      ListTile(

                                        title:
                                        Column(
                                            children: <Widget>
                                            [
                                              Container(

                                                child:
                                                Column(
                                                    mainAxisAlignment: MainAxisAlignment.start,

                                                    children: <Widget>
                                                    [


                                                        Text(

                                                          'PLACE: '+snapshot.data[0].toString(),
                                                          textAlign: TextAlign.justify,
                                                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                                                        ),



                                                        Text(

                                                          'WEATHER: '+snapshot.data[1].toString(),
                                                          textAlign: TextAlign.justify,
                                                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                                                        ),

                                                        Text(

                                                          'DESCRIPTION: '+snapshot.data[2].toString(),
                                                          textAlign: TextAlign.justify,
                                                          style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                                                        ),
                                                      Text(

                                                        'TEMPERATURE: '+snapshot.data[3].toString(),
                                                        textAlign: TextAlign.justify,
                                                        style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 14),
                                                      ),
                                                      Padding(
                                                        padding: const EdgeInsets.all(8.0),
                                                        child: ElevatedButton(onPressed: (){
                                                          session.set('PLACE', 'PLACE: '+snapshot.data[0].toString());
                                                          session.set('WEATHER', 'WEATHER: '+snapshot.data[1].toString());
                                                          session.set('DESCRIPTION',  'DESCRIPTION: '+snapshot.data[2].toString());
                                                          session.set('TEMPERATURE',  'TEMPERATURE: '+snapshot.data[3].toString(),);

                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(

                                                              builder: (context) => userlistScreen(),
                                                            ),
                                                          ).then(
                                                                  (value) { setState(() {

                                                                  });});
                                                          //_profile();
                                                        }
                                                            , child: Text("Send")),
                                                      ),
                                                    ]
                                                ),

                                              ),




                                            ]),



                                      ),),
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

                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: TextFormField(

                              controller: searchController,
                              decoration: InputDecoration(
                                  labelText: "Search"
                              ),
                              validator: (value){
                                if(value == null || value.isEmpty){
                                  return "should not be empty.";
                                }
                                return null;
                              },
                            ),
                          ),

                          ElevatedButton(onPressed: (){
                            changCIty();
                          }
                              , child: Text("Search")),
                          list,



                        ]

                    )

                );
              }

          )



      )
    ;
  }
}