import 'package:flutter/material.dart';
import '../models/planes_model.dart';

class PlanScreen extends StatelessWidget {
  PlanScreen({Key? key}) : super(key: key);

  // A sample list of data to display in the ListView.builder
  final List<PlanModel> plans = [
    PlanModel(
      id: 1,
      nombre: 'Plan 1',
      precioMensual: 9.99,
      duracionMeses: 1,
      renovacionAutomatica: true,
    ),
    PlanModel(
      id: 2,
      nombre: 'Plan 2',
      precioMensual: 24.99,
      duracionMeses: 3,
      renovacionAutomatica: true,
    )
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(plans[index].nombre),
            subtitle: Text(
              'Precio mensual: \$${plans[index].precioMensual} - Duración: ${plans[index].duracionMeses} meses',
            ),
            // Add any additional customization you want for each list item here
          );
        },
      ),
    );
  }
}
