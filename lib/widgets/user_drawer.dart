import 'package:flutter/material.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(color: Colors.blue),
            child: Text('Menú Deslizable'),
          ),
          ListTile(
            title: const Text('Opción 1'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opción 1 seleccionada')),
              );
            },
          ),
          ListTile(
            title: const Text('Opción 2'),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Opción 2 seleccionada')),
              );
            },
          ),
        ],
      ),
    );
  }
}
