// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

class UserModel {
  UserModel(
      {this.id,
      required this.email,
      required this.contrasena});

  int? id;
  String email;
  String contrasena;

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      email: json["email"],
      contrasena: json["contrasena"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "email": email,
        "contrasena": contrasena};

  UserModel copy() => UserModel(
      email: email,
      contrasena: contrasena,
      id: id);
}
