import 'dart:convert';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

import '../providers/provider.dart';

class ProductsService extends ChangeNotifier {
  final String _baseURL =
      'flutter-appproductos-9027f-default-rtdb.firebaseio.com';
  final List<ProductModel> products = [];
  bool isLoading = true;

  ProductsService() {
    loadProducts();
  }

  Future loadProducts() async {
    final url = Uri.https(_baseURL, 'productos.json');
    final resp = await http.get(url);
    final Map<String, dynamic> productsMap = json.decode(resp.body);
    productsMap.forEach((key, value) {
      final tempProducto = ProductModel.fromJson(value);
      products.add(tempProducto);
    });
  }

  Future<void> syncProductsToFirebase() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      final url = Uri.https(_baseURL, 'productos.json');
      final resp = await http.get(url);
      final Map<String, dynamic> productsMap = json.decode(resp.body);

      final firebaseProducts = productsMap.entries
          .map((entry) =>
              ProductModel.fromJson(entry.value)..id = int.tryParse(entry.key))
          .toList();

      final sqliteProducts = await DBProvider.db.getProductAll();

      final productsToDelete = firebaseProducts.where((firebaseProduct) =>
          !sqliteProducts
              .any((sqliteProduct) => sqliteProduct.id == firebaseProduct.id));

      for (final productToDelete in productsToDelete) {
        final deleteUrl =
            Uri.https(_baseURL, 'productos/${productToDelete.id}.json');
        await http.delete(deleteUrl);
      }
    } else {
      print('No network connectivity');
    }
  }
}
