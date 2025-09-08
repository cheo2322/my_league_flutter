import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/main.dart';
import 'package:my_league_flutter/screens/login/password_field.dart';
import 'package:my_league_flutter/web/auth_service.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();
  final AuthService authService = AuthService();
  bool isLoading = false;

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    usernameController.addListener(_updateButtonState);
    passwordController.addListener(_updateButtonState);
  }

  void _updateButtonState() {
    setState(() {
      isButtonEnabled = usernameController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  Future<void> handleLogin() async {
    setState(() => isLoading = true);
    final primaryColor = Theme.of(context).primaryColor;

    final token = await authService.login(
      email: usernameController.text,
      password: passwordController.text,
    );

    if (token != null) {
      await secureStorage.write(key: 'auth_token', value: token);
      await secureStorage.write(key: 'username', value: usernameController.text);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Login exitoso'),
            backgroundColor: primaryColor,
            duration: const Duration(seconds: 3),
          ),
        );
      }

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Correo o contraseña incorrectos'),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 3),
        ),
      );
    }

    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return Stack(
      children: [
        Scaffold(
          appBar: AppBar(
            title: const Text('Iniciar sesión', style: TextStyle(color: Colors.white)),
            backgroundColor: primaryColor,
            iconTheme: const IconThemeData(color: Colors.white),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    labelText: 'Correo electrónico',
                    hintText: 'correo@ejemplo.com',
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: primaryColor)),
                    floatingLabelStyle: TextStyle(color: primaryColor),
                  ),
                  cursorColor: primaryColor,
                ),
                const SizedBox(height: 20),
                PasswordField(controller: passwordController),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: isButtonEnabled ? handleLogin : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: primaryColor,
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: const Text('Entrar', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isLoading)
          Container(
            color: Colors.black.withValues(alpha: 0.5),
            child: Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(primaryColor),
              ),
            ),
          ),
      ],
    );
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
