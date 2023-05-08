import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/db_provider.dart';

class PlanListProvider extends ChangeNotifier {
  List<PlanModel> plans = [];
  bool isLoading = true;
  late PlanModel selectedPlan;

  PlanListProvider() {
    cargarPlan();
    selectedPlan = PlanModel(
        nombre: '',
        precioMensual: 0,
        duracionMeses: 0,
        renovacionAutomatica: 0);
  }

  newPlan(
      {required String nombre,
      required double precioMensual,
      int? id,
      required int duracionMeses,
      required int renovacionAutomatica}) async {
    final newPlan = PlanModel(
      nombre: nombre,
      precioMensual: precioMensual,
      duracionMeses: duracionMeses,
      renovacionAutomatica: renovacionAutomatica,
      id: id,
    );

    await DBProvider.db.newPlan(newPlan);
    plans.add(newPlan);
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
    plans = [...Plans];
    isLoading = false;
    notifyListeners();
    return plans;
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

 /*  Future<void> realizarVenta(double subtotal, double iva, double total, 
      int? usuarioId, Map<int, int> cantidadSeleccionada) async {
    // Crear una instancia de VentaModel
    VentaModel venta = VentaModel(
      fecha: DateTime.now().toString(),
      total: total,
      usuarioId: usuarioId, // Aquí puedes proporcionar el ID de usuario actual
    );

    // Llamar a la función addVenta() para agregar la venta a la base de datos
    int ventaId = await DBProvider.db.addVenta(venta);}

 Agregar detalles de la venta
    for (int index = 0; index < productsForCard.length; index++) {
      ProductModel product = productsForCard[index];

      // Utiliza el ID del producto en lugar del índice para acceder a la cantidad
      int cantidadProducto = cantidadSeleccionada[product.id!] ?? 1;

      DetalleVentaModel detalleVenta = DetalleVentaModel(
        ventaId: ventaId,
        productoId: product.id!,
        cantidad: cantidadProducto, // Usa la cantidad seleccionada aquí
        subtotal:
            product.precio * cantidadProducto, // Modifica el subtotal aquí
      );
      await DBProvider.db.addDetalleVenta(detalleVenta);


      cargarProduct();*/
    
}
