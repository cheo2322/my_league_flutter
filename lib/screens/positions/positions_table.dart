import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/position_dto.dart';
import 'package:my_league_flutter/screens/positions/position_card.dart';

class PositionsTable extends StatelessWidget {
  final List<PositionDto> positions;

  const PositionsTable({super.key, required this.positions});

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 8),
            decoration: BoxDecoration(
              color: primaryColor,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(4),
              ),
            ),
            child: _buildHeader(),
          ),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Column(
              children: List.generate(positions.length, (i) {
                return Column(
                  children: [
                    PositionCard(order: i + 1, position: positions[i]),
                    if (i < positions.length - 1)
                      Divider(height: 8, thickness: 1, color: primaryColor),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    const headerStyle = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );

    return Row(
      children: const [
        Expanded(
          flex: 1,
          child: Text('Pos', textAlign: TextAlign.center, style: headerStyle),
        ),
        Expanded(
          flex: 3,
          child: Text(
            'Equipo',
            textAlign: TextAlign.center,
            style: headerStyle,
          ),
        ),
        Expanded(
          flex: 1,
          child: Text('Pts', textAlign: TextAlign.center, style: headerStyle),
        ),
        Expanded(
          flex: 1,
          child: Text('G', textAlign: TextAlign.center, style: headerStyle),
        ),
        Expanded(
          flex: 1,
          child: Text('GF', textAlign: TextAlign.center, style: headerStyle),
        ),
        Expanded(
          flex: 1,
          child: Text('GC', textAlign: TextAlign.center, style: headerStyle),
        ),
        Expanded(
          flex: 1,
          child: Text('PJ', textAlign: TextAlign.center, style: headerStyle),
        ),
      ],
    );
  }
}
