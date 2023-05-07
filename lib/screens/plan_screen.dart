import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/planes_model.dart';
import '../providers/provider.dart';
import '../widgets/widgets.dart';

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
    //final productListProvider = Provider.of<PlanListProvider>(context);
    return Scaffold(
      body: ListView.builder(
        itemCount: plans.length,
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            child: PlanCard(
              plan: plans[index],
              //planListProvider: productListProvider,
            ), // Replace ListTile with PlanCard
            onTap: () {
              //TODO: AQui se debe hacer una copia para poder hacer el update de los planes
            },
          );
        },
      ),
    );
  }
}
