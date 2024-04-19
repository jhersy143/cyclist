import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';

// database table and column names
final String tableCustomer = 'customer';
final String columnId = 'id';
final String columnLastName = 'last_name';
final String columnFirstName = 'first_name';
final String columnEmail = 'email';
final String columnPassword = 'password';
final String columnpayment = 'payment';
final String columnduedate = 'duedate';

// data model class
class Customer {

  int id;
  String last_name;
  String first_name;
  String email;
  String password;
  String payment;
  String duedate;
  int count;
  Customer({this.id,this.last_name});

  // convenience constructor to create a Word object
  Customer.fromMap(Map<String, dynamic> map) {
    id = map[columnId];
    last_name = map[last_name];
    first_name = map[first_name];
    email = map[email];
    password = map[password];
    payment = map[payment];
  }
  // convenience method to create a Map from this Word object
  Map<String, dynamic> toMap() {
    var map = <String, dynamic>{
      columnLastName: last_name,
      columnFirstName: first_name,
      columnEmail: email,
      columnPassword: password,
      columnpayment: payment,
      columnduedate: duedate

    };
    if (id != null) {
      map[columnId] = id;
    }
    return map;
  }
}

// singleton class to manage the database
class DatabaseHelper {

  // This is the actual database filename that is saved in the docs directory.
  static final _databaseName = "Pawnshop.db";
  // Increment this version when you need to change the schema.
  static final _databaseVersion = 1;

  // Make this a singleton class.
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  // Only allow a single open connection to the database.
  static Database _database;
  Future<Database> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  // open the database
  _initDatabase() async {
    // The path_provider plugin gets the right directory for Android or iOS.
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);
    // Open the database. Can also add an onUpdate callback parameter.
    return await openDatabase(path,
        version: _databaseVersion,
        onCreate: _onCreate);
  }

  // SQL string to create the database
  Future _onCreate(Database db, int version) async {
    await db.execute('''
              CREATE TABLE $tableCustomer (
                $columnId INTEGER PRIMARY KEY,
                $columnLastName TEXT NOT NULL,
                $columnFirstName TEXT NOT NULL,
                $columnEmail TEXT NOT NULL,
                $columnPassword TEXT NOT NULL,
                $columnpayment NUMBER  NULL,
                $columnduedate DATE  NULL
              )
              ''');
    //await db.execute('''
            //  INSERT INTO  $tableCustomer (
              //  $columnId,
             //   $columnLastName ,
             //   $columnFirstName,
             //   $columnEmail,
             //   $columnPassword,
            //    $columnpayment,
             //   $columnduedate
//            //  values(?,?,?,?,?,?,?)
             // ''',
             // [1,"a","b","c","d","e","f"]
    //);
  }

  // Database helper methods:

  Future<int> insert(Customer customer) async {
    Database db = await database;
    int id = await db.insert(tableCustomer, customer.toMap());
    return id;
  }




  Future<int> updateData(Customer customer) async {
    var db = await this.database;
    var result = await db.update(tableCustomer, customer.toMap(), where: '$columnId  = ?', whereArgs: [customer.id]);
    return result;
  }
  Future<int> deleteData(int id) async {
    var db = await this.database;
    int result = await db.rawDelete('DELETE FROM $tableCustomer WHERE  $columnId  = $id');
    return result;
  }
  Future<Customer> queryAccount(String email, String password) async {
    Database db = await database;
    List<Map> maps = await db.query(tableCustomer,
        columns: [columnId, columnLastName, columnFirstName, columnEmail, columnPassword],
        where: '$columnEmail = ? AND $columnPassword = ?',
        whereArgs: [email, password]);
    if (maps.length > 0) {
      Customer customer = Customer();
      customer.last_name = maps.first["last_name"];
      customer.first_name = maps.first["first_name"];
      customer.email = maps.first["email"];
      customer.password = maps.first["password"];
      customer.payment = maps.first["payment"];
      customer.duedate = maps.first["duedate"];
      return customer;
    }
    return null;
  }
  Future<Customer> queryAccountone(int id) async {
    Database db = await database;
    List<Map> maps = await db.query(tableCustomer,
        columns: [columnId, columnLastName, columnFirstName, columnEmail, columnPassword],
        where: '$columnId = ?',
        whereArgs: [id]);
    if (maps.length > 0) {
      Customer customer = Customer();
      customer.last_name = maps.first["last_name"];
      customer.first_name = maps.first["first_name"];
      customer.email = maps.first["email"];
      customer.password = maps.first["password"];
      customer.payment = maps.first["payment"];
      customer.duedate = maps.first["duedate"];
      return customer;
    }
    return null;
  }


  Future<List<Customer>> queryAllCustomer() async {
    Database db = await database;
    List<Map> maps = await db.query(tableCustomer,
        columns: [columnId, columnLastName, columnFirstName, columnEmail, columnPassword],
        );
    if (maps.length > 0) {
      List<Customer> list_acct = [];

     for(int i = 0; i < maps.length; i++){
       Customer customer = Customer();
       customer.id = maps[i]["id"];
       customer.last_name = maps[i]["last_name"];
       customer.first_name = maps[i]["first_name"];
       customer.email = maps[i]["email"];
       customer.password = maps[i]["password"];
       list_acct.add(customer);
     }
      print(list_acct);
     return list_acct;
    }
    return null;
  }
  var fido = Customer(
    id:0,
    last_name:'jhersy',
  );

}