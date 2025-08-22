import 'package:flutter/material.dart';
import 'package:my_league_flutter/web/auth_service.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  AuthService authService = AuthService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final FocusNode emailFocusNode = FocusNode();

  bool hasMinLength = false;
  bool hasNumber = false;
  bool passwordsMatch = true;
  String? emailErrorText;

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

  @override
  void initState() {
    super.initState();
    emailFocusNode.addListener(() {
      if (!emailFocusNode.hasFocus) {
        setState(() {
          emailErrorText = _validateEmail(emailController.text);
        });
      }
    });
  }

  @override
  void dispose() {
    emailFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear Cuenta')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomTextField(
              'Correo electrónico*',
              TextInputType.emailAddress,
              emailController,
              focusNode: emailFocusNode,
              errorText: emailErrorText,
            ),
            const SizedBox(height: 16.0),
            _buildCustomTextField(
              'Usuario*',
              TextInputType.text,
              usernameController,
            ),
            const SizedBox(height: 16.0),
            _buildCustomTextField(
              'Contraseña*',
              TextInputType.text,
              passwordController,
              obscureText: true,
              onChanged: validatePassword,
            ),
            const SizedBox(height: 16.0),
            _buildCustomTextField(
              'Repetir Contraseña*',
              TextInputType.text,
              confirmPasswordController,
              obscureText: true,
              onChanged: validateConfirmPassword,
              errorText: passwordsMatch ? null : 'Las contraseñas no coinciden',
              trailingIcon:
                  confirmPasswordController.text.isEmpty
                      ? null
                      : passwordsMatch
                      ? const Icon(Icons.check, color: Colors.green)
                      : const Icon(Icons.close, color: Colors.red),
            ),
            const SizedBox(height: 16.0),
            _buildPasswordRequirements(context),
            const SizedBox(height: 16.0),
            ElevatedButton(
              onPressed: () {
                if (passwordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty ||
                    !hasMinLength ||
                    !hasNumber ||
                    !passwordsMatch) {
                  _showAlert(
                    'Por favor, asegúrate de llenar todos los campos correctamente.',
                  );
                } else {
                  authService
                      .register(
                        username: usernameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      )
                      .then((result) {
                        if (result == "nothing") {
                          _showAlert(
                            'Este correo electrónico ya se encuentra registrado.',
                          );
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Cuenta creada exitosamente'),
                            ),
                          );
                          Navigator.pop(context);
                        }
                      });
                }
              },
              child: const Text('Crear Cuenta'),
            ),
          ],
        ),
      ),
    );
  }

  void _showAlert(String message) {
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

  Widget _buildCustomTextField(
    String labelText,
    TextInputType keyboardType,
    TextEditingController? controller, {
    bool obscureText = false,
    String? errorText,
    FocusNode? focusNode,
    Function(String)? onChanged,
    Widget? trailingIcon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      decoration: BoxDecoration(
        border: Border.all(color: errorText == null ? Colors.grey : Colors.red),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              obscureText: obscureText,
              keyboardType: keyboardType,
              focusNode: focusNode,
              decoration: InputDecoration(
                labelText: labelText,
                border: InputBorder.none,
                errorText: errorText,
              ),
              onChanged: onChanged,
            ),
          ),
          if (trailingIcon != null) trailingIcon,
        ],
      ),
    );
  }

  Widget _buildPasswordRequirements(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Requisitos de la contraseña:',
          style: Theme.of(context).textTheme.titleMedium,
        ),
        Row(
          children: [
            Icon(
              hasMinLength ? Icons.check : Icons.close,
              color: hasMinLength ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8.0),
            const Text('Mínimo 8 caracteres'),
          ],
        ),
        Row(
          children: [
            Icon(
              hasNumber ? Icons.check : Icons.close,
              color: hasNumber ? Colors.green : Colors.red,
            ),
            const SizedBox(width: 8.0),
            const Text('Al menos un número'),
          ],
        ),
        Row(
          children: [
            Icon(
              confirmPasswordController.text.isNotEmpty
                  ? (passwordsMatch ? Icons.check : Icons.close)
                  : Icons.close,
              color:
                  confirmPasswordController.text.isNotEmpty
                      ? (passwordsMatch ? Colors.green : Colors.red)
                      : Colors.red,
            ),
            const SizedBox(width: 8.0),
            const Text('Las contraseñas coinciden'),
          ],
        ),
      ],
    );
  }

  String? _validateEmail(String email) {
    if (email.isEmpty) {
      return "El correo es obligatorio";
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      return "El formato del correo es incorrecto";
    }
    return null;
  }
}
