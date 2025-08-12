import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/position_dto.dart';

class PositionCard extends StatelessWidget {
  final int order;
  final PositionDto position;

  const PositionCard({super.key, required this.position, required this.order});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              '$order°',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13),
            ),
          ),
          Expanded(flex: 3, child: Text(position.team, style: _bold)),
          Expanded(
            flex: 1,
            child: Text(
              '${position.points}',
              textAlign: TextAlign.center,
              style: _bold,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${position.goals}',
              textAlign: TextAlign.center,
              style: _bold,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('${position.favorGoals}', textAlign: TextAlign.center),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${position.againstGoals}',
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text('${position.playedGames}', textAlign: TextAlign.center),
          ),
        ],
      ),
    );
  }

  TextStyle get _bold =>
      const TextStyle(fontWeight: FontWeight.bold, fontSize: 13);
}
