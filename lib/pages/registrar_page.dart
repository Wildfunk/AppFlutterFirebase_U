import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

import 'package:tarea_3_dam/services/auth_service.dart';

class RegistrarPage extends StatefulWidget {
  RegistrarPage({Key key}) : super(key: key);

  @override
  _RegistrarPageState createState() => _RegistrarPageState();
}

class _RegistrarPageState extends State<RegistrarPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();
  TextEditingController password2Ctrl = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final _emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  String error = " ";

  bool isLoading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Registrar Usuario',
            style: TextStyle(color: Color(0xFFCB8C34))),
      ),
      body: Center(
        child: Form(
            key: _formkey,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: <Widget>[
                  _txtEmail(),
                  _txtpassword(),
                  _txtpassword2(),
                  _btnRegistrar(),
                  _textError(),
                  _mostrarLoading(),
                  Divider(
                    color: Colors.grey,
                  ),
                  Column(
                    children: [
                      Text('Vincula tu Cuenta.'),
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(MdiIcons.facebook,
                                    color: Colors.blue, size: 50.0),
                                onPressed: () {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(MdiIcons.googlePlus,
                                    color: Colors.red, size: 50.0),
                                onPressed: () {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(MdiIcons.twitter,
                                    color: Colors.lightBlue, size: 50.0),
                                onPressed: () {},
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: IconButton(
                                icon: Icon(MdiIcons.amazon,
                                    color: Colors.black, size: 50.0),
                                onPressed: () {},
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )),
      ),
    );
  }

  Widget _txtEmail() {
    return TextFormField(
      controller: emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: 'Email', suffixIcon: Icon(FontAwesomeIcons.envelope)),
      validator: (value) {
        if (value.isEmpty) {
          return 'indique Email';
        }

        if (!RegExp(_emailRegex).hasMatch(value)) {
          return 'Email no valido';
        }

        return null;
      },
    );
  }

  Widget _txtpassword() {
    return TextFormField(
      controller: passwordCtrl,
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Contraseña', suffixIcon: Icon(FontAwesomeIcons.key)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Indique Contraseña';
        }

        if (value.length < 6) {
          return 'la contraseña es inconsistente minimo 6 caracteres';
        }
        return null;
      },
    );
  }

  Widget _txtpassword2() {
    return TextFormField(
      controller: password2Ctrl,
      obscureText: true,
      decoration: InputDecoration(
          labelText: 'Repita Contraseña',
          suffixIcon: Icon(FontAwesomeIcons.key)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Indique Contraseña';
        }

        if (value != passwordCtrl.text) {
          return 'Las Contraseñas no Coinciden';
        }
        return null;
      },
    );
  }

  Widget _btnRegistrar() {
    return Container(
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Text('Registrar Usuario', style: TextStyle(color: Colors.black)),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          AuthService authService = new AuthService();
          if (_formkey.currentState.validate()) {
            //Form okidoki
            setState(() {
              isLoading = true;
            });
            authService
                .crearUsuario(emailCtrl.text.trim(), passwordCtrl.text.trim())
                .then((valor) {
              Navigator.pop(context);
            }).catchError((exError) {
              setState(() {
                isLoading = false;
                error = exError;
              });
            });
          }
        },
        color: Color(0xFFD0A85C),
        elevation: 5.0,
      ),
    );
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

  Widget _mostrarLoading() {
    return isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : Text('');
  }

  // Widget _haveAccount() {
  //   return GestureDetector(
  //     onTap: () {
  //       final route = MaterialPageRoute(builder: (context) => RegistrarPage());
  //       Navigator.push(context, route);
  //     },
  //     child: Container(
  //       width: double.infinity,
  //       child: RichText(
  //         textAlign: TextAlign.center,
  //         text: TextSpan(
  //           text: 'Ya tienes una cuenta? ',
  //           style: Theme.of(context)
  //               .textTheme
  //               .subtitle1
  //               .copyWith(color: Colors.grey),
  //           children: <TextSpan>[
  //             TextSpan(
  //                 text: 'Logearme.',
  //                 style: Theme.of(context).textTheme.subtitle1.copyWith(
  //                     color: Theme.of(context).primaryColor,
  //                     fontWeight: FontWeight.bold)),
  //           ],
  //         ),
  //       ),
  //     ),
  //   );
  // }
}
