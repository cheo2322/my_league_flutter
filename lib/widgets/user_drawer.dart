import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/screens/login_page.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  Future<String?> _getUsername() async {
    const FlutterSecureStorage secureStorage = FlutterSecureStorage();
    return await secureStorage.read(key: 'username');
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          FutureBuilder<String?>(
            future: _getUsername(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Container(
                  color: Colors.blue,
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: const Center(
                    child: CircularProgressIndicator(color: Colors.white),
                  ),
                );
              }

              final username = snapshot.data;
              return Container(
                color: Colors.blue,
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                child: Center(
                  child: Text(
                    username != null ? 'Hola, $username' : 'Usuario',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.login, color: Colors.blue),
            title: const Text('Iniciar sesión'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.settings, color: Colors.blue),
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
