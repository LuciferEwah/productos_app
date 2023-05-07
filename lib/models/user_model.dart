// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

class UserModel {
  UserModel({this.id, required this.email, required this.contrasena, this.rol});

  int? id;
  String email;
  String contrasena;
  String? rol;

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      email: json["email"],
      contrasena: json["contrasena"],
      rol: json["rol"]);

  Map<String, dynamic> toJson() =>
      {"id": id, "email": email, "contrasena": contrasena, "rol": rol};

  UserModel copy() =>
      UserModel(email: email, contrasena: contrasena, id: id, rol: rol);
}
