import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/screens/team/new_team.dart';
import 'package:my_league_flutter/web/league_service.dart';

class League extends StatefulWidget {
  final String leagueId;

  const League({super.key, required this.leagueId});

  @override
  State<League> createState() => _LeagueState();
}

class _LeagueState extends State<League> {
  LeagueService leagueService = LeagueService();

  LeagueDto? league;
  bool isLoading = true;
  bool isLoadingTeams = true;

  List<DefaultDto> teams = [];

  Future<LeagueDto?> _getLeague(String leagueId) async {
    try {
      final response = await leagueService.getLeague(leagueId);
      if (response != null) {
        print("League retrieved");
        return response;
      } else {
        print("Error retrieving league");
        return null;
      }
    } catch (e) {
      print("Error in _getLeague: $e");
      return null;
    }
  }

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

  @override
  void initState() {
    super.initState();

    _getLeague(widget.leagueId).then((response) {
      if (mounted) {
        setState(() {
          league = response;
          isLoading = false;
        });
      }
    });

    _getTeamsFromLeague(widget.leagueId).then((response) {
      setState(() {
        if (response != null) {
          teams = response;
          isLoadingTeams = false;
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        body: Stack(
          children: [
            Scaffold(
              appBar: AppBar(
                title: Text(league != null ? league!.name : 'Cargando...'),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () => Navigator.pop(context),
                ),
                bottom: const TabBar(
                  tabs: [
                    Tab(text: 'Equipos'),
                    Tab(text: 'Partidos'),
                    Tab(text: 'Configuraciones'),
                  ],
                ),
              ),
              body: Stack(
                children: [
                  TabBarView(
                    children: [
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
                                        leading: const Icon(
                                          Icons.sports_soccer,
                                        ),
                                        title: Text(
                                          teams[index].name,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        subtitle: Text(
                                          'ID: ${teams[index].id!}',
                                        ),
                                        onTap: () {
                                          print(
                                            'Equipo seleccionado: ${teams[index].name}',
                                          );
                                        },
                                      ),
                                    );
                                  },
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: ElevatedButton.icon(
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder:
                                            (context) => NewTeam(
                                              leagueDto: DefaultDto(
                                                id: league!.id,
                                                name: league!.name,
                                              ),
                                            ),
                                      ),
                                    );
                                  },
                                  icon: const Icon(Icons.add),
                                  label: const Text('Agregar un equipo'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.indigo,
                                    foregroundColor: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          if (isLoadingTeams)
                            Container(
                              color: Colors.black.withValues(alpha: 0.5),
                              child: const Center(
                                child: CircularProgressIndicator(),
                              ),
                            ),
                        ],
                      ),

                      // Página de Partidos con contenido de ejemplo
                      Center(child: Text('Lista de partidos próximamente...')),

                      // Página de Configuraciones con contenido ficticio
                      Center(child: Text('Opciones y ajustes aquí')),
                    ],
                  ),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(alpha: 0.5),
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
