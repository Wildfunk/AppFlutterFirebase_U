import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:tarea_3_dam/pages/control_agregar_region.dart';
import 'package:tarea_3_dam/services/firestore_service.dart';

class RegionPage extends StatefulWidget {
  RegionPage({Key key}) : super(key: key);

  @override
  _RegionPageState createState() => _RegionPageState();
}

class _RegionPageState extends State<RegionPage> {
  String regionombre = '';
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

                  return Card(
                    elevation: 10,
                    child: ListTile(
                      title: Text('Villa:' +
                          control['nombre'].toString() +
                          '\n' +
                          'Region:' +
                          control['region'].toString()),
                      subtitle: Text('poblacion: ' +
                          control['poblacion'].toString() +
                          ' habitantes'),
                      leading: Icon(
                        MdiIcons.earth,
                        color: Colors.green,
                        size: 40,
                      ),
                      trailing: IconButton(
                        icon: Icon(
                          MdiIcons.trashCan,
                          color: Colors.red,
                        ),
                        onPressed: () {
                          return showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: Text('Adventencia'),
                                content: Text('Borrara una region'),
                                actions: [
                                  RaisedButton(
                                    child: Text('Confirmar'),
                                    onPressed: () {
                                      _borrarRegionControl(control.documentID);
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
                          // _borrarRegionControl(control.documentID);
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
            child: Text('Agregar Villa', style: TextStyle(color: Colors.black)),
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ControlAgregarRegion())),
            color: Color(0xFFD0A85C),
            elevation: 5.0,
          ),
        ));
  }

  _borrarRegionControl(String idControl) {
    FirestoreService().borrarRegionControl(idControl);
  }

  //creador
  Future<void> cargarDatosUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getStringList('user')[0];
      regionombre = sp.getStringList('user')[1];
    });
  }

  Stream<QuerySnapshot> _fetch() {
    return FirestoreService().region();
  }

  // Future<void> _showMyDialog() async {
  //   return showDialog<void>(
  //     barrierColor: Colors.red,
  //     context: context,
  //     barrierDismissible: false, // user must tap button!

  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text(
  //           'AVISO!',
  //           textAlign: TextAlign.center,
  //         ),
  //         content: SingleChildScrollView(
  //           child: ListBody(
  //             children: <Widget>[
  //               Text('Solo se permite borrar sus creaciones',
  //                   textAlign: TextAlign.center),
  //               Text(
  //                 'Entendio el mensaje?',
  //                 textAlign: TextAlign.center,
  //               ),
  //             ],
  //           ),
  //         ),
  //         actions: <Widget>[
  //           FlatButton(
  //             child: Text('Ok'),
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //             },
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
