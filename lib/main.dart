import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'Database/DBhelper.dart';
import 'Model/Contact.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'contact_list.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  Contact contact = new Contact ();
  String name,phone;

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final formKey = new GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new Scaffold(
      key: scaffoldKey,
      appBar: new AppBar(
        title: Text('Crea un nuevo contacto'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.view_list),
            tooltip: 'Ver lista',
            onPressed: (){
              startContactList();
            },
          )
        ],
      ),
      body: new Padding(padding: const EdgeInsets.all(16.0),
      child: new Form(
        key:formKey,
        child: new Column(
          children: <Widget>[
            TextFormField(
              keyboardType: TextInputType.text ,
              decoration: new InputDecoration(labelText: 'Nombre'),
              validator: (val)=> val.length == 0 ?"Introduce tu nombre":null,
              onSaved:  (val)=> this.name = val,

            ),
            TextFormField(
              keyboardType: TextInputType.text ,
              decoration: new InputDecoration(labelText: 'Telefono'),
              validator: (val)=> val.length == 0 ?"Introduce tu telefono":null,
              onSaved:  (val)=> this.phone = val,

            ),
            new Container(
              margin: const EdgeInsets.only(top:10.0),
              child: new RaisedButton(onPressed: submitContact,child: Text('Crea un nuevo contacto'),
              ),
            )
          ],
        ),

    ),)
    );
  }

  void startContactList() {
  //muestra en una nueva vista la lista de contactos
    Navigator.push(context, new MaterialPageRoute(builder: (context)=> new MyContactList()));
  }

  
  void submitContact() {
      if(this.formKey.currentState.validate())
        {
          formKey.currentState.save();

        }else
          {
            return null;
          }
      var contact = Contact();
      contact.name = name;
      contact.phone = phone;
      var dbHelper = DBHelper ();
      dbHelper.addNewContact(contact);
      Fluttertoast.showToast(msg: 'El contacto fue guardado',toastLength:Toast.LENGTH_SHORT,);


  }
}

