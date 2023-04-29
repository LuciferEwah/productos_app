// To parse this JSON data, do
//
//     final product = productFromJson(jsonString);

import 'dart:convert';

class ProductModel {
  ProductModel(
      {this.id,
      required this.nombre,
      this.categoria,
      required this.precio,
      required this.stock,
      this.imagen});

  int? id;
  String nombre;
  double precio;
  int stock;
  String? categoria;
  String? imagen;

  factory ProductModel.fromRawJson(String str) =>
      ProductModel.fromJson(json.decode(str));

  get cantidad => null;

  String toRawJson() => json.encode(toJson());

  factory ProductModel.fromJson(Map<String, dynamic> json) => ProductModel(
      id: json["id"],
      nombre: json["nombre"],
      categoria: json["categoria"],
      precio: json["precio"],
      stock: json["stock"],
      imagen: json["imagen"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "categoria": categoria,
        "precio": precio,
        "stock": stock,
        "imagen": imagen,
      };

  ProductModel copy() => ProductModel(
      nombre: nombre,
      precio: precio,
      stock: stock,
      categoria: categoria,
      id: id,
      imagen: imagen);
}
