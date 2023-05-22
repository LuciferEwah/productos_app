import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;
import '../providers/provider.dart';

class SubscriptionService extends ChangeNotifier {
  final String _baseURL =
      'flutter-appproductos-9027f-default-rtdb.firebaseio.com';

  SubscriptionService();

  Future<void> syncSuscripcionesToFirebase() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      final url = Uri.https(_baseURL, 'suscripciones.json');
      final resp = await http.get(url);

      List<SuscripcionesModel> firebaseSuscripciones = [];

      if (resp.body == 'null' || resp.body.isEmpty || resp.body == '""') {
        print('No se han encontrado suscripciones en Firebase.');
      } else {
        dynamic responseBody = json.decode(resp.body);

        if (responseBody is List<dynamic>) {
          if (responseBody.isNotEmpty && responseBody[0] == null) {
            responseBody.removeAt(0);
          }

          firebaseSuscripciones = responseBody
              .where((element) => element is Map<String, dynamic>)
              .map((element) =>
                  SuscripcionesModel.fromJson(element)..id = element['id'])
              .toList();
        } else {
          print('Formato de respuesta inesperado');
        }
      }

      final sqliteSuscripciones = await DBProvider.db.getSuscripcionesAll();

      // agregar suscripciones a Firebase
      final suscripcionesToAdd = sqliteSuscripciones.where(
          (sqliteSuscripcion) => !firebaseSuscripciones.any(
              (firebaseSuscripcion) =>
                  firebaseSuscripcion.id == sqliteSuscripcion.id));

      for (final suscripcionToAdd in suscripcionesToAdd) {
        final addUrl =
            Uri.https(_baseURL, 'suscripciones/${suscripcionToAdd.id}.json');
        await http.put(addUrl, body: json.encode(suscripcionToAdd.toJson()));
      }

      // eliminar suscripciones a Firebase
      final suscripcionesToDelete = firebaseSuscripciones.where(
          (firebaseSuscripcion) => !sqliteSuscripciones.any(
              (sqliteSuscripcion) =>
                  sqliteSuscripcion.id == firebaseSuscripcion.id));

      for (final suscripcionToDelete in suscripcionesToDelete) {
        final deleteUrl =
            Uri.https(_baseURL, 'suscripciones/${suscripcionToDelete.id}.json');
        await http.delete(deleteUrl);
      }
    } else {
      print('Sin conectividad de red');
    }
  }

  Future<void> syncCompraSuscripcionesToFirebase() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      final url = Uri.https(_baseURL, 'compraSuscripciones.json');
      final resp = await http.get(url);

      List<CompraSuscripcion> firebaseCompraSuscripciones = [];

      if (resp.body == 'null' || resp.body.isEmpty || resp.body == '""') {
        print('No se han encontrado compras de suscripciones en Firebase.');
      } else {
        dynamic responseBody = json.decode(resp.body);

        if (responseBody is List<dynamic>) {
          if (responseBody.isNotEmpty && responseBody[0] == null) {
            responseBody.removeAt(0);
          }

          firebaseCompraSuscripciones = responseBody
              .where((element) => element is Map<String, dynamic>)
              .map((element) =>
                  CompraSuscripcion.fromJson(element)..id = element['id'])
              .toList();
        } else {
          print('Formato de respuesta inesperado');
        }
      }

      final sqliteCompraSuscripciones =
          await DBProvider.db.getCompraSuscripcionesAll();

      final compraSuscripcionesToAdd = sqliteCompraSuscripciones.where(
          (sqliteCompraSuscripcion) => !firebaseCompraSuscripciones.any(
              (firebaseCompraSuscripcion) =>
                  firebaseCompraSuscripcion.id == sqliteCompraSuscripcion.id));

      for (final compraSuscripcionToAdd in compraSuscripcionesToAdd) {
        final addUrl = Uri.https(
            _baseURL, 'compraSuscripciones/${compraSuscripcionToAdd.id}.json');
        await http.put(addUrl,
            body: json.encode(compraSuscripcionToAdd.toJson()));
      }
    } else {
      print('Sin conectividad de red');
    }
  }
}
