import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tarea_3_dam/pages/Decision.dart';
import 'package:tarea_3_dam/services/auth_service.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return StreamProvider<FirebaseUser>.value(
      value: AuthService().usuario,
      child: MaterialApp(
        localizationsDelegates: [GlobalMaterialLocalizations.delegate],
        title: 'Leyendas',
        debugShowCheckedModeBanner: false,
        supportedLocales: [const Locale('en'), const Locale('es')],
        theme: ThemeData(
          primaryColor: Color(0xFF030608),
        ),
        home: Decision(),
      ),
    );
  }
}
