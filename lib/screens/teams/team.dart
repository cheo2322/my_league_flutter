import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/team_dto.dart';
import 'package:my_league_flutter/web/team_service.dart';

class Team extends StatefulWidget {
  final DefaultDto teamDto;

  const Team({super.key, required this.teamDto});

  @override
  State<Team> createState() => _Team();
}

class _Team extends State<Team> {
  bool isLoadingMatches = true;
  bool isLoadingInfo = true;

  TeamDto? teamInfo;

  TeamService teamService = TeamService();

  Future<TeamDto?> _getTeamInfo(String teamId) async {
    final response = await teamService.getTeamInfo(teamId);
    if (response != null) {
      print("Team info retrieved");
      return response;
    } else {
      print("Error retrieving team info");
      return null;
    }
  }

  @override
  void initState() {
    _getTeamInfo(widget.teamDto.id!).then((response) {
      setState(() {
        teamInfo = response;
        isLoadingInfo = false;
      });
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4,
      child: Scaffold(
        body: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(widget.teamDto.name),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Info'),
                    Tab(text: 'Partidos'),
                    Tab(text: 'Jugadores'),
                    Tab(text: 'Ajustes'),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  TabBarView(
                    children: [
                      Stack(
                        children: [
                          if (teamInfo != null)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Nombre del equipo: ${teamInfo!.name}',
                                        style: const TextStyle(fontSize: 16),
                                      ),

                                      const SizedBox(height: 8),
                                      Text(
                                        'Representante: ${teamInfo!.major ?? 'No definido'}',
                                        style: const TextStyle(fontSize: 16),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        'Abreviatura: ${teamInfo!.abbreviation ?? 'No definido'}',
                                        style: const TextStyle(fontSize: 16),
                                      ),

                                      const SizedBox(height: 8),

                                      Text(
                                        'ID Liga: ${teamInfo!.league?.toString() ?? teamInfo!.leagueId ?? 'No definido'}',
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    ],
                                  ),

                                  const Spacer(), // Empuja hacia abajo

                                  Center(
                                    child: ElevatedButton.icon(
                                      onPressed: () {
                                        // Acción al presionar editar
                                      },
                                      icon: const Icon(Icons.edit),
                                      label: const Text('Editar'),
                                      style: ElevatedButton.styleFrom(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 20,
                                          vertical: 12,
                                        ),
                                        textStyle: const TextStyle(
                                          fontSize: 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          else
                            const SizedBox.shrink(),

                          if (isLoadingInfo)
                            Container(
                              color: Colors.black.withValues(alpha: 0.5),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),

                      // Página de Partidos
                      Stack(
                        children: [
                          if (isLoadingMatches)
                            Container(
                              color: Colors.black.withValues(alpha: 0.5),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),

                      // Página de Jugadores
                      Center(child: Text('Lista de jugadores próximamente...')),

                      // Página de Configuraciones con contenido ficticio
                      Center(child: Text('Opciones y ajustes aquí')),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
