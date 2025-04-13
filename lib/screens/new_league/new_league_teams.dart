import 'package:flutter/material.dart';

class NewLeagueTeams extends StatelessWidget {
  final String leagueId;

  const NewLeagueTeams({super.key, required this.leagueId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detalles de League')),
      body: Center(child: Text('League ID: $leagueId')),
    );
  }
}
