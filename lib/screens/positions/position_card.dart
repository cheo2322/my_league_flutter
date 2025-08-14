import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/position_dto.dart';

class PositionCard extends StatelessWidget {
  final int order;
  final PositionDto position;

  const PositionCard({super.key, required this.position, required this.order});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 36),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 1),
        child: Row(
          children: [
            _buildOrderCell(order),
            _buildTeamCell(position.team),
            ..._buildStatsCells([
              {'value': position.points, 'bold': true},
              {'value': position.goals, 'bold': true},
              {'value': position.favorGoals, 'bold': false},
              {'value': position.againstGoals, 'bold': false},
              {'value': position.playedGames, 'bold': false},
            ]),
          ],
        ),
      ),
    );
  }

  TextStyle _style(bool bold) => TextStyle(
    fontSize: 13,
    fontWeight: bold ? FontWeight.bold : FontWeight.normal,
  );

  Widget _buildOrderCell(int order) => Expanded(
    flex: 1,
    child: Text('$order°', textAlign: TextAlign.center, style: _style(false)),
  );

  Widget _buildTeamCell(String team) => Expanded(
    flex: 3,
    child: Text(
      team,
      style: _style(true),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    ),
  );

  List<Widget> _buildStatsCells(List<Map<String, dynamic>> stats) {
    return stats.map((stat) {
      final value = '${stat['value']}';
      final isBold = stat['bold'] as bool;
      return Expanded(
        flex: 1,
        child: Text(value, textAlign: TextAlign.center, style: _style(isBold)),
      );
    }).toList();
  }
}
