import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/web/league_service.dart';

class NewLeague extends StatefulWidget {
  const NewLeague({super.key});

  @override
  State<NewLeague> createState() => _NewLeagueState();
}

class _NewLeagueState extends State<NewLeague> {
  TextEditingController nameController = TextEditingController();
  TextEditingController organizerController = TextEditingController();
  bool isButtonEnabled = false;
  bool isLoading = false;

  LeagueService leagueService = LeagueService();

  Future<DefaultDto?> _createLeague(LeagueDto body) async {
    leagueService.postLeague(body).then((response) {
      if (response != null) {
        print("Liga creada: ${response.name}");
        return response;
      } else {
        print("Error al crear la liga.");
      }
    });

    return null;
  }

  void updateButtonState() {
    setState(() {
      isButtonEnabled =
          nameController.text.trim().length > 2 &&
          organizerController.text.trim().length > 2;
    });
  }

  @override
  void initState() {
    super.initState();
    nameController.addListener(updateButtonState);
    organizerController.addListener(updateButtonState);
  }

  @override
  void dispose() {
    nameController.dispose();
    organizerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Crea tu propio torneo'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del torneo',
                hintText: 'Ingresa el nombre del torneo',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              controller: organizerController,
              decoration: const InputDecoration(
                labelText: 'Organizador',
                hintText: 'Ingresa el nombre del organizador',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed:
                  isButtonEnabled
                      ? () {
                        // Lógica adicional para el botón "Siguiente" aquí
                        print('Pressed!');
                      }
                      : null,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Siguiente'),
                  const Icon(Icons.chevron_right),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
