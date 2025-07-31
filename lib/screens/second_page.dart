import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/screens/league/league_edit.dart';
import 'package:my_league_flutter/screens/league/new_league.dart';
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
      body: ListView(
        children: [
          Padding(
            padding: EdgeInsets.all(10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'MisTorneos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.indigo),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewLeague()),
                    );
                  },
                ),
              ],
            ),
          ),

          isLoadingLeagues
              ? Center(child: CircularProgressIndicator(color: Colors.indigo))
              : leagues.isEmpty
              ? Column(
                children: [
                  Center(child: Text('Aún no has creado ningun torneo')),
                  SizedBox(height: 5),
                  ElevatedButton.icon(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewLeague()),
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text('Crear un torneo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: leagues.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    elevation: 3,
                    child: ListTile(
                      leading: Icon(Icons.sports_soccer),
                      title: Text(
                        leagues[index].name,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text('League ID: ${leagues[index].id}'),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder:
                                (context) =>
                                    League(leagueId: leagues[index].id!),
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
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Mis Equipos',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  icon: Icon(Icons.add, color: Colors.indigo),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Agregar nuevo equipo'),
                        backgroundColor: Colors.indigo,
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          isLoadingTeams
              ? Center(child: CircularProgressIndicator(color: Colors.indigo))
              : teams.isEmpty
              ? Column(
                children: [
                  Center(child: Text('Aún no has creado ningún equipo')),
                  SizedBox(height: 5),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Crear un nuevo equipo'),
                          backgroundColor: Colors.indigo,
                        ),
                      );
                    },
                    icon: Icon(Icons.add),
                    label: Text('Crear un equipo'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.indigo,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              )
              : ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: teams.length,
                itemBuilder: (context, index) {
                  return Card(
                    margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
        leagues = response;
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
    Future.delayed(Duration(milliseconds: 3000), () {
      setState(() {
        teams = [
          // DefaultDto(id: '1', name: 'Team A'),
          // DefaultDto(id: '2', name: 'Team B'),
          // DefaultDto(id: '3', name: 'Team C'),
          // DefaultDto(id: '4', name: 'Team D'),
        ];
        isLoadingTeams = false;
      });
    });
  }
}
