class TeamDto {
  final String? id;
  final String name;
  final String? major;
  final String? abbreviation;
  final String? leagueId;
  final dynamic league;

  TeamDto({
    required this.id,
    required this.name,
    this.major,
    this.abbreviation,
    this.leagueId,
    this.league,
  });

  factory TeamDto.fromJson(Map<String, dynamic> json) {
    return TeamDto(
      id: json['id'] as String?,
      name: json['name'] as String,
      major: json['major'] as String?,
      abbreviation: json['abbreviation'] as String?,
      leagueId: json['leagueId'] as String?,
      league: json['league'],
    );
  }

  static List<TeamDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => TeamDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'major': major,
      'abbreviation': abbreviation,
      'leagueId': leagueId,
      'league': league,
    };
  }
}
