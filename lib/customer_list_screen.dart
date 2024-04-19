import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


import 'package:cyclista/main.dart';
import 'database_helper.dart';

class CustomerListScreen extends StatelessWidget{
  @override


  Widget build(BuildContext context) {
    // TODO: implement build

    return Scaffold(
      appBar: AppBar(
        title: Text("Account List"),
      ),
      body: MyCustomerListWidget(

      ),
    );

  }
}

class MyCustomerListWidget extends StatefulWidget{

MyCustomerListWidgetState createState(){
  return MyCustomerListWidgetState();

}

}

class MyCustomerListWidgetState extends State<MyCustomerListWidget>{

  final _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  List<Customer> customers = <Customer>[];
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

  _readAll() async {
    DatabaseHelper helper = DatabaseHelper.instance;
    customers = await helper.queryAllCustomer();
    setState(() {

      if(customers == null){
        print("No account available in the database.");
      }
      else{
        print("${customers.length}");
      }
    });

  }

  @override
  Widget build(BuildContext context){
    int count;
    if(customers == null){
      count = 0;
    }
    else{
      count = customers.length;
    }

    return Form(

        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
          Flexible(

              child: ListView.builder(
                  itemCount: count,

                  itemBuilder: (BuildContext context, int index){
                return Padding(


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
                          ListTile(
                            leading: Icon(Icons.person, size: 40,),
                            title: Text('${customers[index].first_name} ${customers[index].last_name}'),
                            subtitle: Text('${customers[index].email}'),
                            onTap: () {  ;},
                          )
                        ],
                      ),
                    ),
                  ),
                );
                //${accounts[index].first_name}
              }),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){
                _readAll();
              }
                  , child: Text("Get Data")),
            ),
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

