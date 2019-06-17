import 'dart:async';
import 'package:flutter_sqlite_1/Model/Contact.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io' as io;
import 'package:path/path.dart';

class DBHelper{

  final String TABLE_NAME = "Contact";
  static Database db_instance;

  Future<Database> get db async{
    if (db_instance == null)
      db_instance = await initDB();
    return db_instance;

  }

  initDB() async {
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory ();
    String path = join(documentsDirectory.path, "Contactstest.dv");
    var db = await openDatabase(path,version: 1 ,onCreate: oneCreateFunc);
    return db;
  }


  void oneCreateFunc(Database db, int version) async {
    //Crea la tabla
    await db.execute('CREATE TABLE $TABLE_NAME(id INTEGER  PRIMARY KEY AUTOINCREMENT,name TEXT ,phone TEXT);' );
  }

  Future<List<Contact>> getContacts() async {
    var db_Connection = await db;
    List<Map> list = await db_Connection.rawQuery('SELECT * FROM $TABLE_NAME');
    List<Contact> contacts = new List();
    for (int i = 0; i< list.length; i++)
      {
        Contact contact = new Contact();
        contact.id = list[i]['id'];
        contact.name = list[i]['name'];
        contact.phone = list[i]['phone'];

        contacts.add(contact);
      }
      return contacts;
  }
  //añade contacto
  void addNewContact(Contact contact) async{
    var db_connection = await db;
    String query ='INSERT INTO $TABLE_NAME(name,phone) VALUES (\'${contact.name}\',\'${contact.phone}\')';
    await db_connection.transaction((transaction) async{
      return await transaction.rawInsert(query);
    });


  }
  //actualiza contacto
  void updateContact(Contact contact) async {
    var db_connection = await db;
    String query ='UPDATE $TABLE_NAME SET name=\'${contact.name}\',phone=\'${contact.phone}\'WHERE id = ${contact.id}';
    await db_connection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }
  // borra contacto
  void deleteContact(Contact contact) async {
    var db_connection = await db;
    String query ='DELETE FROM $TABLE_NAME WHERE id=${contact.id}';
    await db_connection.transaction((transaction) async{
      return await transaction.rawQuery(query);
    });
  }

}

//CRUD Function
// GET Contacts



