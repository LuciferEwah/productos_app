import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';

class PlanListProvider extends ChangeNotifier {
  bool isLoading = true;
  late PlanModel selectedPlan;
  List<PlanModel> _plans = [];
  int? idPlan;

  List<PlanModel> get plans => _plans;

  PlanListProvider() {
    cargarPlan();
    selectedPlan = PlanModel(
        nombre: '',
        precioMensual: 0,
        duracionMeses: 0,
        renovacionAutomatica: 0);
  }

  Future<PlanModel> newPlan({
    required String nombre,
    required double precioMensual,
    required int duracionMeses,
    required int renovacionAutomatica,
  }) async {
    final newPlan = PlanModel(
      nombre: nombre,
      precioMensual: precioMensual,
      duracionMeses: duracionMeses,
      renovacionAutomatica: renovacionAutomatica,
    );

    // Guarda el nuevo plan en la base de datos y obtiene el PlanModel con ID asignado
    final planWithId = await DBProvider.db.newPlan(newPlan);

    // Asigna el ID generado por la base de datos al nuevo plan
    newPlan.id = planWithId.id;

    _plans.add(newPlan);
    notifyListeners();
    return newPlan;
  }

  Future<List<PlanModel>> cargarPlan() async {
    isLoading = true;
    notifyListeners();
    final plans = await DBProvider.db.getPlans();

    if (plans.isNotEmpty) {
      isLoading = false;
      notifyListeners();
      return [];
    }
    _plans = [...plans];
    isLoading = false;
    notifyListeners();
    return plans;
  }

  deleteById(int? id) async {
    if (id != null) {
      await DBProvider.db.deletePlanByID(id);
      cargarPlan();
    }
  }

  update(plan) async {
    await DBProvider.db.updatePlan(plan);
    cargarPlan();
  }
}
