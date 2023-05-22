import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;
import '../providers/provider.dart';

class PlanService extends ChangeNotifier {
  final String _baseURL =
      'flutter-appproductos-9027f-default-rtdb.firebaseio.com';

  PlanService();

  Future<void> syncPlansToFirebase() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      final url = Uri.https(_baseURL, 'planes.json');
      final resp = await http.get(url);

      List<PlanModel> firebasePlans = [];

      if (resp.body == 'null' || resp.body.isEmpty || resp.body == '""') {
        print('No se han encontrado planes en Firebase.');
      } else {
        dynamic responseBody = json.decode(resp.body);
        if (responseBody is List<dynamic>) {
          if (responseBody.isNotEmpty && responseBody[0] == null) {
            responseBody.removeAt(0);
          }

          firebasePlans = responseBody
              .where((element) => element is Map<String, dynamic>)
              .map((element) => PlanModel.fromJson(element)..id = element['id'])
              .toList();
        } else {
          print('Formato de respuesta inesperado');
        }
      }

      final sqlitePlans = await DBProvider.db.getPlans();

      // agregar plans to Firebase
      final plansToAdd = sqlitePlans.where((sqlitePlan) => !firebasePlans
          .any((firebasePlan) => firebasePlan.id == sqlitePlan.id));

      for (final planToAdd in plansToAdd) {
        final addUrl = Uri.https(_baseURL, 'planes/${planToAdd.id}.json');
        await http.put(addUrl, body: json.encode(planToAdd.toJson()));
      }

      // modificar plans in Firebase
      final plansToUpdate = sqlitePlans.where((sqlitePlan) => firebasePlans.any(
          (firebasePlan) =>
              firebasePlan.id == sqlitePlan.id && firebasePlan != sqlitePlan));

      for (final planToUpdate in plansToUpdate) {
        final updateUrl = Uri.https(_baseURL, 'planes/${planToUpdate.id}.json');
        await http.put(updateUrl, body: json.encode(planToUpdate.toJson()));
      }

      // eliminar plans from Firebase
      final plansToDelete = firebasePlans.where((firebasePlan) =>
          !sqlitePlans.any((sqlitePlan) => sqlitePlan.id == firebasePlan.id));

      for (final planToDelete in plansToDelete) {
        final deleteUrl = Uri.https(_baseURL, 'planes/${planToDelete.id}.json');
        await http.delete(deleteUrl);
      }
    } else {
      print('Sin conectividad de red');
    }
  }
}
