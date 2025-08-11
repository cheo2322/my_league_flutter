import 'package:my_league_flutter/model/match_dto.dart';

class RoundDto {
  final String roundId;
  final String leagueId;
  final String leagueName;
  final String phaseId;
  final String phase;
  final int order;
  final List<MatchDto> matches;

  const RoundDto({
    required this.roundId,
    required this.leagueId,
    required this.leagueName,
    required this.phaseId,
    required this.phase,
    required this.order,
    required this.matches,
  });

  factory RoundDto.fromJson(Map<String, dynamic> json) {
    return RoundDto(
      roundId: json['roundId'] as String,
      leagueId: json['leagueId'] as String,
      leagueName: json['leagueName'] as String,
      phaseId: json['phaseId'] as String,
      phase: json['phase'] as String,
      order: json['order'] as int,
      matches:
          (json['matches'] as List<dynamic>)
              .map((e) => MatchDto.fromJson(e as Map<String, dynamic>))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'roundId': roundId,
      'leagueId': leagueId,
      'leagueName': leagueName,
      'phaseId': phaseId,
      'phase': phase,
      'order': order,
      'matches': matches.map((e) => e.toJson()).toList(),
    };
  }

  static List<RoundDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList
        .map((e) => RoundDto.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  String get title => '$leagueName - $phase (Fecha $order)';
}
