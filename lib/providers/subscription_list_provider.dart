import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';
import 'dart:async';


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
void startUpdatingSubscriptionStatus() {
    // Define un intervalo de tiempo de 24 horas
    Duration interval = Duration(hours: 24);

    // Crea un temporizador periódico que se ejecuta cada 24 horas
    Timer.periodic(interval, (Timer timer) async {
      // Llama a la función `updateSubscriptionStatus`
      await DBProvider.db.updateSubscriptionStatus();
    });
  }
  Future<Suscripciones?> getActiveSubscription(int userId) async {
    final suscripciones = await DBProvider.db.getActiveSubscription(userId);
    if (suscripciones != null && suscripciones.isNotEmpty) {
      return suscripciones.first;
    } else {
      return null;
    }
  }

}
