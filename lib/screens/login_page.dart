import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class LeagueService {
  Future<String> login(String username, String password) async {
    await Future.delayed(const Duration(seconds: 1));
    return 'simulated_token_12345';
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();
    final FlutterSecureStorage secureStorage = FlutterSecureStorage();
    final LeagueService leagueService = LeagueService();

    Future<void> handleLogin() async {
      final token = await leagueService.login(
        usernameController.text,
        passwordController.text,
      );

      await secureStorage.write(key: 'auth_token', value: token);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login exitoso y token guardado')),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Login'), backgroundColor: Colors.blue),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Iniciar sesión',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                labelText: 'Usuario',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Contraseña',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: handleLogin,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 50,
                    vertical: 15,
                  ),
                ),
                child: const Text('Entrar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
