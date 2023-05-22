import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';
import 'dart:async';

class SuscriptionListProvider extends ChangeNotifier {
  List<SuscripcionesModel> suscripciones = [];
  bool isLoading = true;

  SuscriptionListProvider() {
    cargarSuscripcion();
  }

  Future<void> addSubscription(SuscripcionesModel suscripcion) async {
    await DBProvider.db.newSuscripcion(suscripcion);
    suscripciones.add(suscripcion);
    notifyListeners();
  }

  Future<List<SuscripcionesModel>> cargarSuscripcion() async {
    isLoading = true;
    notifyListeners();
    final suscripciones = await DBProvider.db.getSuscripcionesAll();
    if (suscripciones.isNotEmpty) {
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
    Duration interval = const Duration(hours: 24);

    // Crea un temporizador periódico que se ejecuta cada 24 horas
    Timer.periodic(interval, (Timer timer) async {
      // Llama a la función `updateSubscriptionStatus`
      await DBProvider.db.updateSubscriptionStatus();
    });
  }

  Future<SuscripcionesModel?> getActiveSubscription(int userId) async {
    final suscripciones = await DBProvider.db.getActiveSubscription(userId);
    if (suscripciones.isNotEmpty) {
      return suscripciones.first;
    } else {
      return null;
    }
  }
}
