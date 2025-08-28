import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/widgets/auth_prompt.dart';

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  bool isLoadingMain = true;

  String? token;
  String? username;

  late Color primaryColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    primaryColor = Theme.of(context).primaryColor;
  }

  @override
  void initState() {
    super.initState();

    _initializeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return isLoadingMain
        ? Center(child: CircularProgressIndicator())
        : _buildMainContent(context);
  }

  Widget _buildMainContent(BuildContext context) {
    if (token == null || username == null) {
      return AuthPrompt(text: 'tus notificaciones');
    }

    return const Center(child: Text('Página de Notificaciones'));
  }

  Future<void> readSavedCredentials() async {
    token = await secureStorage.read(key: 'auth_token');
    username = await secureStorage.read(key: 'username');
  }

  Future<void> _initializeScreen() async {
    await readSavedCredentials();

    setState(() {
      isLoadingMain = false;
    });

    if (token != null && username != null) {
      // TODO: Logic for notifications
    }
  }
}
