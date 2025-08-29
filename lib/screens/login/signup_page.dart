import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/main.dart';
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
  final TextEditingController confirmPasswordController = TextEditingController();
  final FocusNode emailFocusNode = FocusNode();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

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
    final primaryColor = Theme.of(context).primaryColor;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crear Cuenta', style: TextStyle(color: Colors.white)),
        backgroundColor: primaryColor,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildCustomTextField(
              primaryColor,
              'Correo electrónico*',
              TextInputType.emailAddress,
              emailController,
              focusNode: emailFocusNode,
              errorText: emailErrorText,
            ),
            const SizedBox(height: 16.0),
            // TODO: Add in v2
            // _buildCustomTextField('Usuario*', TextInputType.text, usernameController),
            // const SizedBox(height: 16.0),
            _buildCustomTextField(
              primaryColor,
              'Contraseña*',
              TextInputType.text,
              passwordController,
              obscureText: true,
              onChanged: validatePassword,
            ),
            const SizedBox(height: 16.0),
            _buildCustomTextField(
              primaryColor,
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
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
              ),
              onPressed: () {
                if (passwordController.text.isEmpty ||
                    confirmPasswordController.text.isEmpty ||
                    !hasMinLength ||
                    !hasNumber ||
                    !passwordsMatch) {
                  _showAlert('Por favor, asegúrate de llenar todos los campos correctamente.');
                } else {
                  authService
                      .register(
                        username: usernameController.text,
                        email: emailController.text,
                        password: passwordController.text,
                      )
                      .then((result) {
                        if (result == null) {
                          _showAlert('Este correo electrónico ya se encuentra registrado.');
                        } else {
                          secureStorage.write(key: 'username', value: result.email);
                          secureStorage.write(key: 'auth_token', value: result.token);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Cuenta creada exitosamente'),
                              backgroundColor: primaryColor,
                              duration: const Duration(seconds: 3),
                            ),
                          );

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (context) => const HomePage()),
                          );
                        }
                      });
                }
              },
              child: const Text('Crear Cuenta', style: TextStyle(color: Colors.white)),
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
              TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('OK')),
            ],
          ),
    );
  }

  Widget _buildCustomTextField(
    Color primaryColor,
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
      padding: const EdgeInsets.symmetric(vertical: 2.0),
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
                border: const OutlineInputBorder(),
                errorText: errorText,
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                floatingLabelStyle: TextStyle(color: primaryColor),
              ),
              cursorColor: primaryColor,
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
        Text('Requisitos de la contraseña:', style: Theme.of(context).textTheme.titleMedium),
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

    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');

    if (!emailRegex.hasMatch(email)) {
      return "El formato del correo es incorrecto";
    }
    return null;
  }
}
