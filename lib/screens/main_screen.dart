import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/match_dto.dart';
import 'package:my_league_flutter/screens/league/new_league.dart';
import 'package:my_league_flutter/screens/match/match_card.dart';
import 'package:my_league_flutter/web/match_service.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<MatchDto> _matches = [];

  @override
  void initState() {
    super.initState();
    _fetchMatches();
  }

  Future<void> _fetchMatches() async {
    final service = MatchService();
    final matches = await service.getMatches();

    print("Fetched matches: $matches");
    setState(() {
      _matches.addAll(matches);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children:
            _matches.map((match) {
              return MatchCard(match: match);
            }).toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewLeague()),
          );
        },
        tooltip: 'Agregar opciones',
        child: const Icon(Icons.add),
      ),
    );
  }
}
