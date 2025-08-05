import 'package:flutter/material.dart';
import 'package:my_league_flutter/screens/league/new_league.dart';
import 'package:my_league_flutter/screens/match/match_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<Map<String, dynamic>> _matches = [
    {
      'team1': 'SAN ANTONIO DE IMBAYA',
      'team2': 'ESCUELA DE FUTBOL 9 DE FEBRERO',
      'matchTime': '9:00',
      'isFinished': false,
    },
    {
      'team1': 'ESTUDIANTES DE LA PLATA',
      'team2': 'CHACARITAS',
      'matchTime': '11h00',
      'isFinished': true,
      'team1Result': 5,
      'team2Result': 3,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView(
        children:
            _matches.map((match) {
              return MatchCard(
                team1: match['team1'],
                team2: match['team2'],
                matchTime: match['matchTime'],
                isFinished: match['isFinished'] ?? false,
                team1Result: match['team1Result'],
                team2Result: match['team2Result'],
              );
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
