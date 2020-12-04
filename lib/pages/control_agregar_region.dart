import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tarea_3_dam/services/firestore_service.dart';

class ControlAgregarRegion extends StatefulWidget {
  ControlAgregarRegion({Key key}) : super(key: key);

  @override
  _ControlAgregarRegionState createState() => _ControlAgregarRegionState();
}

class _ControlAgregarRegionState extends State<ControlAgregarRegion> {
  TextEditingController nombreCtrl = new TextEditingController();
  TextEditingController poblacionCtrl = new TextEditingController();
  final _formkey = GlobalKey<FormState>();
  String error = "";
  String _capitalSeleccionada;
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
    'Monte Targon',
    'Shurima'
  ];

  void initState() {
    _capitalSeleccionada = _capital[0];

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Agregar Ciudad'),
      ),
      body: Form(
        key: _formkey,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              _txtNombre(),
              _txtpoblacion(),
              _crearCampoCapital(),
              _textError(),
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

  void _validacion() {
    if (_formkey.currentState.validate()) {
      _agregarRegionControl();
      // _mostrarSnackbar();
    }
  }

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

  _agregarRegionControl() {
    FirestoreService().agregarRegionControl(
      nombreCtrl.text.trim(),
      poblacionCtrl.text.trim(),
      _capitalSeleccionada.trim(),
    );
    Navigator.pop(context);
  }

  Widget _txtNombre() {
    return TextFormField(
      controller: nombreCtrl,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        labelText: 'Nombre del sector',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return ' indique nombre region.';
        }
        return null;
      },
    );
  }

  Widget _txtpoblacion() {
    return TextFormField(
      controller: poblacionCtrl,
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Poblacion',
      ),
      validator: (value) {
        if (value.isEmpty) {
          return ' indique poblacion.';
        }
        return null;
      },
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
}
