import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/user_model.dart';
import '../providers/user_list_provider.dart';

class UserListPage extends StatelessWidget {
  const UserListPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final userListProvider = Provider.of<UserListProvider>(context);
    final users = userListProvider.users;

    return Scaffold(
      backgroundColor: Colors.white, // Added white background
      appBar: AppBar(
        title: const Text('User List'),
      ),
      body: users.isEmpty
          ? const Center(child: Text('No users found'))
          : ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
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
                  onDismissed: (_) {
                    userListProvider.deleteById(user.id);
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.grey.shade400,
                        width: 1,
                      ),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListTile(
                      title: Text(user.email),
                      subtitle: Text('ID: ${user.id}'),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
