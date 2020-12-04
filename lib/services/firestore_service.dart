import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  //obtener controles
  Stream<QuerySnapshot> leyenda() {
    return Firestore.instance.collection('leyenda').snapshots();
  }

  Stream<QuerySnapshot> region() {
    return Firestore.instance.collection('region').snapshots();
  }

  //agregar controles
  Future agregarControl(String nombre, _razaSeleccioanda, _capitalSeleccionada,
      _sexoSeleccionado) async {
    SharedPreferences sp = await SharedPreferences.getInstance();
    Firestore.instance.collection('leyenda').document().setData({
      'fecha': DateTime.now(),
      'nombre': nombre,
      'uid': sp.getStringList('user')[0],
      'creador': sp.getStringList('user')[1],
      'raza': _razaSeleccioanda,
      'capital': _capitalSeleccionada,
      'sexo': _sexoSeleccionado,
      // 'fechanac': _fechaNacimientoSeleccionada
    });
  }

  //agregar controles
  Future agregarRegionControl(
      String regionombre, String poblacion, _capitalSeleccionada) async {
    // SharedPreferences sp = await SharedPreferences.getInstance();
    Firestore.instance.collection('region').document().setData({
      'nombre': regionombre,
      'poblacion': poblacion,
      'region': _capitalSeleccionada
    });
  }

  //borrar controles leyenda
  Future borrarControl(String idControl) {
    Firestore.instance.collection('leyenda').document(idControl).delete();
  }

  //borrar controles Region
  Future borrarRegionControl(String idControl) {
    Firestore.instance.collection('region').document(idControl).delete();
  }
}
