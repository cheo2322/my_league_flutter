import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({super.key});

  @override
  Widget build(BuildContext context) {
    final TextEditingController passwordController = TextEditingController();
    final TextEditingController confirmPasswordController =
        TextEditingController();

    bool hasMinLength(String value) => value.length >= 8;
    bool hasNumber(String value) => value.contains(RegExp(r'\d'));

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

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              decoration: const InputDecoration(labelText: 'Correo'),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 16.0),
            TextField(decoration: const InputDecoration(labelText: 'Username')),
            const SizedBox(height: 16.0),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Contraseña'),
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
                  style:
                      Theme.of(context).textTheme.titleMedium, // Updated here
                ),
                Row(
                  children: [
                    Icon(
                      hasMinLength(passwordController.text)
                          ? Icons.check
                          : Icons.close,
                    ),
                    const SizedBox(width: 8.0),
                    const Text('Mínimo 8 caracteres'),
                  ],
                ),
                Row(
                  children: [
                    Icon(
                      hasNumber(passwordController.text)
                          ? Icons.check
                          : Icons.close,
                    ),
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
                    !hasMinLength(passwordController.text) ||
                    !hasNumber(passwordController.text) ||
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
