import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/main.dart';
import 'package:my_league_flutter/screens/login_page.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  Future<String?> _getToken() async {
    return await secureStorage.read(key: 'auth_token');
  }

  Future<String?> _getUsername() async {
    return await secureStorage.read(key: 'username');
  }

  Future<void> _logout(BuildContext context) async {
    await secureStorage.deleteAll();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Sesión cerrada correctamente'),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 3),
      ),
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomePage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: FutureBuilder<String?>(
        future: _getToken(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final tokenExists = snapshot.data != null;

          return Column(
            children: [
              FutureBuilder<String?>(
                future: _getUsername(),
                builder: (context, usernameSnapshot) {
                  if (usernameSnapshot.connectionState ==
                      ConnectionState.waiting) {
                    return Container(
                      color: Colors.blue,
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: const Center(
                        child: CircularProgressIndicator(color: Colors.white),
                      ),
                    );
                  }

                  final username = usernameSnapshot.data;
                  return Container(
                    color: Colors.blue,
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Text(
                        username ??
                            'Inicia sesión o crea una cuenta para ver las opciones de usuario',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  );
                },
              ),

              if (!tokenExists)
                ListTile(
                  leading: const Icon(Icons.login, color: Colors.blue),
                  title: const Text('Iniciar sesión'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),
              if (!tokenExists)
                ListTile(
                  leading: const Icon(Icons.person_add, color: Colors.blue),
                  title: const Text('Crear cuenta'),
                  onTap: () {
                    // TODO: Create page to create account
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const LoginPage(),
                      ),
                    );
                  },
                ),

              ListTile(
                leading: const Icon(Icons.settings, color: Colors.blue),
                title: const Text('Configuraciones'),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opción 2 seleccionada')),
                  );
                },
              ),
              const Spacer(),
              if (tokenExists)
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () => _logout(context),
                ),
            ],
          );
        },
      ),
    );
  }
}
