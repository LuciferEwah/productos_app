import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';



class SuscriptionCompraListProvider extends ChangeNotifier {
  List<CompraSuscripcion> compraSus = [];
  bool isLoading = true;

  SuscriptionCompraListProvider() {
    cargarCompraSuscripcion();
  }

  Future<void> newCompraSuscripcion(CompraSuscripcion compraSuscripcion) async {
    await DBProvider.db.newCompraSuscripcion(compraSuscripcion);
    compraSus.add(compraSuscripcion);
    notifyListeners();
  }

  Future<List<CompraSuscripcion>> cargarCompraSuscripcion() async {
    isLoading = true;
    notifyListeners();
    final compraSus = await DBProvider.db.getCompraSuscripcionesAll();
    if (compraSus == null) {
      isLoading = false;
      notifyListeners();
      return [];
    }
    this.compraSus = [...compraSus];
    isLoading = false;
    notifyListeners();
    return this.compraSus;
  }
}