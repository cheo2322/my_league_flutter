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
              body: TabBarView(
                children: [
                  // Página de Equipos con lista y botón al final
                  Column(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          itemCount: 3, // Mock con 3 equipos
                          itemBuilder: (context, index) {
                            final mockEquipos = [
                              {"id": "1", "name": "Tigres FC"},
                              {"id": "2", "name": "Leones United"},
                              {"id": "3", "name": "Águilas Doradas"},
                            ];

                            return Card(
                              margin: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              elevation: 3,
                              child: ListTile(
                                leading: const Icon(Icons.sports_soccer),
                                title: Text(
                                  mockEquipos[index]["name"]!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  'ID: ${mockEquipos[index]["id"]}',
                                ),
                                onTap: () {
                                  print(
                                    'Equipo seleccionado: ${mockEquipos[index]["name"]}',
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

                  // Página de Partidos con contenido de ejemplo
                  Center(child: Text('Lista de partidos próximamente...')),

                  // Página de Configuraciones con contenido ficticio
                  Center(child: Text('Opciones y ajustes aquí')),
                ],
              ),
            ),
            if (isLoading)
              Positioned.fill(
                child: Container(
                  color: Colors.black.withValues(
                    alpha: 0.5,
                  ), // Fondo semi-transparente
                  child: const Center(child: CircularProgressIndicator()),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
