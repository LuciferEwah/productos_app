import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;

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
}
