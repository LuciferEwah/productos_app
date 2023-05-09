import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:productos_app/providers/plan_list_provider.dart';

class PlanCard extends StatelessWidget {
  const PlanCard({
    Key? key,
    required this.plan,
    this.trailing,
    this.planListProvider,
  }) : super(key: key);

  final PlanModel plan;
  final Widget? trailing;
  final PlanListProvider? planListProvider;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: _DetailsPlan(
                  plan: plan,
                  planListProvider: planListProvider,
                ),
              ),
              if (trailing != null) trailing!,
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  print('AAAAAAA'); //TODO: agregar logica de compra
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  'Comprar',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DetailsPlan extends StatelessWidget {
  const _DetailsPlan({
    required this.plan,
    required this.planListProvider,
  });

  final PlanModel plan;
  final PlanListProvider? planListProvider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          plan.nombre,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 8),
        Text(
          'ID: ${plan.id}',
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 20,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'Precio mensual: \$${plan.precioMensual}',
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 20,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Text(
          'Duración: ${plan.duracionMeses} meses',
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 20,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    );
  }
}
