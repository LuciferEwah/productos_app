import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_list_provider.dart';
import '../providers/user_list_provider.dart';

class AdminSubScreen extends StatelessWidget {
  const AdminSubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final suscriptionListProvider = Provider.of<SuscriptionListProvider>(context);
    final userListProvider = Provider.of<UserListProvider>(context);
    final suscriptions = suscriptionListProvider.suscripciones;

    return Scaffold(
      backgroundColor: Colors.white, // Added white background
      appBar: AppBar(
        title: Text('Suscripciones Activas'),
      ),
      body: suscriptions.isEmpty
          ? const Center(child: Text('No hay suscripciones Activas'))
          : ListView.builder(
              itemCount: suscriptions.length,
              itemBuilder: (context, index) {
                final suscription = suscriptions[index];
                return Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade400,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: ListTile(
                    title: FutureBuilder<String?>(
                      future: userListProvider.getEmailById(suscription.idUsuario!),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          final email = snapshot.data ?? '';
                          return Text(email);
                        } else {
                          return const SizedBox.shrink();
                        }
                      },
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('ID Plan: ${suscription.idPlan}'),
                        Text('Fecha Inicio: ${suscription.fechaInicio}'),
                        Text('Fecha Fin: ${suscription.fechaFin}'),
                        Text('ID Usuario: ${suscription.idUsuario}'),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
