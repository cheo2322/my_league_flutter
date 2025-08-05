import 'package:flutter/material.dart';

class MatchCard extends StatelessWidget {
  final String team1;
  final String team2;
  final String matchTime;
  final bool isFinished;
  final int? team1Result;
  final int? team2Result;

  const MatchCard({
    super.key,
    required this.team1,
    required this.team2,
    required this.matchTime,
    this.isFinished = false,
    this.team1Result,
    this.team2Result,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: ConstrainedBox(
        constraints: const BoxConstraints(minHeight: 56),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Row(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Flexible(
                      child: Text(
                        team1,
                        style: const TextStyle(fontSize: 12),
                        softWrap: true,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.sports_soccer, size: 16),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  isFinished
                      ? '${team1Result.toString()} - ${team2Result.toString()}'
                      : matchTime,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
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
                        team2,
                        style: const TextStyle(fontSize: 12),
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
      ),
    );
  }
}
