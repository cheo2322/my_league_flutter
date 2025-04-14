import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/screens/main_screen.dart';
import 'package:my_league_flutter/web/league_service.dart';

class NewLeagueTeams extends StatefulWidget {
  final String leagueId;

  const NewLeagueTeams({super.key, required this.leagueId});

  @override
  State<NewLeagueTeams> createState() => _NewLeagueTeams();
}

class _NewLeagueTeams extends State<NewLeagueTeams> {
  LeagueService leagueService = LeagueService();

  bool isLoading = true;
  List<DefaultDto> teams = [];

  final TextEditingController _teamNameController = TextEditingController();
  bool isButtonEnabled = false;

  Future<List<DefaultDto>?> _getTeamsFromLeague(String leagueId) async {
    try {
      final response = await leagueService.getTeamsFromLeague(leagueId);

      if (response != null) {
        print("Teams retrieved");
        return response;
      } else {
        print("Error retrieving teams");
        return null;
      }
    } catch (e) {
      print("Error in _getTeamsFromLeague: $e");
      return null;
    }
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
  void initState() {
    _getTeamsFromLeague(widget.leagueId).then((response) {
      setState(() {
        teams = response!;
        isLoading = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) async {
        final salir = await _mostrarAlerta(context);
        if (salir) {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MainScreen()),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(title: Text('Agregar equipos')),
        body: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: teams.length,
                      itemBuilder: (context, index) {
                        return Card(
                          child: ListTile(title: Text(teams[index].name)),
                        );
                      },
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () async {
                      final result = await _showDialogNewTeam(context);
                      if (result == true) {
                        _getTeamsFromLeague(widget.leagueId).then((response) {
                          setState(() {
                            teams = response ?? [];
                          });
                        });
                      }
                    },
                    child: const Text("Agregar equipo"),
                  ),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black54,
                  child: Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showDialogNewTeam(BuildContext context) {
    return showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Nuevo Equipo"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: _teamNameController,
                    decoration: const InputDecoration(
                      labelText: 'Nombre*',
                      hintText: 'Escribe el nombre del equipo',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (text) {
                      setState(() {
                        isButtonEnabled = text.trim().length > 2;
                      });
                    },
                  ),
                ],
              ),
              actions: [
                ElevatedButton(
                  onPressed:
                      isButtonEnabled
                          ? () async {
                            await _addTeamToLeague(
                              DefaultDto(
                                id: null,
                                name: _teamNameController.text,
                              ),
                              widget.leagueId,
                            );

                            Navigator.pop(context, true);
                          }
                          : null,
                  child: const Text('Crear'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Cerrar'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Future<bool> _mostrarAlerta(BuildContext context) async {
    return await showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('¿Salir?'),
              content: Text(
                'No te preocupes, puedes continuar editando tu torneo después. Sólo buscalo en la sección \'Mi torneo\' desde la pantalla principal.',
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(true),
                  child: Text('Sí, salir'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: Text('Seguir editando'),
                ),
              ],
            );
          },
        ) ??
        false;
  }
}
