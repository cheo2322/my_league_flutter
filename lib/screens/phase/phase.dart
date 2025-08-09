import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/phase_status.dart';
import 'package:my_league_flutter/web/league_service.dart';

class Phase extends StatefulWidget {
  final PhaseDto phaseDto;

  const Phase({super.key, required this.phaseDto});

  @override
  State<Phase> createState() => _PhaseState();
}

class _PhaseState extends State<Phase> {
  final LeagueService leagueService = LeagueService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.phaseDto.name)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Phase Status: ${widget.phaseDto.status}'),
            ElevatedButton(onPressed: () {}, child: const Text('View Teams')),
          ],
        ),
      ),
    );
  }
}
