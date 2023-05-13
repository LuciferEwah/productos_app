import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/subscription_list_provider.dart';
import '../providers/user_list_provider.dart';

class AdminSubScreen extends StatelessWidget {
  const AdminSubScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /*
    final userListProvider = Provider.of<UserListProvider>(context);
    final users = userListProvider.users;*/
    final suscriptionListProvider = Provider.of<SuscriptionListProvider>(context);
    final suscriptions = suscriptionListProvider.suscripciones;

    return Scaffold(
      backgroundColor: Colors.white, // Added white background
      appBar: AppBar(
        title: const Text('Suscripciones Activas'),
      ),
      body: suscriptions.isEmpty
          ? const Center(child: Text('No suscription found'))
          : ListView.builder(
              itemCount: suscriptions.length,
              itemBuilder: (context, index) {
                final suscription = suscriptions[index];
                return Dismissible(
                  key: UniqueKey(),
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 36,
                    ),
                  ),
                  direction: DismissDirection.endToStart,
                  /*
                  onDismissed: (_) {
                    suscriptionListProvider.deleteById(user.id);
                  },*/
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(suscription.estado),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('ID: ${suscription.id}'),
                          Text('Fecha Inicio: ${suscription.fechaInicio}'),
                          Text('Fecha Fin: ${suscription.fechaFin}'),
                          Text('IdUsuario: ${suscription.idUsuario}'),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
