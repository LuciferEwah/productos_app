import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;
import '../providers/provider.dart';

class ProductsService extends ChangeNotifier {
  final String _baseURL =
      'flutter-appproductos-9027f-default-rtdb.firebaseio.com';

  ProductsService();

  Future<void> syncProductsToFirebase() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      final url = Uri.https(_baseURL, 'productos.json');
      final resp = await http.get(url);

      List<ProductModel> firebaseProducts = [];

      // ignore: unnecessary_null_comparison
      if (resp.body == null ||
          resp.body == 'null' ||
          resp.body.isEmpty ||
          resp.body == '""') {
        print('No se han encontrado productos en Firebase.');
      } else {
        dynamic responseBody = json.decode(resp.body);

        // Check if the responseBody is a List
        if (responseBody is List<dynamic>) {
          // Remove the first null element, if present
          if (responseBody.isNotEmpty && responseBody[0] == null) {
            responseBody.removeAt(0);
          }

          firebaseProducts = responseBody
              .where((element) => element is Map<String, dynamic>)
              .map((element) =>
                  ProductModel.fromJson(element)..id = element['id'])
              .toList();
        } else {
          print('Formato de respuesta inesperado');
        }
      }

      final sqliteProducts = await DBProvider.db.getProductAll();

      // Adding products to Firebase
      final productsToAdd = sqliteProducts.where((sqliteProduct) =>
          !firebaseProducts.any(
              (firebaseProduct) => firebaseProduct.id == sqliteProduct.id));

      for (final productToAdd in productsToAdd) {
        final addUrl = Uri.https(_baseURL, 'productos/${productToAdd.id}.json');
        await http.put(addUrl, body: json.encode(productToAdd.toJson()));
      }

      // Updating products in Firebase
      final productsToUpdate = sqliteProducts.where((sqliteProduct) =>
          firebaseProducts.any((firebaseProduct) =>
              firebaseProduct.id == sqliteProduct.id &&
              firebaseProduct != sqliteProduct));

      for (final productToUpdate in productsToUpdate) {
        final updateUrl =
            Uri.https(_baseURL, 'productos/${productToUpdate.id}.json');
        await http.put(updateUrl, body: json.encode(productToUpdate.toJson()));
      }

      // Deleting products from Firebase
      final productsToDelete = firebaseProducts.where((firebaseProduct) =>
          !sqliteProducts
              .any((sqliteProduct) => sqliteProduct.id == firebaseProduct.id));

      for (final productToDelete in productsToDelete) {
        final deleteUrl =
            Uri.https(_baseURL, 'productos/${productToDelete.id}.json');
        await http.delete(deleteUrl);
      }
    } else {
      print('Sin conectividad de red');
    }
  }
}
