import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/round_dto.dart';
import 'package:my_league_flutter/screens/main/round_card.dart';
import 'package:my_league_flutter/web/league_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<RoundDto> _rounds = [];

  bool isLoading = true;

  Future<void> _fetchRounds() async {
    final service = LeagueService();
    final rounds = await service.getMainPage();

    setState(() {
      _rounds.addAll(rounds);
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _fetchRounds();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:
          isLoading
              ? const Center(
                child: CircularProgressIndicator(color: Colors.indigo),
              )
              : _rounds.isEmpty
              ? const Center(child: Text("No hay partidos disponibles"))
              : ListView.builder(
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
                          '${_rounds[index].leagueName} - ${_rounds[index].phase} (Fecha ${_rounds[index].order})',
                      isRoundSelectable: true,
                    ),
                  );
                },
              ),
      // TODO: Activate when user is authenticated
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () {
      //     Navigator.push(
      //       context,
      //       MaterialPageRoute(builder: (context) => NewLeague()),
      //     );
      //   },
      //   tooltip: 'Agregar',
      //   backgroundColor: Colors.teal,
      //   splashColor: Colors.white,
      //   child: const Icon(Icons.add, color: Colors.white),
      // ),
    );
  }
}
