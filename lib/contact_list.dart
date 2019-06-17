
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:async';
import 'package:flutter/material.dart';
import 'Database/DBhelper.dart';
import 'Model/Contact.dart';
Future<List<Contact>> getContactsFromDB () async{

  var dbHelper = DBHelper();
  Future<List<Contact>> contacts = dbHelper.getContacts();
  return contacts;

}
class MyContactList extends StatefulWidget{


  @override
  State<StatefulWidget> createState() => new MyContactListState();


}

class MyContactListState extends State<MyContactList>{
  //controlador para actualizar nombre y telefono
  final controller_name = new TextEditingController();
  final controller_phone = new TextEditingController();

  @override
  Widget build(BuildContext context) {

    return new Scaffold(
      appBar: AppBar(
        title: Text('Lista de contactos'),
      ),
      body: new Container(
        padding: EdgeInsets.all(16.0),
        child: FutureBuilder<List<Contact>>(
          future: getContactsFromDB(),
          builder: (context,snapshot){
            if (snapshot.data != null)
              {
                if (snapshot.hasData)
                  {
                    return ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context,index){
                          return new Row(
                            children: <Widget>[

                              Expanded(
                                child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container (
                                      padding: const EdgeInsets.only(bottom:8.0),
                                      child: Text(
                                        snapshot.data[index].name,
                                        style: TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Text(
                                      snapshot.data[index].phone,
                                      style: TextStyle(color:Colors.blueGrey[500]),
                                      ),
                                  ],),
                              ),
                            //creamos update y delate bottom
                              GestureDetector(
                                onTap: (){
                                  //cuadro de dialogo para actualizar
                                  showDialog(context: context,builder: (_)=> new AlertDialog(contentPadding: const EdgeInsets.all(16.0),
                                  content: new Row(
                                    children: <Widget>[
                                      Expanded(
                                        child:Column(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: <Widget>[
                                            TextFormField(
                                        autofocus: true,
                                        decoration: InputDecoration(
                                            hintText: '${snapshot.data[index].name}'),
                                        controller: controller_name,
                                      ),
                                            TextFormField(
                                              autofocus: false,
                                              decoration: InputDecoration(
                                                  hintText: '${snapshot.data[index].phone}'),
                                              controller: controller_phone,
                                            )
                                          ],
                                        ))
                                    ],
                                  ),
                                  actions: <Widget>[
                                    new FlatButton(onPressed: (){

                                      Navigator.pop(context);
                                    }, child:Text('Cancelar')),
                                    new FlatButton(onPressed: (){
                                      var dbHelper = DBHelper();
                                      Contact contact = new Contact();
                                      contact.id = snapshot.data[index].id;// guarda el id de la lista de contactos
                                      // si el textfiel name es vacio guardara el valor antiguo
                                      contact.name =
                                          controller_name.text !=''?controller_name.text:snapshot.data[index].name;
                                      contact.phone =
                                      controller_phone.text !=''?controller_phone.text:snapshot.data[index].phone;
                                      //actualizar
                                      dbHelper.updateContact(contact);
                                      Navigator.pop(context);
                                      setState(() {
                                        getContactsFromDB(); //refresca la información
                                      });
                                      Fluttertoast.showToast(msg: 'Contacto actualizado',toastLength:Toast.LENGTH_SHORT,);
                                      },
                                        child:Text('Actualizar')),
                                  ],
                                  ));
                                },
                                child: Icon(Icons.update, color: Colors.red),
                              ),
                              GestureDetector(
                                onTap: (){
                                  var dbHelper = DBHelper();
                                  dbHelper.deleteContact(snapshot.data[index]);
                                  Fluttertoast.showToast(msg: 'El contacto fue eliminado',toastLength:Toast.LENGTH_SHORT);
                                  setState(() {
                                    getContactsFromDB(); //refresca la información
                                  });
                                },
                                child: Icon(Icons.delete,color: Colors.red),
                              ),
                              new Divider(),
                            ],
                          );

                        });
                  }
                        else if (snapshot.data.length == 0)
                          return Text('No hay datos');
              }
            //muestra pantalla de carga mientras no se tiene informacion
            return new Container(
              alignment: AlignmentDirectional.center,
              child: new CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
  }
}