class LeagueDto {
  final String id;
  final String name;
  final String? major;
  final String currentPhaseId;
  final String currentRoundId;

  LeagueDto({
    required this.id,
    required this.name,
    this.major,
    required this.currentPhaseId,
    required this.currentRoundId,
  });

  factory LeagueDto.fromJson(Map<String, dynamic> json) {
    return LeagueDto(
      id: json['id'],
      name: json['name'],
      major: json['major'] ?? '',
      currentPhaseId: json['currentPhaseId'] ?? '',
      currentRoundId: json['currentRoundId'] ?? '',
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
      'currentPhaseId': currentPhaseId,
      'currentRoundId': currentRoundId,
    };
  }
}
