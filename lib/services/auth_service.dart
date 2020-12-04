import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  Stream<FirebaseUser> get usuario {
    return _firebaseAuth.onAuthStateChanged;
  }

  // crear Usuario
  Future crearUsuario(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setStringList('user', [firebaseUser.uid, firebaseUser.email]);
      return firebaseUser;
    } catch (ex) {
      switch (ex.code) {
        case 'ERROR_EMAIL_ALREADY_IN_USE':
          return Future.error('EMAIL EXISTENTE.');
          break;
        case 'ERROR_WEAK_PASSWORD':
          return Future.error('CONTRASEÑA DEBIL.');
          break;
        default:
          return Future.error(ex.code);
      }
    }
  }

  //Login
  Future iniciarSesionUsuario(String email, String password) async {
    try {
      AuthResult authResult = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      FirebaseUser firebaseUser = authResult.user;
      SharedPreferences sp = await SharedPreferences.getInstance();
      sp.setStringList('user', [firebaseUser.uid, firebaseUser.email]);
      return firebaseUser;
    } catch (ex) {
      switch (ex.code) {
        case 'ERROR_WRONG_PASSWORD':
          return Future.error('Credenciales Incorrectas.');
          break;
        case 'ERROR_USER_NOT_FOUND':
          return Future.error('Credenciales Incorrectas.');
          break;
        case 'ERROR_USER_DISABLED':
          return Future.error('Cuenta Inhabilitada.');
          break;
        default:
          return Future.error(ex.code);
      }
    }
  }
  //logout

  Future cerrarSesionUsuario() async {
    return await _firebaseAuth.signOut();
  }
}
