import 'package:flutter/material.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  bool hasMinLength = false;
  bool hasNumber = false;

  void validatePassword(String password) {
    setState(() {
      hasMinLength = password.length >= 8;
      hasNumber = password.contains(RegExp(r'\d'));
    });
  }

  void showAlert(String message) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Error'),
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Correo*'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(decoration: const InputDecoration(labelText: 'Usuario*')),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
              onChanged: validatePassword,
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: confirmPasswordController,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: 'Repetir Contraseña',
              ),
            ),
            const SizedBox(height: 16.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Requisitos de la contraseña:',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                Row(
                  children: [
                    Icon(hasMinLength ? Icons.check : Icons.close),
                    const SizedBox(width: 8.0),
                    const Text('Mínimo 8 caracteres'),
                  ],
                ),
                Row(
                  children: [
                    Icon(hasNumber ? Icons.check : Icons.close),
                    const SizedBox(width: 8.0),
                    const Text('Al menos un número'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (passwordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty ||
                    !hasMinLength ||
                    !hasNumber ||
                    passwordController.text != confirmPasswordController.text) {
                  showAlert(
                    'Por favor, asegúrate de llenar todos los campos correctamente.',
                  );
                } else {
                  // Lógica para crear la cuenta
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cuenta creada exitosamente')),
                  );
                }
              },
              child: const Text('Crear Cuenta'),
            ),
          ],
        ),
      ),
    );
  }
}
