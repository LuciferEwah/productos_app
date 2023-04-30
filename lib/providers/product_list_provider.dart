import 'dart:io';

import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';

class ProductListProvider extends ChangeNotifier {
  List<ProductModel> products = [];
  List<ProductModel> productsForCard = [];

  String categoriaSeleacionada = '';
  bool isLoading = true;
  late ProductModel selectedProduct;
  File? newImgFile;

  ProductListProvider() {
    cargarProduct();
    selectedProduct = ProductModel(nombre: '', precio: 0, stock: 0);
  }

  bool addToCart(ProductModel product) {
    // Comprueba si el producto ya está en la lista
    bool productExists = productsForCard
        .any((existingProduct) => existingProduct.id == product.id);

    // Si el producto no está en la lista, agrégalo
    if (!productExists) {
      productsForCard.add(product);
      notifyListeners();
      return true; // Producto agregado al carrito
    }

    return false; // Producto ya está en el carrito
  }

  newProduct(
      {required String nombre,
      String? categoria,
      required double precio,
      required int stock,
      String? imagen,
      int? id}) async {
    final newProduct = ProductModel(
      nombre: nombre,
      categoria: categoria,
      precio: precio,
      stock: stock,
      imagen: imagen,
      id: id,
    );

    await DBProvider.db.newProduct(newProduct);
    products.add(newProduct);
    notifyListeners();
  }

  Future<List<ProductModel>> cargarProduct() async {
    isLoading = true;
    notifyListeners();
    final products = await DBProvider.db.getProductAll();
    this.products = [...products];
    isLoading = false;
    notifyListeners();
    return this.products;
  }

  cargarProductByCategory(String categoria) async {
    final products = await DBProvider.db.getProductByType(categoria);
    this.products = [...products];
    categoriaSeleacionada = categoria;
    notifyListeners();
  }

  deleteAll() async {
    await DBProvider.db.deleteProductAll();
    products = [];
    notifyListeners();
  }

  deleteById(int id) async {
    await DBProvider.db.deleteProductById(id);
    cargarProduct();
  }

  update(product) async {
    await DBProvider.db.updateProduct(product);
    cargarProduct();
  }

  void updateSelectProductImage(String path) {
    selectedProduct.imagen = path;
    newImgFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }
}
