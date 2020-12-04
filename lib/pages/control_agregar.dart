import 'package:flutter/material.dart';

import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tarea_3_dam/services/firestore_service.dart';

class ControlAgregar extends StatefulWidget {
  ControlAgregar({Key key}) : super(key: key);

  @override
  _ControlAgregarState createState() => _ControlAgregarState();
}

class _ControlAgregarState extends State<ControlAgregar> {
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController razaCtrl = new TextEditingController();
  final FocusScopeNode _node = new FocusScopeNode();
  final _formkey = GlobalKey<FormState>();
  // final _scaffoldkey = GlobalKey<ScaffoldState>();
  // final _raza = [
  //   {'id': 1, 'raza': 'Humano'},
  //   {'id': 2, 'raza': 'Vastaya'},
  //   {'id': 3, 'raza': 'Yordle'},
  //   {'id': 4, 'raza': 'Ascendidos'},
  //   {'id': 5, 'raza': 'Hijos del Vacio'},
  //   {'id': 6, 'raza': 'Darkin'},
  //   {'id': 7, 'raza': 'Hijos del Hielo'},
  // ];
  String _razaSeleccioanda;
  String _capitalSeleccionada;
  String error = "";
  String _sexoSeleccionado;

  List<String> _razaType = <String>[
    'Humano',
    'Vastaya',
    'Yordle',
    'Ascendidos',
    'Hijos del Vacio',
    'Darkin',
    'Hijos del Hielo'
  ];

  List<String> _capital = <String>[
    'Demacia',
    'Fréljord',
    'Pantano de los Lamentos',
    'Montañas Ironspike',
    'Kaladoun',
    'Kalamanda',
    'Pantanos de Kaladoun',
    'Noxus',
    'Piltóver',
    'Río Serpentino',
    'La Gran Barrera',
    'Zaun',
    'Shurima',
    'Monte Targon'
  ];

  void initState() {
    _razaSeleccioanda = _razaType[0];

    _capitalSeleccionada = _capital[0];
    _sexoSeleccionado = 'Macho';
    super.initState();
  }

