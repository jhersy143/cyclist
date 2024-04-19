import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cyclista/database_helper.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cyclista/customer_list_screen.dart';


class MyUpdateFormWidget extends StatefulWidget{
  final int cust;

  const MyUpdateFormWidget({Key key, this.cust}) : super(key: key);
  MyUpdateFormWidgetState createState(){

    return MyUpdateFormWidgetState(this.cust);
  }
}

class MyUpdateFormWidgetState extends State<MyUpdateFormWidget>{
  final int cust;
  MyUpdateFormWidgetState(this.cust);
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _readAll(cust));
  }
  final _formKey = GlobalKey<FormState>();
  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  Customer customers;

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

  _write({int id , String first_name, String last_name, String email, String password}) async{
    Customer acct = Customer();
    acct.id = id;
    acct.last_name = last_name;
    acct.first_name = first_name;
    acct.email = email;
    acct.password = password;

    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.updateData(acct);

  }
  _delete({int id }) async{

    DatabaseHelper helper = DatabaseHelper.instance;
    await helper.deleteData(id);

  }
  _readAll(int cust) async {
    DatabaseHelper helper = DatabaseHelper.instance;
    customers = await helper.queryAccountone(cust);
    setState(() {

      if(customers == null){
        print("No account available in the database.");
      }
      else{
        print("${customers.first_name}");
      }
    });

  }
  @override
  Widget build(BuildContext context){
    firstNameController.text='${customers.first_name}';
    lastNameController.text='${customers.last_name}';
    emailController.text='${customers.email}';
    passwordController.text='${customers.password}';
    confirmPasswordController.text='${customers.password}';
    return Form(
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
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Saving your account...")));
                      _write(id:cust,first_name: firstNameController.text, last_name: lastNameController.text, email: emailController.text, password: passwordController.text);
                    }
                  }
                      , child: Text("Update")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(onPressed: (){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deleting your account...")));
                    _delete(id:cust);
                  }

                      , child: Text("Delete")),
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
                    lastNameController.text = "";
                    emailController.text = "";
                    passwordController.text = "";
                    confirmPasswordController.text = "";
                  }
                      , child: Text("Clear")),
                )
              ],
            ),

          ],
        )
    );
  }
}