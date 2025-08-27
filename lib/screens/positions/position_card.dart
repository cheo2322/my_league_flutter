import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/position_dto.dart';

class PositionCard extends StatelessWidget {
  final int order;
  final PositionDto position;

  const PositionCard({super.key, required this.position, required this.order});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 42),
      child: Row(
        children: [
          _buildOrderCell(order, position.status),
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
    );
  }

  TextStyle _style(bool bold) => TextStyle(
    fontSize: 13.0,
    fontWeight: bold ? FontWeight.bold : FontWeight.normal,
  );

  Widget _buildOrderCell(int order, String status) => Expanded(
    flex: 1,
    child: SizedBox(
      height: 42,
      child: Stack(
        alignment: Alignment.center,
        children: [
          if (status == 'UP')
            Positioned(
              top: 0,
              child: Icon(
                Icons.keyboard_double_arrow_up,
                color: Colors.green,
                size: 13,
              ),
            ),
          Center(child: Text('$order°', style: TextStyle(fontSize: 13.0))),
          if (status == 'DOWN')
            Positioned(
              bottom: 0,
              child: Icon(
                Icons.keyboard_double_arrow_down,
                color: Colors.red,
                size: 13,
              ),
            ),
        ],
      ),
    ),
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
