import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:tarea_3_dam/pages/registrar_page.dart';
import 'package:tarea_3_dam/services/auth_service.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController passwordCtrl = TextEditingController();

  final _formkey = GlobalKey<FormState>();

  final _emailRegex =
      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+";

  String error = "";
  bool isLoading = false;
  bool _obscureText = true;

  void _toggle() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Bienvenido Invocador',
            style: TextStyle(color: Color(0xFFCB8C34))),
        // actions: <Widget>[
        //   IconButton(
        //     icon: Icon(FontAwesomeIcons.userPlus),
        //     onPressed: () {
        //       final route =
        //           MaterialPageRoute(builder: (context) => RegistrarPage());
        //       Navigator.push(context, route);
        //     },
        //   )
        // ],
      ),
      body: Center(
        child: Form(
            key: _formkey,
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: Image.asset(
                    'assets/img/login.gif',
                    fit: BoxFit.cover,
                  ),
                ),
                _txtEmail(),
                _txtpassword(),
                _btnAgregar(),
                _textError(),
                _mostrarLoading(),
                _haveAccount(),
                Divider(
                  color: Colors.grey,
                ),
                Column(
                  children: [
                    Text('Inicia con tu cuenta preferida.'),
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
                )
              ],
            )),
      ),
    );
  }

  Widget _txtEmail() {
    return TextFormField(
      controller: emailCtrl,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
          labelText: ' Email.',
          suffixIcon: Icon(
            FontAwesomeIcons.envelope,
            color: Colors.black,
          )),
      validator: (value) {
        if (value.isEmpty) {
          return ' indique Email.';
        }

        if (!RegExp(_emailRegex).hasMatch(value)) {
          return ' Email no valido.';
        }

        return null;
      },
    );
  }

  Widget _txtpassword() {
    return TextFormField(
      controller: passwordCtrl,
      // keyboardType: TextInputType.visiblePassword,
      obscureText: _obscureText,
      decoration: InputDecoration(
          labelText: ' Contraseña.',
          suffixIcon: IconButton(
            icon: Icon(
              MdiIcons.eye,
              color: this._obscureText ? Colors.black : Colors.blue,
            ),
            onPressed: () {
              _toggle();
            },
          )),
      validator: (value) {
        if (value.isEmpty) {
          return ' Indique Contraseña.';
        }

        if (value.length < 6) {
          return ' La contraseña es incorrecta.';
        }
        return null;
      },
    );
  }

  Widget _btnAgregar() {
    return Container(
      child: RaisedButton(
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
        child: Text('Iniciar Usuario', style: TextStyle(color: Colors.black)),
        onPressed: () {
          FocusScope.of(context).requestFocus(new FocusNode());
          AuthService authService = new AuthService();

          if (_formkey.currentState.validate()) {
            //sesion ok
            setState(() {
              isLoading = true;
            });

            authService
                .iniciarSesionUsuario(
                    emailCtrl.text.trim(), passwordCtrl.text.trim())
                .catchError((exError) {
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

  Widget _haveAccount() {
    return GestureDetector(
      onTap: () {
        final route = MaterialPageRoute(builder: (context) => RegistrarPage());
        Navigator.push(context, route);
      },
      child: Container(
        width: double.infinity,
        child: RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            text: 'No tienes cuenta? ',
            style: Theme.of(context)
                .textTheme
                .subtitle1
                .copyWith(color: Colors.grey),
            children: <TextSpan>[
              TextSpan(
                  text: 'Registrate.',
                  style: Theme.of(context).textTheme.subtitle1.copyWith(
                      color: Theme.of(context).primaryColor,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }
}
