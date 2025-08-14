import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/web/league_service.dart';

class NewTeam extends StatefulWidget {
  final DefaultDto leagueDto;

  const NewTeam({super.key, required this.leagueDto});

  @override
  State<NewTeam> createState() => _NewTeam();
}

class _NewTeam extends State<NewTeam> {
  LeagueService leagueService = LeagueService();

  final TextEditingController _teamNameController = TextEditingController();
  final TextEditingController _field2Controller = TextEditingController();

  bool isButtonEnabled = false;

  void _checkFields() {
    setState(() {
      final field1Text = _teamNameController.text.trim();
      final field2Text =
          _field2Controller.text.trim(); // TODO: add the missing fields
      isButtonEnabled = field1Text.length > 2;
    });
  }

  @override
  void initState() {
    super.initState();
    _teamNameController.addListener(_checkFields);
    _field2Controller.addListener(_checkFields);
  }

  @override
  void dispose() {
    _teamNameController.dispose();
    _field2Controller.dispose();
    super.dispose();
  }

  Future<DefaultDto?> _addTeamToLeague(
    DefaultDto teamDto,
    String leagueId,
  ) async {
    try {
      final response = await leagueService.addTeamToLeague(teamDto, leagueId);

      if (response != null) {
        print("Team added");
        return response;
      } else {
        print("Error adding team");
        return null;
      }
    } catch (e) {
      print("Error in _addTeamToLeague: $e");
      return null;
    }
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
            const SizedBox(height: 16.0),
            TextField(
              controller: _teamNameController,
              decoration: const InputDecoration(
                labelText: 'Nombre del equipo *',
                hintText: 'Nombre del equipo',
                border: OutlineInputBorder(),
              ),
            ),
            // TODO: add the missing fields
            // const SizedBox(height: 5.0),
            // TextField(
            //   controller: _field2Controller,
            //   decoration: const InputDecoration(
            //     labelText: 'Nombre del representante del equipo *',
            //     hintText: 'Nombre del representante del equipo',
            //     border: OutlineInputBorder(),
            //   ),
            // ),
            const SizedBox(height: 32),

            ElevatedButton(
              onPressed:
                  isButtonEnabled
                      ? () async {
                        await _addTeamToLeague(
                          DefaultDto(
                            id: "null",
                            name: _teamNameController.text,
                          ),
                          widget.leagueDto.id,
                        );

                        Navigator.pop(context, true);
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
