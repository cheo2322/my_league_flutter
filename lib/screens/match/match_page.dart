import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/model/match_details.dart';
import 'package:my_league_flutter/model/match_dto.dart';
import 'package:my_league_flutter/web/match_service.dart';

class Match extends StatefulWidget {
  final MatchDto match;
  final String leagueName;

  const Match({super.key, required this.match, required this.leagueName});

  @override
  State<Match> createState() => _MatchState();
}

class _MatchState extends State<Match> {
  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  final List<Tab> tabs = [Tab(text: 'Eventos'), Tab(text: 'Alineaciones')];
  final TextStyle normalStyle = const TextStyle(fontSize: 14, color: Colors.white);
  final TextStyle winnerStyle = const TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: Colors.white,
  );

  MatchDetailsDto? matchDetails;
  String? token;
  bool isLoadingMatchDetails = true;

  Future<MatchDetailsDto?> _fetchMatchDetails(String matchId, String? token) async {
    final matchService = MatchService();
    return await matchService.getMatchDetails(matchId, token);
  }

  Future<String?> _readSavedCredentials() async {
    return await secureStorage.read(key: 'auth_token');
  }

  Future<bool> _updateMatchResult(
    String matchId,
    int homeResult,
    int visitResult,
    String? token,
  ) async {
    final matchService = MatchService();
    return await matchService.updateMatchResult(matchId, homeResult, visitResult, token);
  }

  @override
  void initState() {
    super.initState();

    if (mounted) {
      _readSavedCredentials().then((token) {
        this.token = token;
        _fetchMatchDetails(widget.match.id!, token).then((details) {
          if (details != null) {
            setState(() {
              matchDetails = details;
            });
          }
          isLoadingMatchDetails = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).primaryColor;

    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: const Size.fromHeight(230),
          child: AppBar(
            backgroundColor: primaryColor,
            automaticallyImplyLeading: false,
            flexibleSpace: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: _buildDynamicContent(context, primaryColor),
                ),
              ),
            ),
          ),
        ),
        body: TabBarView(
          children: const [
            Center(child: Text('No hay detalles del partido')),
            Center(child: Text('Alineaciones no disponibles')),
          ],
        ),
      ),
    );
  }

  List<Widget> _buildDynamicContent(BuildContext context, Color color) {
    return isLoadingMatchDetails
        ? [
          Expanded(
            child: Container(
              color: color,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ),
          ),
        ]
        : [
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 16),

              if (matchDetails != null && matchDetails!.isTheOwner == true)
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: GestureDetector(
                      onTap: () => _showEditDialog(context, widget.match, color),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'EDITAR',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),

          Center(
            child: Container(
              constraints: BoxConstraints(maxWidth: 250),
              child: Text(
                widget.leagueName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        widget.match.homeTeam,
                        style: isHomeWinner(widget.match) ? winnerStyle : normalStyle,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.right,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.sports_soccer, size: 16, color: Colors.white),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      widget.match.date,
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      widget.match.status != "SCHEDULED"
                          ? '${widget.match.homeResult} - ${widget.match.visitResult}'
                          : widget.match.time,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    if (widget.match.status != "SCHEDULED")
                      Text(
                        widget.match.status == "FINISHED" ? 'FINALIZADO' : 'EN JUEGO',
                        style: const TextStyle(
                          fontSize: 9,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const Icon(Icons.sports_soccer, size: 16, color: Colors.white),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        widget.match.visitTeam,
                        style: isVisitWinner(widget.match) ? winnerStyle : normalStyle,
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),

          if (matchDetails != null && matchDetails!.field != null)
            Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.location_on, size: 16, color: Colors.white70),
                  SizedBox(width: 4),
                  Text(matchDetails!.field!, style: TextStyle(color: Colors.white70)),
                ],
              ),
            ),

          const Spacer(),

          // Tabs
          TabBar(
            tabs: tabs,
            indicatorColor: Colors.white,
            labelColor: Colors.white,
            labelPadding: EdgeInsets.symmetric(horizontal: 5),
            labelStyle: TextStyle(fontWeight: FontWeight.bold),
            unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
            unselectedLabelColor: Colors.white,
          ),
        ];
  }

  bool isHomeWinner(MatchDto match) =>
      match.status == "FINISHED" && (match.homeResult ?? 0) > (match.visitResult ?? 0);

  bool isVisitWinner(MatchDto match) =>
      match.status == "FINISHED" && (match.homeResult ?? 0) < (match.visitResult ?? 0);

  void _showEditDialog(BuildContext context, MatchDto match, Color primaryColor) {
    final homeController = TextEditingController(text: match.homeResult?.toString() ?? '');
    final visitController = TextEditingController(text: match.visitResult?.toString() ?? '');

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Editar marcador'),
          content: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: homeController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: match.homeTeam,
                    hintText: 'Actual: ${match.homeResult ?? '-'}',
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: visitController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: match.visitTeam,
                    hintText: 'Actual: ${match.visitResult ?? '-'}',
                  ),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(onPressed: () => Navigator.of(context).pop(), child: const Text('Cancelar')),
            ElevatedButton(
              onPressed: () async {
                final newHome = int.tryParse(homeController.text);
                final newVisit = int.tryParse(visitController.text);

                if (newHome == null || newVisit == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text(
                        'Ingrese un resultado válido',
                        style: TextStyle(color: Colors.black),
                      ),
                      backgroundColor: Colors.amber,
                    ),
                  );
                  return;
                }

                final success = await _updateMatchResult(match.id!, newHome, newVisit, token);

                if (success) {
                  final updatedDetails = await _fetchMatchDetails(match.id!, token);
                  setState(() {
                    matchDetails = updatedDetails;
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Actualizado correctamente'),
                      backgroundColor: primaryColor,
                    ),
                  );
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: const Text('Error al actualizar el marcador'),
                      backgroundColor: Colors.redAccent,
                    ),
                  );
                }

                Navigator.of(context).pop();
              },
              child: const Text('Guardar'),
            ),
          ],
        );
      },
    );
  }
}
