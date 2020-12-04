import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_3_dam/pages/control_agregar.dart';
import 'package:tarea_3_dam/services/firestore_service.dart';

class PersonajePage extends StatefulWidget {
  PersonajePage({Key key}) : super(key: key);

  @override
  _PersonajePageState createState() => _PersonajePageState();
}

class _PersonajePageState extends State<PersonajePage> {
  String email = '';
  String uid = '';
  @override
  void initState() {
    cargarDatosUser();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: StreamBuilder(
          stream: _fetch(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView.builder(
                itemCount: snapshot.data.documents.length,
                itemBuilder: (context, index) {
                  var control = snapshot.data.documents[index];
                  var dateFormat = new DateFormat('dd-MM-yyyy');
                  var fecha =
                      DateTime.parse(control['fecha'].toDate().toString());

                  return Card(
                    elevation: 5,
                    child: ListTile(
                      onLongPress: () {},
                      title: Text('Leyenda: ' + control['nombre'].toString()),
                      subtitle: Text('Raza: ' +
                          control['raza'].toString() +
                          '\n' +
                          'Ciudad de origen: ' +
                          control['capital'].toString() +
                          '\n' +
                          'Sexo: ' +
                          control['sexo'].toString() +
                          '\n' +
                          'Fecha Creacion: ' +
                          dateFormat.format(fecha) +
                          '\n' +
                          'Creador: ' +
                          control['creador'].toString()),
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFFCB8C34),
                        // backgroundImage: NetworkImage(''),
                        child: Text(
                          control['creador'].toString().substring(0, 2),
                          style: TextStyle(color: Colors.black),
                        ),
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          MdiIcons.trashCan,
                          color: Colors.amber,
                        ),
                        onPressed: () {
                          if (control['creador'].toString() ==
                                  email.toString() ||
                              email.toString() == 'administrador@admin.com') {
                            //validar que solo el usuario que creo pueda eliminar
                            // para mas placer habiamos colocado  ||
                            //email.toString() == 'administrador@admin.com' pero como no
                            //usara ese user lo quitamos
                            return showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text('Adventencia'),
                                  content:
                                      Text('Seguro?, borrara su personaje'),
                                  actions: [
                                    RaisedButton(
                                      child: Text('Confirmar'),
                                      onPressed: () {
                                        _borrarControl(control.documentID);
                                        Navigator.of(context).pop();
                                      },
                                      color: Colors.black,
                                    ),
                                    MaterialButton(
                                      child: Text('Cancelar'),
                                      onPressed: () {
                                        Navigator.of(context).pop();
                                      },
                                      color: Colors.red,
                                    )
                                  ],
                                );
                              },
                            );
                            // _borrarControl(control.documentID);
                          } else {
                            return _showMyDialog();
                          }
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
        floatingActionButton: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.only(left: 25),
          child: RaisedButton(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            child:
                Text('Agregar Leyenda', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => ControlAgregar())),
            color: Color(0xFFD0A85C),
            elevation: 5.0,
          ),
        ));
  }

  _borrarControl(String idControl) {
    FirestoreService().borrarControl(idControl);
  }

  Future<void> cargarDatosUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getStringList('user')[0];
      email = sp.getStringList('user')[1];
    });
  }

  Stream<QuerySnapshot> _fetch() {
    return FirestoreService().leyenda();
  }

  // _mostarConfirm(BuildContext context) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text('Adventencia'),
  //         content: Text('Borrara su personaje'),
  //         actions: [
  //           RaisedButton(
  //             child: Text('Confirmar'),
  //             onPressed: () {
  //               _borrarControl(control.documentID);
  //             },
  //             color: Colors.black,
  //           ),
  //           MaterialButton(
  //             child: Text('Cancelar'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //             color: Colors.red,
  //           )
  //         ],
  //       );
  //     },
  //   );
  // }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      barrierColor: Colors.red,
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'AVISO!',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'Solo se le permite borrar sus propias creaciones o ser administrador',
                    textAlign: TextAlign.center),
                Text(
                  'Entendio el mensaje?',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(right: 120),
              child: FlatButton(
                child: Text('Ok'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ),
          ],
        );
      },
    );
  }
}
