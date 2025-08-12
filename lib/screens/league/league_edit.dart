import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/phase_status.dart';
import 'package:my_league_flutter/screens/phase/phase.dart';
import 'package:my_league_flutter/screens/teams/team.dart';
import 'package:my_league_flutter/web/league_service.dart';

class League extends StatefulWidget {
  final DefaultDto leagueDto;

  const League({super.key, required this.leagueDto});

  @override
  State<League> createState() => _LeagueState();
}

class _LeagueState extends State<League> {
  LeagueService leagueService = LeagueService();
  List<Tab> tabs = [
    Tab(text: 'Fases'),
    Tab(text: 'Equipos'),
    Tab(text: 'Configuraciones'),
  ];

  bool isLoading = true;
  bool isLoadingTeams = true;
  bool isLoadingPhases = true;
  TextEditingController teamNameController = TextEditingController();
  bool isButtonEnabled = false;

  List<PhaseDto> phases = [];
  List<DefaultDto> teams = [];
  String selectedValue = 'Opción 1';

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

  // TODO: Make it a single implementation with new_league_teams
  // to avoid repeated code
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

  Future<List<PhaseDto>?> _getLeaguePhases(String leagueId) async {
    try {
      final response = await leagueService.getLeaguePhases(leagueId);
      print("League phases retrieved");
      return response;
    } catch (e) {
      print("Error in _getLeaguePhases: $e");
      return [];
    }
  }

  @override
  void initState() {
    super.initState();

    _getLeaguePhases(widget.leagueDto.id).then((response) {
      if (mounted) {
        setState(() {
          phases = response ?? [];
          isLoadingPhases = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.leagueDto.name),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(tabs: tabs),
        ),
        body: TabBarView(
          children: [
            // Phases tab
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: phases.length,
                          itemBuilder: (context, index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: const Icon(Icons.calendar_month),
                                title: Text(
                                  phases[index].name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(phases[index].status),
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder:
                                          (context) =>
                                              Phase(phaseDto: phases[index]),
                                    ),
                                  );
                                },
                              ),
                            );
                          },
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () async {
                          final result = await _showDialogNewTeam(context);
                          if (result == true) {
                            _getTeamsFromLeague(widget.leagueDto.id).then((
                              response,
                            ) {
                              setState(() {
                                teams = response ?? [];
                              });
                            });
                          }
                        },
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add),
                            const SizedBox(width: 8),
                            const Text("Agregar fase"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                if (isLoadingPhases)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),

            // Teams tab
            Stack(
              children: [
                Column(
                  children: [
                    Expanded(
                      child: ListView.builder(
                        itemCount: teams.length,
                        itemBuilder: (context, index) {
                          return Card(
                            margin: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 5,
                            ),
                            elevation: 3,
                            child: ListTile(
                              leading: const Icon(Icons.sports_soccer),
                              title: Text(
                                teams[index].name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              subtitle: Text('ID: ${teams[index].id}'),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (context) =>
                                            Team(teamDto: teams[index]),
                                  ),
                                );
                              },
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: ElevatedButton(
                        onPressed: () async {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add),
                            const SizedBox(width: 8),
                            const Text("Agregar un equipo"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                if (isLoadingTeams)
                  Container(
                    color: Colors.black.withValues(alpha: 0.5),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),

            // Settings tab
            Center(child: Text('Opciones y ajustes aquí')),
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
                    controller: teamNameController,
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
                                id: "null",
                                name: teamNameController.text,
                              ),
                              widget.leagueDto.id,
                            );

                            Navigator.pop(context, true);
                          }
                          : null,
                  child: const Text('Crear'), // TODO: Missing loader
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
}
