import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/round_dto.dart';
import 'package:my_league_flutter/screens/league/league_edit.dart';
import 'package:my_league_flutter/screens/match/match_card.dart';

class RoundCard extends StatelessWidget {
  final RoundDto round;

  const RoundCard({super.key, required this.round});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => League(
                        leagueDto: DefaultDto(
                          id: round.leagueId,
                          name: round.leagueName,
                        ),
                      ),
                ),
              );
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.teal,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(4),
                ),
              ),
              child: Center(
                child: Text(
                  round.title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: List.generate(round.matches.length, (i) {
                final match = round.matches[i];
                return Column(
                  children: [
                    MatchCard(match: match),
                    if (i < round.matches.length - 1)
                      const Divider(height: 8, thickness: 1),
                  ],
                );
              }),
            ),
          ),
        ],
      ),
    );
  }
}
