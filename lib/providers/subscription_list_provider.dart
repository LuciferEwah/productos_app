import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';



class SuscriptionListProvider extends ChangeNotifier {
  List<Suscripciones> suscripciones = [];
  bool isLoading = true;

  SuscriptionListProvider() {
    cargarSuscripcion();
  }

  Future<void> addSubscription(Suscripciones suscripcion) async {
    await DBProvider.db.newSuscripcion(suscripcion);
    suscripciones.add(suscripcion);
    notifyListeners();
  }

  Future<List<Suscripciones>> cargarSuscripcion() async {
    isLoading = true;
    notifyListeners();
    final suscripciones = await DBProvider.db.getSuscripcionesAll();
    if (suscripciones == null) {
      isLoading = false;
      notifyListeners();
      return [];
    }
    this.suscripciones = [...suscripciones];
    isLoading = false;
    notifyListeners();
    return this.suscripciones;
  }
}
