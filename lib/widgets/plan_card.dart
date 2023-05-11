import 'package:flutter/material.dart';
import 'package:productos_app/models/models.dart';
import 'package:provider/provider.dart';
import 'package:productos_app/providers/provider.dart';

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
    final userListProvider = Provider.of<UserListProvider>(context);
    final suscriptionListProvider =       Provider.of<SuscriptionListProvider>(context);
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
                onPressed: () async {
                  print('BOTON COMPRAR EN PLANES');

                  // Crea una nueva suscripción
                  var fechaInicio = DateTime.now();
                  var suscripcion = Suscripciones(
                    fechaInicio: fechaInicio,
                    fechaFin: fechaInicio
                        .add(Duration(days: plan.duracionMeses * 30)),
                    estado: 'Activo',
                    idUsuario: 150,//TODO: clave valor esa wea //userListProvider.idUser
                    idPlan: plan.id!,
                  );

                  // Guarda la suscripción en la base de datos
                  await suscriptionListProvider.addSubscription(suscripcion);

                  // Actualiza la UI
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Plan comprado exitosamente!'),
                    ),
                  );
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
