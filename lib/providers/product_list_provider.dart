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

  Future<void> newProduct({
    required String nombre,
    String? categoria,
    required double precio,
    required int stock,
    String? imagen,
    int? id,
  }) async {
    final newProduct = ProductModel(
      nombre: nombre,
      categoria: categoria,
      precio: precio,
      stock: stock,
      imagen: imagen,
      id: id,
    );

    // Inserta el producto en la base de datos y obtén el producto con su ID actualizado.
    final insertedProduct = await DBProvider.db.newProduct(newProduct);

    // Actualiza la lista de productos y notifica a los listeners.
    products.add(insertedProduct);
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

  deleteAllCart() async {
    productsForCard = [];
    notifyListeners();
  }

  deleteById(int id) async {
    await DBProvider.db.deleteProductById(id);
    cargarProduct();
  }

  update(product) async {
    await DBProvider.db.updateProduct(product);
    cargarProduct();
    notifyListeners();
  }

  void updateSelectProductImage(String path) {
    selectedProduct.imagen = path;
    newImgFile = File.fromUri(Uri(path: path));
    notifyListeners();
  }

  Future<bool> checkStock(int id, int quantity) async {
    final db = DBProvider.db;
    final product = await db.getProductById(id);
    return product.stock >= quantity;
  }

  Future<void> realizarVenta(double subtotal, double iva, double total,
      int? usuarioId, Map<int, int> cantidadSeleccionada) async {
    // Crear una instancia de VentaModel
    VentaModel venta = VentaModel(
      fecha: DateTime.now().toString(),
      total: total,
      usuarioId: usuarioId, // Aquí puedes proporcionar el ID de usuario actual
    );

    // Llamar a la función addVenta() para agregar la venta a la base de datos
    int ventaId = await DBProvider.db.addVenta(venta);

// Agregar detalles de la venta
    for (int index = 0; index < productsForCard.length; index++) {
      ProductModel product = productsForCard[index];

      // Utiliza el ID del producto en lugar del índice para acceder a la cantidad
      int cantidadProducto = cantidadSeleccionada[product.id!] ?? 1;

      DetalleVentaModel detalleVenta = DetalleVentaModel(
        ventaId: ventaId,
        productoId: product.id!,
        cantidad: cantidadProducto, // Usa la cantidad seleccionada aquí
        subtotal:
            product.precio * cantidadProducto, // Modifica el subtotal aquí
      );
      await DBProvider.db.addDetalleVenta(detalleVenta);

      // También asegúrate de utilizar la cantidad correcta aquí
      await DBProvider.db.discountItemQuantity(product.id!, cantidadProducto);
      cargarProduct();
    }

    // Notificar a los listeners
    notifyListeners();
  }

  void clearCart() {
    productsForCard.clear();
    notifyListeners();
  }

  void removeProductFromCart(ProductModel product) {
    productsForCard.remove(product);
    notifyListeners();
  }
}
