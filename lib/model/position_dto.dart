class PositionDto {
  final String team;
  final int playedGames;
  final int points;
  final int favorGoals;
  final int againstGoals;
  final int goals;

  const PositionDto({
    required this.team,
    required this.playedGames,
    required this.points,
    required this.favorGoals,
    required this.againstGoals,
    required this.goals,
  });

  factory PositionDto.fromJson(Map<String, dynamic> json) {
    return PositionDto(
      team: json['team'] as String,
      playedGames: json['playedGames'] as int,
      points: json['points'] as int,
      favorGoals: json['favorGoals'] as int,
      againstGoals: json['againstGoals'] as int,
      goals: json['goals'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team': team,
      'playedGames': playedGames,
      'points': points,
      'favorGoals': favorGoals,
      'againstGoals': againstGoals,
      'goals': goals,
    };
  }

  static List<PositionDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => PositionDto.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<PositionDto> positions) {
    return positions.map((position) => position.toJson()).toList();
  }
}
