import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/plan_list_provider.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    Key? key,
    required this.plan,
    this.trailing, // Agrega el parámetro aquí
    required this.planListProvider, // Agrega la instancia de PlanListProvider
  }) : super(key: key);

  final PlanModel plan;
  final Widget? trailing; // Declara el parámetro aquí
  final PlanListProvider planListProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 35),
      child: Container(
        width: double.infinity,
        height: 400,
        decoration: _cardBorders(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Detailsplan(
              plan: plan,
              planListProvider: planListProvider,
            ),
            if (trailing != null) // Agrega la condición para mostrar el widget
              trailing!,
          ],
        ),
      ),
    );
  }
}

BoxDecoration _cardBorders() => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        boxShadow: const [
          BoxShadow(
              color: Colors.black38, blurRadius: 10, offset: Offset(0, 5)),
        ]);

class _Detailsplan extends StatelessWidget {
  const _Detailsplan({
    required this.plan,
    required this.planListProvider, // Agrega la instancia de planListProvider
  });

  final PlanModel plan;
  final PlanListProvider
      planListProvider; // Declara la instancia de planListProvider

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 50),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        width: double.infinity,
        height: 70,
        decoration: _buildBoxDecoration(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(plan.nombre,
                    style: const TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(plan.id.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(plan.precioMensual.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis),
                Text(plan.duracionMeses.toString(),
                    style: const TextStyle(color: Colors.black, fontSize: 15),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis)
              ],
            ),
          ],
        ),
      ),
    );
  }

  BoxDecoration _buildBoxDecoration() => BoxDecoration(
      borderRadius: const BorderRadius.only(
          bottomLeft: Radius.circular(25), topRight: Radius.circular(25)),
      color: Colors.orange[700]);
}
