import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';

class PlanListProvider extends ChangeNotifier {
  List<PlanModel> Plans = [];
  bool isLoading = true;

  PlanListProvider() {
    cargarPlan();
  }

  newPlan(PlanModel Plan,
      {required String nombre,
      required double precioMensual,
      int? id,
      required int duracionMeses,
      required bool renovacionAutimatica}) async {
    final newPlan = PlanModel(
      nombre: nombre,
      precioMensual: precioMensual,
      duracionMeses: duracionMeses,
      renovacionAutomatica: renovacionAutimatica,
      id: id,
    );

    await DBProvider.db.newPlan(newPlan);
    Plans.add(newPlan);
    notifyListeners();
  }

  Future<List<PlanModel>> cargarPlan() async {
    isLoading = true;
    notifyListeners();
    final Plans = await DBProvider.db.getPlans();
    // ignore: unnecessary_null_comparison
    if (Plans == null) {
      isLoading = false;
      notifyListeners();
      return [];
    }
    this.Plans = [...Plans];
    isLoading = false;
    notifyListeners();
    return this.Plans;
  }

  /* PORSIACASO
  Future<bool> checkPlanExists(
      {required String email, required String contrasena}) async {
    final Plans = await DBProvider.db.getPlanEmail(email);
    return Plans != null &&
        Plans.any(
            (Plan) => Plan.email == email && Plan.contrasena == contrasena);
  }
  */

  deleteById(int? id) async {
    if (id != null) {
      await DBProvider.db.deletePlanByID(id);
      cargarPlan();
    }
  }

  update(Plan) async {
    await DBProvider.db.updatePlan(Plan);
    cargarPlan();
  }
}
