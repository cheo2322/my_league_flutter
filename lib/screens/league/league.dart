import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/model/phase_status.dart';
import 'package:my_league_flutter/model/positions_table_dto.dart';
import 'package:my_league_flutter/model/round_dto.dart';
import 'package:my_league_flutter/screens/main/round_card.dart';
import 'package:my_league_flutter/screens/positions/positions_table.dart';
import 'package:my_league_flutter/web/league_service.dart';

class League extends StatefulWidget {
  final LeagueDto leagueDto;

  const League({super.key, required this.leagueDto});

  @override
  State<League> createState() => _LeagueState();
}

class _LeagueState extends State<League> {
  LeagueService leagueService = LeagueService();

  List<Tab> tabs = [
    Tab(text: 'Partidos'),
    Tab(text: 'Posiciones'),
    // Tab(text: 'Fases'), // TODO: Add phases later if needed
    // Tab(text: 'Estadísticas'), // TODO: Add Statistics later if needed
  ];

  bool isLoadingMatches = true;
  bool isLoadingPositions = true;
  bool isLoadingPhases = true;

  List<RoundDto> _rounds = [];
  PositionsTableDto? _positionsTable;
  List<PhaseDto> phases = [];

  Future<List<RoundDto>> _fetchRounds() async {
    return await leagueService.getRoundsFromActivePhaseByLeagueId(
      widget.leagueDto.id,
    );
  }

  Future<PositionsTableDto?> _fetchPositions(
    String leagueId,
    String phaseId,
    String roundId,
  ) async {
    try {
      return await leagueService.getLeaguePositions(leagueId, phaseId, roundId);
    } catch (e) {
      print("Error in _fetchPositions: $e");
      return null; //TODO: Handle error
    }
  }

  @override
  void initState() {
    super.initState();

    _fetchRounds().then((response) {
      setState(() {
        _rounds = response;
        isLoadingMatches = false;
      });
    });

    _fetchPositions(
      widget.leagueDto.id,
      widget.leagueDto.activePhaseId,
      widget.leagueDto.activeRoundId,
    ).then((response) {
      setState(() {
        _positionsTable = response;
        isLoadingPositions = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
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
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            unselectedLabelColor: Colors.white,
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
                    horizontal: 8,
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
            Stack(
              children: [
                if (_positionsTable != null)
                  ListView.builder(
                    itemCount: 1,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 2,
                      vertical: 8,
                    ),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PositionsTable(
                          positions: _positionsTable!.positions,
                        ),
                      );
                    },
                  ),

                if (isLoadingPositions)
                  Container(
                    color: Colors.black.withAlpha(50),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),

            // Phases tab
            // TODO: Add phases later if needed

            // Statistics tab
            // TODO: Add Statistics later if needed
          ],
        ),
      ),
    );
  }
}
