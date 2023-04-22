// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';
import 'dart:ffi';

class ProductModel {
  ProductModel({
    required this.nombre,
    this.categoria,
    required this.precio,
    required this.stock,
    this.imagen,
  });

  String nombre;
  double precio;
  int stock;
  String? categoria;
  String? imagen;
  String? id;

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
        nombre: json["nombre"],
        categoria: json["categoria"],
        precio: json["precio"],
        stock: json["stock"],
        imagen: json["imagen"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "categoria": categoria,
        "precio": precio,
        "stock": stock,
        "imagen": imagen,
      };
}
