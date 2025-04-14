import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/web/league_service.dart';

class MyField extends StatefulWidget {
  const MyField({super.key});

  @override
  State<StatefulWidget> createState() => _MyFieldState();
}

class _MyFieldState extends State<MyField> {
  LeagueService leagueService = LeagueService();
  List<DefaultDto> leagues = [];
  List<DefaultDto> teams = [];
  bool isLoadingLeagues = true;
  bool isLoadingTeams = true;

  @override
  void initState() {
    _fetchLeagues();
    _loadTeams();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoadingLeagues
              ? Center(child: CircularProgressIndicator(color: Colors.indigo))
              : ListView(
                children: [
                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Ligas',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: leagues.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: Icon(Icons.sports_soccer),
                          title: Text(
                            leagues[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('League ID: ${leagues[index].id}'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Liga seleccionada: ${leagues[index].name}',
                                ),
                                backgroundColor: Colors.indigo,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),

                  Divider(thickness: 2, color: Colors.grey[300]),

                  Padding(
                    padding: EdgeInsets.all(10),
                    child: Text(
                      'Equipos',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: teams.length,
                    itemBuilder: (context, index) {
                      return Card(
                        margin: EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        elevation: 3,
                        child: ListTile(
                          leading: Icon(Icons.group),
                          title: Text(
                            teams[index].name,
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text('Team ID: ${teams[index].id}'),
                          onTap: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Equipo seleccionado: ${teams[index].name}',
                                ),
                                backgroundColor: Colors.indigo,
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ],
              ),
    );
  }

  Future<void> _fetchLeagues() async {
    try {
      final response = await leagueService.getLeagues();
      setState(() {
        leagues = response.sublist(0, 4);
        isLoadingLeagues = false;
      });
    } catch (error) {
      print('Error al obtener ligas: $error');
      setState(() {
        isLoadingLeagues = false;
      });
    }
  }

  void _loadTeams() {
    Future.delayed(Duration(milliseconds: 500), () {
      setState(() {
        teams = [
          DefaultDto(id: '1', name: 'Team A'),
          DefaultDto(id: '2', name: 'Team B'),
          DefaultDto(id: '3', name: 'Team C'),
          DefaultDto(id: '4', name: 'Team D'),
        ];
        isLoadingTeams = false;
      });
    });
  }
}
