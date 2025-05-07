import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/league_dto.dart';
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
              body: const TabBarView(
                children: [
                  Center(child: Text('Equipos')),
                  Center(child: Text('Partidos')),
                  Center(child: Text('Configuraciones')),
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
