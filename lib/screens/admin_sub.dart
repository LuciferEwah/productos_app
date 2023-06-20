import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_list_provider.dart';

class KPIDashboardScreen extends StatelessWidget {
  const KPIDashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suscriptionListProvider =
        Provider.of<SuscriptionListProvider>(context);
    final suscriptions = suscriptionListProvider.suscripciones;

    // Aquí calculamos los KPI.
    int totalSuscriptions = suscriptions.length;
    int activeSuscriptions =
        suscriptions.where((s) => s.estado == 'Activo').length;
    int inactiveSuscriptions =
        suscriptions.where((s) => s.estado == 'Inactivo').length;
    double averageSuscriptionDuration = suscriptions.fold(
            0,
            (sum, s) =>
                sum +
                (s.fechaFin.millisecondsSinceEpoch -
                    s.fechaInicio.millisecondsSinceEpoch)) /
        totalSuscriptions;
    averageSuscriptionDuration = averageSuscriptionDuration /
        (24 * 60 * 60 * 1000); // Convertir milisegundos a días

    return Scaffold(
      appBar: AppBar(
        title: const Text('KPI de Suscripciones'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Total de suscripciones: $totalSuscriptions'),
            Text('Suscripciones activas: $activeSuscriptions'),
            Text('Suscripciones inactivas: $inactiveSuscriptions'),
            Text(
                'Duración promedio de suscripción: ${averageSuscriptionDuration.toStringAsFixed(2)} días'),
            // Agrega más KPI según tus necesidades.
          ],
        ),
      ),
    );
  }
}
