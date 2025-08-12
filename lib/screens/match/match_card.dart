import 'package:flutter/material.dart';
import 'package:my_league_flutter/model/match_dto.dart';

class MatchCard extends StatelessWidget {
  final MatchDto match;

  const MatchCard({super.key, required this.match});

  final TextStyle winnerStyle = const TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.bold,
    color: Colors.green,
  );

  final TextStyle normalStyle = const TextStyle(fontSize: 11);

  bool isHomeWinner(MatchDto match) =>
      match.status == "FINISHED" &&
      (match.homeResult ?? 0) > (match.visitResult ?? 0);

  bool isVisitWinner(MatchDto match) =>
      match.status == "FINISHED" &&
      (match.homeResult ?? 0) < (match.visitResult ?? 0);

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 56),
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Flexible(
                    child: Text(
                      match.homeTeam,
                      style: isHomeWinner(match) ? winnerStyle : normalStyle,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.right,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.sports_soccer, size: 16),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    match.date,
                    style: const TextStyle(
                      fontSize: 9,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    match.status != "SCHEDULED"
                        ? '${match.homeResult} - ${match.visitResult}'
                        : match.time,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (match.status != "SCHEDULED")
                    Text(
                      match.status == "FINISHED" ? 'FINALIZADO' : 'EN JUEGO',
                      style: const TextStyle(
                        fontSize: 9,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Icon(Icons.sports_soccer, size: 16),
                  const SizedBox(width: 8),
                  Flexible(
                    child: Text(
                      match.visitTeam,
                      style: isVisitWinner(match) ? winnerStyle : normalStyle,
                      softWrap: true,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
