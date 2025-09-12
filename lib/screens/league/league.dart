import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/model/phase_status.dart';
import 'package:my_league_flutter/model/positions_table_dto.dart';
import 'package:my_league_flutter/model/round_dto.dart';
import 'package:my_league_flutter/screens/main/round_card.dart';
import 'package:my_league_flutter/screens/positions/positions_table.dart';
import 'package:my_league_flutter/web/league_service.dart';

class League extends StatefulWidget {
  final DefaultDto defaultDto;

  const League({super.key, required this.defaultDto});

  @override
  State<League> createState() => _LeagueState();
}

class _LeagueState extends State<League> {
  LeagueService leagueService = LeagueService();
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  List<Tab> tabs = [
    Tab(text: 'Partidos'),
    Tab(text: 'Posiciones'),
    // Tab(text: 'Fases'), // TODO: Add phases later if needed
    // Tab(text: 'Estadísticas'), // TODO: Add Statistics later if needed
  ];

  bool isLoading = true;
  bool isLoadingMatches = true;
  bool isLoadingPositions = true;
  bool isLoadingPhases = true;

  LeagueDto? leagueDto;
  List<RoundDto> _rounds = [];
  PositionsTableDto? _positionsTable;
  List<PhaseDto> phases = [];

  String? token;

  @override
  void initState() {
    super.initState();

    if (mounted) {
      _initAsync();
    }
  }

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return isLoading
        ? Container(
          color: Colors.black.withValues(alpha: .5),
          child: const Center(child: CircularProgressIndicator()),
        )
        : _buildDefaultView(primaryColor, context);
  }

  DefaultTabController _buildDefaultView(Color primaryColor, BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: primaryColor,
          title: Text(widget.defaultDto.name, style: TextStyle(fontSize: 18, color: Colors.white)),
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
                ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  children: [
                    if (leagueDto!.isTheOwner) const SizedBox(height: 54),

                    ..._rounds.map(
                      (round) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: RoundCard(
                          round: round,
                          title: '${round.phase} - Fecha ${round.order}',
                        ),
                      ),
                    ),
                  ],
                ),

                if (leagueDto!.isTheOwner)
                  Positioned(
                    top: 8,
                    right: 8,
                    child: ElevatedButton.icon(
                      onPressed: () {
                        // Acción para agregar partidos
                      },
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar partidos'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                      ),
                    ),
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
                    padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 8),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PositionsTable(positions: _positionsTable!.positions),
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

  Future<void> _initAsync() async {
    token = await secureStorage.read(key: 'auth_token');

    _fetchRounds().then((response) {
      setState(() {
        _rounds = response;
        isLoadingMatches = false;
      });
    });

    _fetchLeagueDetails(widget.defaultDto.id, token).then((league) {
      if (league == null) {
        print("LeagueDto es null, no se puede cargar posiciones.");
        setState(() => isLoading = false);
        return; // TODO: Send message to user
      }

      setState(() {
        leagueDto = league;
        isLoading = false;
      });

      _fetchPositions(widget.defaultDto.id, league.activePhaseId, league.activeRoundId).then((
        positions,
      ) {
        setState(() {
          _positionsTable = positions;
          isLoadingPositions = false;
        });
      });
    });
  }

  Future<List<RoundDto>> _fetchRounds() async {
    return await leagueService.getRoundsFromActivePhaseByLeagueId(widget.defaultDto.id);
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

  Future<LeagueDto?> _fetchLeagueDetails(String leagueId, String? token) async {
    try {
      return await leagueService.getLeague(leagueId, token);
    } catch (e) {
      print("Error in _fetchLeagueDetails: $e");
      return null;
    }
  }
}