  void dispose() {
    _node.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agregar Personaje'),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              _txtNombre(),
              _crearCampoRaza(),
              _crearCampoCapital(),
              // _crearCampoFechaNacimiento(),
              _crearCampoSexo(),

              _textError(),
              // _crearCampoRegion(),
              RaisedButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30.0)),
                child: Text('Aceptar', style: TextStyle(color: Colors.black)),
                onPressed: () => _validacion(),
                color: Color(0xFFD0A85C),
                elevation: 5.0,
              )
            ],
          ),
        ),
      ),
    );
  }

  _agregarControl() {
    FirestoreService().agregarControl(
      nombreCtrl.text.trim(),
      _razaSeleccioanda.trim(),
      _capitalSeleccionada.trim(),
      _sexoSeleccionado.trim(),
    );

    Navigator.pop(context);
  }

  Widget _txtNombre() {
    return Form(
      child: FocusScope(
        node: _node,
        child: TextFormField(
          controller: nombreCtrl,
          keyboardType: TextInputType.text,
          onEditingComplete: _node.nextFocus,
          autofocus: false,
          decoration: InputDecoration(
            labelText: 'Nombre',
          ),
          validator: (value) {
            if (value.isEmpty) {
              return ' indique nombre region.';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _crearCampoCapital() {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: 'Region de origen'),
      isExpanded: true,
      value: _capitalSeleccionada,
      items: _capital.map((capital) {
        return DropdownMenuItem(
          value: capital,
          child: Text(capital),
        );
      }).toList(),
      onChanged: (nuevoValor) {
        setState(() {
          _capitalSeleccionada = nuevoValor;
        });
      },
    );
  }

  // Widget _crearCampoFechaNacimiento() {
  //   return Row(
  //     children: <Widget>[
  //       Text(
  //         'Fecha Nacimiento ',
  //         style: TextStyle(fontSize: 15.5, color: Colors.grey[600]),
  //       ),
  //       Expanded(
  //           child: Text(
  //               DateFormat('dd-MM-yyyy').format(_fechaNacimientoSeleccionada),
  //               style: TextStyle(fontSize: 15.5, color: Colors.grey[600]))),
  //       FlatButton(
  //         child: Icon(FontAwesomeIcons.calendar),
  //         onPressed: () {
  //           showDatePicker(
  //                   context: context,
  //                   initialDate: DateTime.now(),
  //                   firstDate: DateTime(1900),
  //                   lastDate: DateTime.now(),
  //                   locale: Locale('es', 'ES'))
  //               .then((fecha) {
  //             setState(() {
  //               if (fecha != null) _fechaNacimientoSeleccionada = fecha;
  //             });
  //           });
  //         },
  //       )
  //     ],
  //   );
  // }

  Widget _crearCampoRaza() {
    return DropdownButtonFormField(
      decoration: InputDecoration(labelText: 'Raza'),
      isExpanded: true,
      value: _razaSeleccioanda,
      items: _razaType.map((raza) {
        return DropdownMenuItem(
          value: raza,
          child: Text(raza),
        );
      }).toList(),
      onChanged: (nuevoValor) {
        setState(() {
          _razaSeleccioanda = nuevoValor;
        });
      },
    );
  }

  Widget _crearCampoSexo() {
    return Column(
      children: <Widget>[
        RadioListTile(
          groupValue: _sexoSeleccionado,
          value: 'Macho',
          title: Row(
            children: [
              Text('Macho '),
              Icon(
                MdiIcons.genderMale,
                color: Colors.blue,
              )
            ],
          ),
          onChanged: (valor) {
            setState(() {
              _sexoSeleccionado = valor;
            });
          },
        ),
        RadioListTile(
          groupValue: _sexoSeleccionado,
          value: 'Hembra',
          title: Row(
            children: [
              Text('Hembra'),
              Icon(
                MdiIcons.genderFemale,
                color: Colors.pink,
              )
            ],
          ),
          onChanged: (valor) {
            setState(() {
              _sexoSeleccionado = valor;
            });
          },
        ),
        Divider(
          color: Colors.black,
        )
      ],
    );
  }

  void _validacion() {
    if (_formkey.currentState.validate()) {
      _agregarControl();
      // _mostrarSnackbar();
    }
  }

  // void _mostrarSnackbar() {
  //   final snackbar = new SnackBar(content: Text('Alumno Matriculado'));
  //   _scaffoldkey.currentState.showSnackBar(snackbar);
  // }

  Widget _textError() {
    return Center(
      child: Container(
        margin: EdgeInsets.only(top: 10),
        child: Text(
          error,
          style: TextStyle(color: Colors.red),
        ),
      ),
    );
  }

  // Widget _crearCampoRegion() {
  //   Scaffold(
  //       body: StreamBuilder(
  //     stream: _fetch(),
  //     builder: (context, snapshot) {
  //       if (!snapshot.hasData) {
  //         return Center(
  //           child: CircularProgressIndicator(),
  //         );
  //       } else {
  //         return Card(
  //           child: ListView.separated(
  //             itemCount: snapshot.data.documents.length,
  //             separatorBuilder: (context, index) =>
  //                 Divider(color: Color(0xFFD0A85C)),
  //             itemBuilder: (context, index) {
  //               var control = snapshot.data.documents[index];
  //             },
  //           ),
  //         );
  //       }
  //     },
  //   ));
  //   return DropdownButtonFormField(
  //     decoration: InputDecoration(labelText: 'Region'),
  //     isExpanded: true,
  //     value: control[],
  //     items: _razaType.map((raza) {
  //       return DropdownMenuItem(
  //         value: raza,
  //         child: Text(raza),
  //       );
  //     }).toList(),
  //     onChanged: (nuevoValor) {
  //       setState(() {
  //         _razaSeleccioanda = nuevoValor;
  //       });
  //     },
  //   );
  // }

  // Stream<QuerySnapshot> _fetch() {
  //   return FirestoreService().region();
  // }
}
