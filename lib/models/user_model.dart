// To parse this JSON data, do
//
//     final user = userFromJson(jsonString);

import 'dart:convert';

class UserModel {
  UserModel(
      {this.id,
      required this.mail,
      required this.password});

  int? id;
  String mail;
  String password;

  factory UserModel.fromRawJson(String str) =>
      UserModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
      id: json["id"],
      mail: json["mail"],
      password: json["password"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "mail": mail,
        "password": password};

  UserModel copy() => UserModel(
      mail: mail,
      password: password,
      id: id);
}
