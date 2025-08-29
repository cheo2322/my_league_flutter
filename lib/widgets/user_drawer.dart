import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/main.dart';
import 'package:my_league_flutter/screens/login/login_page.dart';
import 'package:my_league_flutter/screens/login/signup_page.dart';

class UserDrawer extends StatelessWidget {
  const UserDrawer({super.key});

  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  static const redColor = Color.fromARGB(255, 239, 39, 25);

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
        backgroundColor: redColor,
        duration: Duration(seconds: 3),
      ),
    );

    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
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

          return ListView(
            children: [
              FutureBuilder<String?>(
                future: _getUsername(),
                builder: (context, usernameSnapshot) {
                  if (usernameSnapshot.connectionState == ConnectionState.waiting) {
                    return DrawerHeader(
                      decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                      child: const Center(child: CircularProgressIndicator(color: Colors.white)),
                    );
                  }

                  final username = usernameSnapshot.data;
                  return DrawerHeader(
                    decoration: BoxDecoration(color: Theme.of(context).primaryColor),
                    child: Center(
                      child: Text(
                        username ??
                            'Inicia sesión o crea una cuenta para ver las opciones de usuario',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                },
              ),

              if (!tokenExists)
                ListTile(
                  leading: Icon(Icons.login, color: Theme.of(context).primaryColor),
                  title: const Text('Iniciar sesión'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const LoginPage()),
                    );
                  },
                ),
              if (!tokenExists)
                ListTile(
                  leading: Icon(Icons.person_add, color: Theme.of(context).primaryColor),
                  title: const Text('Crear cuenta'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SignupPage()),
                    );
                  },
                ),

              const Spacer(),

              if (tokenExists)
                ListTile(
                  leading: const Icon(Icons.logout, color: redColor),
                  title: const Text('Cerrar sesión', style: TextStyle(color: redColor)),
                  onTap: () => _logout(context),
                ),
            ],
          );
        },
      ),
    );
  }
}
