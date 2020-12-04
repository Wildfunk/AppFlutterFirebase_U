import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tarea_3_dam/pages/personaje_page.dart';
import 'package:tarea_3_dam/pages/region_page.dart';

import 'package:tarea_3_dam/services/auth_service.dart';

class NavegadorPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return NavegadorPageState();
  }
}

class NavegadorPageState extends State<NavegadorPage> {
  int _currentIndex = 0;
  List<String> _titulo = ['Leyendas', 'Regiones de Runaterra'];
  List<int> _colors = [0xff111111, 0xFF2A5245];
  final _scaffoldkey = GlobalKey<ScaffoldState>();
  final _icono = [
    (MdiIcons.cardAccountDetails),
    (MdiIcons.cardAccountDetails),
  ];

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
      key: _scaffoldkey,
      appBar: AppBar(
        centerTitle: true,
        title: Container(
          child: Text(_titulo[_currentIndex],
              style: TextStyle(color: Color(0xFFCB8C34))),
        ),
        actions: <Widget>[
          // Center(
          //     child: Text(
          //   email.substring(0, email.indexOf('@')),
          //   style: TextStyle(fontSize: 20, color: Color(0xFFCB8C34)),
          // )),
          IconButton(
            icon: Icon(
              FontAwesomeIcons.signInAlt,
              color: Color(0xFFCB8C34),
            ),
            onPressed: () {
              AuthService authService = AuthService();
              authService.cerrarSesionUsuario();
            },
          )
        ],
        backgroundColor: Color(_colors[_currentIndex]),
        leading: IconButton(
          highlightColor: Color(0xFFCB8C34),
          icon: Icon(
            _icono[_currentIndex],
            color: Color(0xFFCB8C34),
          ),
          onPressed: () => _showMyDialog(),
        ),
      ),
      body: _navegar(_currentIndex),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
              icon: Icon(MdiIcons.accountMultiple),
              title: Text(
                _titulo[_currentIndex],
                style: TextStyle(color: Color(0xFFCB8C34)),
              ),
              backgroundColor: Color(0xFF111111)),
          BottomNavigationBarItem(
              icon: Icon(MdiIcons.earth),
              title: Text(
                _titulo[_currentIndex],
                style: TextStyle(color: Color(0xFFCB8C34)),
              ),
              backgroundColor: Color(0xFF2A5245)),
        ],
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }

  Widget _navegar(int index) {
    switch (index) {
      case 1:
        return RegionPage();
        break;

      default:
        return PersonajePage();
    }
  }

  Future<void> cargarDatosUser() async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    setState(() {
      uid = sp.getStringList('user')[0];
      email = sp.getStringList('user')[1];
    });
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!

      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Usuario Logeado',
            textAlign: TextAlign.center,
          ),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(
                    'nombre del usuario: ' +
                        email.substring(0, email.indexOf('@')),
                    textAlign: TextAlign.center),
              ],
            ),
          ),
          actions: <Widget>[
            Container(
              alignment: Alignment.bottomCenter,
              padding: EdgeInsets.only(right: 100),
              child: FlatButton(
                child: Text('ok'),
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
