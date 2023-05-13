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
    final suscriptionListProvider =
        Provider.of<SuscriptionListProvider>(context);
    final suscriptionCompraListProvider =
        Provider.of<SuscriptionCompraListProvider>(context);

    bool checkSuscripcion = false;// TODO CHECKEAR DE VERDAD
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
                onPressed: checkSuscripcion
                    // ignore: dead_code
                    ? () async {
                        print('BOTON COMPRAR EN PLANES');

                        // Crea una nueva suscripción
                        var fechaInicio = DateTime.now();
                        var suscripcion = Suscripciones(
                          fechaInicio: fechaInicio,
                          fechaFin:
                              fechaInicio.add(Duration(days: plan.duracionMeses * 30)),
                          estado: 'Activo',
                          idUsuario:
                              150, //TODO: clave valor esa wea // idUsuario=userListProvider.idUser
                          idPlan: plan.id!,
                        );
                        await suscriptionListProvider.addSubscription(suscripcion);

                        // Create a new CompraSuscripcion
                        var compraSuscripcion = CompraSuscripcion(
                          usuarioId:
                              150, //TODO: clave valor esa wea // idUsuario=userListProvider.idUser
                          suscripcionId: suscripcion
                              .id!, // assuming suscripcion.id is set after addSubscription
                          fechaCompra: fechaInicio,// sale en string el datetime por alguna razon(causa: base dinamica xdd)
                          total: plan.precioMensual,
                        );

                        // Guarda la suscripción en la base de datos
                        await suscriptionCompraListProvider
                            .newCompraSuscripcion(compraSuscripcion);

                        // Actualiza la UI
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Plan comprado exitosamente!'),
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: checkSuscripcion ? Colors.orange[700] : Colors.grey[500],
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  // ignore: dead_code
                  checkSuscripcion ? 'Comprar' : 'Suscripcion Activa',
                  style: TextStyle(
                    color: checkSuscripcion ? Colors.black : Colors.black,
                  ),
                ),
              )
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
