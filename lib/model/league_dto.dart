class LeagueDto {
  final String id;
  final String name;
  final String? major;
  final String activePhaseId;
  final String activeRoundId;

  LeagueDto({
    required this.id,
    required this.name,
    this.major,
    required this.activePhaseId,
    required this.activeRoundId,
  });

  factory LeagueDto.fromJson(Map<String, dynamic> json) {
    return LeagueDto(
      id: json['id'],
      name: json['name'],
      major: json['major'] ?? '',
      activePhaseId: json['activePhaseId'] ?? '',
      activeRoundId: json['activeRoundId'] ?? '',
    );
  }

  static List<LeagueDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LeagueDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'major': major ?? '',
      'activePhaseId': activePhaseId,
      'activeRoundId': activeRoundId,
    };
  }
}
