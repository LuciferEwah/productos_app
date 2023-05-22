import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;
import '../providers/provider.dart';

class VentaService extends ChangeNotifier {
  final String _baseURL =
      'flutter-appproductos-9027f-default-rtdb.firebaseio.com';

  VentaService();

  Future<void> syncVentasToFirebase() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      final url = Uri.https(_baseURL, 'ventas.json');
      final resp = await http.get(url);

      List<VentaModel> firebaseVentas = [];

      if (resp.body == 'null' || resp.body.isEmpty || resp.body == '""') {
        print('No se han encontrado ventas en Firebase.');
      } else {
        dynamic responseBody = json.decode(resp.body);

        if (responseBody is List<dynamic>) {
          if (responseBody.isNotEmpty && responseBody[0] == null) {
            responseBody.removeAt(0);
          }

          firebaseVentas = responseBody
              .where((element) => element is Map<String, dynamic>)
              .map(
                  (element) => VentaModel.fromJson(element)..id = element['id'])
              .toList();
        } else {
          print('Formato de respuesta inesperado');
        }
      }

      final sqliteVentas = await DBProvider.db
          .getVentasAll(); // Este método aún no está definido en tu clase DBProvider

      // Agregar ventas a Firebase
      final ventasToAdd = sqliteVentas.where((sqliteVenta) => !firebaseVentas
          .any((firebaseVenta) => firebaseVenta.id == sqliteVenta.id));

      for (final ventaToAdd in ventasToAdd) {
        final addUrl = Uri.https(_baseURL, 'ventas/${ventaToAdd.id}.json');
        await http.put(addUrl, body: json.encode(ventaToAdd.toJson()));
      }
    } else {
      print('Sin conectividad de red');
    }
  }

  Future<void> syncDetalleVentasToFirebase() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      final url = Uri.https(_baseURL, 'detalleVentas.json');
      final resp = await http.get(url);

      List<DetalleVentaModel> firebaseDetalleVentas = [];

      if (resp.body == 'null' || resp.body.isEmpty || resp.body == '""') {
        print('No se han encontrado detalle ventas en Firebase.');
      } else {
        dynamic responseBody = json.decode(resp.body);

        if (responseBody is List<dynamic>) {
          if (responseBody.isNotEmpty && responseBody[0] == null) {
            responseBody.removeAt(0);
          }

          firebaseDetalleVentas = responseBody
              .where((element) => element is Map<String, dynamic>)
              .map((element) =>
                  DetalleVentaModel.fromJson(element)..id = element['id'])
              .toList();
        } else {
          print('Formato de respuesta inesperado');
        }
      }

      final sqliteDetalleVentas = await DBProvider.db.getAllDetalleVenta();

      // Agregar detalle ventas a Firebase
      final detalleVentasToAdd = sqliteDetalleVentas.where(
          (sqliteDetalleVenta) => !firebaseDetalleVentas.any(
              (firebaseDetalleVenta) =>
                  firebaseDetalleVenta.id == sqliteDetalleVenta.id));

      for (final detalleVentaToAdd in detalleVentasToAdd) {
        final addUrl =
            Uri.https(_baseURL, 'detalleVentas/${detalleVentaToAdd.id}.json');
        await http.put(addUrl, body: json.encode(detalleVentaToAdd.toJson()));
      }
    } else {
      print('Sin conectividad de red');
    }
  }
}
