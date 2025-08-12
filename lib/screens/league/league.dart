import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/phase_status.dart';
import 'package:my_league_flutter/model/round_dto.dart';
import 'package:my_league_flutter/screens/main/round_card.dart';
import 'package:my_league_flutter/screens/phase/phase.dart';
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
    Tab(text: 'Partidos'),
    Tab(text: 'Posiciones'),
    Tab(text: 'Fases'),
    Tab(text: 'Estadísticas'),
  ];

  bool isLoadingMatches = true;
  bool isLoadingPhases = true;
  TextEditingController teamNameController = TextEditingController();
  bool isButtonEnabled = false;

  List<PhaseDto> phases = [];
  List<RoundDto> _rounds = [];

  String selectedValue = 'Opción 1';

  Future<void> _fetchRounds() async {
    final service = LeagueService();
    final rounds = await service.getMainPage();

    setState(() {
      _rounds = rounds;
      isLoadingMatches = false;
    });
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
      setState(() {
        phases = response ?? [];
        isLoadingPhases = false;
      });
    });

    _fetchRounds().then((response) {
      setState(() {
        isLoadingMatches = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.teal,
          title: Text(
            widget.leagueDto.name,
            style: TextStyle(fontSize: 18, color: Colors.white),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: TabBar(
            tabs: tabs,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 5),
          ),
        ),
        body: TabBarView(
          children: [
            // Matches tab
            Stack(
              children: [
                ListView.builder(
                  itemCount: _rounds.length,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: RoundCard(
                        round: _rounds[index],
                        title:
                            '${_rounds[index].phase} - Fecha ${_rounds[index].order}',
                      ),
                    );
                  },
                ),

                if (isLoadingMatches)
                  Container(
                    color: Colors.black.withValues(alpha: .5),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),

            // Positions tab
            Center(child: Text('Posiciones aquí')),

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

            // Statistics tab
            Center(child: Text('Estadísticas aquí')),
          ],
        ),
      ),
    );
  }
}
