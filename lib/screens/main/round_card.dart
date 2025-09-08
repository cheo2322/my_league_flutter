import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/model/round_dto.dart';
import 'package:my_league_flutter/screens/league/league.dart';
import 'package:my_league_flutter/screens/match/match_card.dart';
import 'package:my_league_flutter/screens/match/match_page.dart';

class RoundCard extends StatelessWidget {
  final RoundDto round;
  final String title;
  final bool isRoundSelectable;

  const RoundCard({
    super.key,
    required this.round,
    required this.title,
    this.isRoundSelectable = false,
  });

  @override
  Widget build(BuildContext context) {
    var primaryColor = Theme.of(context).primaryColor;

    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 1, vertical: 1),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              if (isRoundSelectable) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder:
                        (context) => League(
                          leagueDto: LeagueDto(
                            id: round.leagueId,
                            name: round.leagueName,
                            activePhaseId: round.phaseId,
                            activeRoundId: round.roundId,
                          ),
                        ),
                  ),
                );
              }
            },
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              decoration: BoxDecoration(
                color: primaryColor,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
              ),
              child: Center(
                child: Text(
                  title,
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
                    InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Match(match: match, leagueName: round.leagueName),
                          ),
                        );
                      },
                      child: MatchCard(match: match),
                    ),
                    if (i < round.matches.length - 1) const Divider(height: 8, thickness: 1),
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
