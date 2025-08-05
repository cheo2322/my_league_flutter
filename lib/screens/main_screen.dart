import 'package:flutter/material.dart';
import 'package:my_league_flutter/screens/league/new_league.dart';
import 'package:my_league_flutter/screens/match/match_card.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final List<String> _items = ['Elemento 1'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: _items.length,
        itemBuilder: (context, index) {
          // Por ahora solo mostramos la primera tarjeta personalizada
          if (index == 0) {
            return MatchCard();
          }
        },
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
