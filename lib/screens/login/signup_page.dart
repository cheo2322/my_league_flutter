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
  bool passwordsMatch = true;

  void validatePassword(String password) {
    setState(() {
      hasMinLength = password.length >= 8;
      hasNumber = password.contains(RegExp(r'\d'));
    });
  }

  void validateConfirmPassword(String confirmPassword) {
    setState(() {
      passwordsMatch = passwordController.text == confirmPassword;
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
            _buildCustomTextField('Correo*', TextInputType.emailAddress, null),
            const SizedBox(height: 16.0),
            _buildCustomTextField('Usuario*', TextInputType.text, null),
            const SizedBox(height: 16.0),
            _buildCustomTextField(
              'Contraseña',
              TextInputType.text,
              passwordController,
              obscureText: true,
              onChanged: validatePassword,
            ),
            const SizedBox(height: 16.0),
            _buildCustomTextField(
              'Repetir Contraseña',
              TextInputType.text,
              confirmPasswordController,
              obscureText: true,
              onChanged: validateConfirmPassword,
              errorText: passwordsMatch ? null : 'Las contraseñas no coinciden',
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
                    !passwordsMatch) {
                  showAlert(
                    'Por favor, asegúrate de llenar todos los campos correctamente.',
                  );
                } else {
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

  Widget _buildCustomTextField(
    String labelText,
    TextInputType keyboardType,
    TextEditingController? controller, {
    bool obscureText = false,
    String? errorText,
    Function(String)? onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        border: Border.all(color: errorText == null ? Colors.grey : Colors.red),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: labelText,
          border: InputBorder.none,
          errorText: errorText,
        ),
        onChanged: onChanged,
      ),
    );
  }
}
