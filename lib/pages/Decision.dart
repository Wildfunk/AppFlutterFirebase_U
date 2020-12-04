import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:tarea_3_dam/pages/login_page.dart';

import 'package:tarea_3_dam/pages/navegador_page.dart';

//import 'login_page.dart';

class Decision extends StatelessWidget {
  const Decision({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final usuario = Provider.of<FirebaseUser>(context);

    return usuario == null ? LoginPage() : NavegadorPage();
  }
}
