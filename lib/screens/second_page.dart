import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/screens/league/league.dart';
import 'package:my_league_flutter/screens/league/new_league.dart';
import 'package:my_league_flutter/web/league_service.dart';
import 'package:my_league_flutter/widgets/auth_prompt.dart';

class MyField extends StatefulWidget {
  const MyField({super.key});

  @override
  State<StatefulWidget> createState() => _MyFieldState();
}

class _MyFieldState extends State<MyField> {
  LeagueService leagueService = LeagueService();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  List<LeagueDto> leagues = [];
  List<DefaultDto> teams = [];
  bool isLoadingLeagues = true;
  bool isLoadingTeams = true;
  bool isLoadingMain = true;

  String? token;
  String? username;

  late Color primaryColor;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    primaryColor = Theme.of(context).primaryColor;
  }

  @override
  void initState() {
    super.initState();

    _initializeScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoadingMain ? Center(child: CircularProgressIndicator()) : _buildMainContent(context),
    );
  }

  Widget _buildMainContent(BuildContext context) {
    if (token == null || username == null) {
      return AuthPrompt(text: 'tus torneos y equipos');
    }

    return ListView(
      children: [
        _buildSectionHeader('Mis Torneos', () {
          Navigator.push(context, MaterialPageRoute(builder: (_) => NewLeague()));
        }),
        _buildLeaguesSection(context),
        Divider(thickness: 2),
        _buildSectionHeader('Mis Equipos', () {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('Agregar nuevo equipo')));
        }),
        _buildTeamsSection(context),
      ],
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
      if (mounted) {
        setState(() {
          isLoadingLeagues = false;
        });
      }
    }
  }

  Future<void> _loadTeams() async {
    await Future.delayed(Duration(milliseconds: 3000));
    if (mounted) {
      setState(() {
        teams = [
          // DefaultDto(id: '1', name: 'Team A'),
          // DefaultDto(id: '2', name: 'Team B'),
          // DefaultDto(id: '3', name: 'Team C'),
          // DefaultDto(id: '4', name: 'Team D'),
        ];
        isLoadingTeams = false;
      });
    }
  }

  Future<void> readSavedCredentials() async {
    token = await secureStorage.read(key: 'auth_token');
    username = await secureStorage.read(key: 'username');
  }

  Future<void> _initializeScreen() async {
    await readSavedCredentials();

    setState(() {
      isLoadingMain = false;
    });

    if (token != null && username != null) {
      await _fetchLeagues();
      await _loadTeams();
    }
  }

  Widget _buildSectionHeader(String title, VoidCallback onAddPressed) {
    return Padding(
      padding: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          IconButton(icon: Icon(Icons.add), onPressed: onAddPressed),
        ],
      ),
    );
  }

  Widget _buildLeaguesSection(BuildContext context) {
    if (isLoadingLeagues) return Center(child: CircularProgressIndicator());

    if (leagues.isEmpty) {
      return Column(
        children: [
          Text('Aún no has creado ningún torneo'),
          SizedBox(height: 5),
          ElevatedButton.icon(
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (_) => NewLeague()));
            },
            icon: Icon(Icons.add),
            label: Text('Crear un torneo'),
          ),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: leagues.length,
      itemBuilder: (context, index) {
        final league = leagues[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 3,
          child: ListTile(
            leading: Icon(Icons.sports_soccer),
            title: Text(league.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('League ID: ${league.id}'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (_) => League(
                        leagueDto: LeagueDto(
                          id: league.id,
                          name: league.name,
                          activePhaseId: league.activePhaseId,
                          activeRoundId: league.activeRoundId,
                        ),
                      ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Widget _buildTeamsSection(BuildContext context) {
    if (isLoadingTeams) return Center(child: CircularProgressIndicator());

    if (teams.isEmpty) {
      return Column(
        children: [
          Text('Aún no has creado ningún equipo'),
          SizedBox(height: 5),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Crear un nuevo equipo')));
            },
            icon: Icon(Icons.add),
            label: Text('Crear un equipo'),
          ),
        ],
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: teams.length,
      itemBuilder: (context, index) {
        final team = teams[index];
        return Card(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          elevation: 3,
          child: ListTile(
            leading: Icon(Icons.group),
            title: Text(team.name, style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Team ID: ${team.id}'),
            onTap: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('Equipo seleccionado: ${team.name}')));
            },
          ),
        );
      },
    );
  }
}
