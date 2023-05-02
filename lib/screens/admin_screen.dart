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
                    child: const Icon(
                      Icons.delete,
                      color: Colors.white,
                      size: 36,
                    ),
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 16),
                  ),
                  direction: DismissDirection.endToStart,
                  onDismissed: (_) {
                    userListProvider.deleteById(user.id);
                  },
                  child: ListTile(
                    title: Text(user.email),
                    subtitle: Text(user.id.toString()),
                  ),
                );
              },
            ),
    );
  }
}
