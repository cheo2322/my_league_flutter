import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';

class NewTeam extends StatefulWidget {
  final DefaultDto leagueDto;

  const NewTeam({super.key, required this.leagueDto});

  @override
  State<NewTeam> createState() => _NewTeam();
}

class _NewTeam extends State<NewTeam> {
  final TextEditingController _field1Controller = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();

  bool isButtonEnabled = false;

  void _checkFields() {
    setState(() {
      final field1Text = _field1Controller.text.trim();
      final field2Text = _field2Controller.text.trim();
      isButtonEnabled = field1Text.length > 3 && field2Text.length > 3;
    });
  }

  @override
  void initState() {
    super.initState();
    _field1Controller.addListener(_checkFields);
    _field2Controller.addListener(_checkFields);
  }

  @override
  void dispose() {
    _field1Controller.dispose();
    _field2Controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nuevo Equipo')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text(
              'Este equipo será agregado al torneo: ${widget.leagueDto.name}',
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _field1Controller,
              decoration: const InputDecoration(labelText: 'Campo 1'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _field2Controller,
              decoration: const InputDecoration(labelText: 'Campo 2'),
            ),
            const SizedBox(height: 32),
            ElevatedButton(
              onPressed:
                  isButtonEnabled
                      ? () {
                        Navigator.pop(context);
                      }
                      : null,
              child: const Text('Crear'),
            ),
          ],
        ),
      ),
    );
  }
}
