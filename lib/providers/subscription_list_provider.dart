import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';



/* TODO: LISTA DE SUSCRIPTORES
class SuscriptionListProvider extends ChangeNotifier {
  List<UserModel> users = [];
  bool isLoading = true;
  late UserModel selectedUser;
  int? idUser;

  UserListProvider() {
    cargarUser();
    selectedUser = UserModel(email: '', contrasena: '');
  }

  newUser(UserModel user,
      {required String email, required String contrasena, int? id}) async {
    final newUser = UserModel(
      email: email,
      contrasena: contrasena,
      id: id,
    );

    await DBProvider.db.newUser(newUser);
    users.add(newUser);
    notifyListeners();
  }

  Future<List<UserModel>> cargarUser() async {
    isLoading = true;
    notifyListeners();
    final users = await DBProvider.db.getUserAll();
    // ignore: unnecessary_null_comparison
    if (users == null) {
      isLoading = false;
      notifyListeners();
      return [];
    }
    this.users = [...users];
    isLoading = false;
    notifyListeners();
    return this.users;
  }

  Future<bool> checkUserExists(
      {required String email, required String contrasena}) async {
    final users = await DBProvider.db.getUserEmail(email);
    return users != null &&
        users.any(
            (user) => user.email == email && user.contrasena == contrasena);
  }

  Future<int?> getIdByEmail(String email) async {
    final db = await DBProvider.db.database;
    final res =
        await db!.query('USUARIO', where: 'email = ?', whereArgs: [email]);
    int? userId = res.isNotEmpty ? res.first['id'] as int? : null;

    return userId;
  }

  deleteById(int? id) async {
    if (id != null) {
      await DBProvider.db.deleteUserById(id);
      cargarUser();
    }
  }


  update(user) async {
    await DBProvider.db.updateUser(user);
    cargarUser();
  }
}
*/
