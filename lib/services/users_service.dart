import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:http/http.dart' as http;
import '../providers/provider.dart';

class UsersService extends ChangeNotifier {
  final String _baseURL =
      'flutter-appproductos-9027f-default-rtdb.firebaseio.com';

  UsersService();

  Future<void> syncUsersToFirebase() async {
    final connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult != ConnectivityResult.none) {
      final url = Uri.https(_baseURL, 'usuarios.json');
      final resp = await http.get(url);

      List<UserModel> firebaseUsers = [];

      if (resp.body == 'null' || resp.body.isEmpty || resp.body == '""') {
        print('No se han encontrado usuarios en Firebase.');
      } else {
        dynamic responseBody = json.decode(resp.body);

        // Check if the responseBody is a List
        if (responseBody is List<dynamic>) {
          // Remove the first null element, if present
          if (responseBody.isNotEmpty && responseBody[0] == null) {
            responseBody.removeAt(0);
          }

          firebaseUsers = responseBody
              .where((element) => element is Map<String, dynamic>)
              .map((element) => UserModel.fromJson(element)..id = element['id'])
              .toList();
        } else {
          print('Formato de respuesta inesperado');
        }
      }

      final sqliteUsers = await DBProvider.db.getUserAll();

      // Adding users to Firebase
      final usersToAdd = sqliteUsers.where((sqliteUser) => !firebaseUsers
          .any((firebaseUser) => firebaseUser.id == sqliteUser.id));

      for (final userToAdd in usersToAdd) {
        final addUrl = Uri.https(_baseURL, 'usuarios/${userToAdd.id}.json');
        await http.put(addUrl, body: json.encode(userToAdd.toJson()));
      }

      // Updating users in Firebase
      final usersToUpdate = sqliteUsers.where((sqliteUser) => firebaseUsers.any(
          (firebaseUser) =>
              firebaseUser.id == sqliteUser.id && firebaseUser != sqliteUser));

      for (final userToUpdate in usersToUpdate) {
        final updateUrl =
            Uri.https(_baseURL, 'usuarios/${userToUpdate.id}.json');
        await http.put(updateUrl, body: json.encode(userToUpdate.toJson()));
      }

      // Deleting users from Firebase
      final usersToDelete = firebaseUsers.where((firebaseUser) =>
          !sqliteUsers.any((sqliteUser) => sqliteUser.id == firebaseUser.id));

      for (final userToDelete in usersToDelete) {
        final deleteUrl =
            Uri.https(_baseURL, 'usuarios/${userToDelete.id}.json');
        await http.delete(deleteUrl);
      }
    } else {
      print('Sin conectividad de red');
    }
  }
}
