class LeagueDto {
  final String id;
  final String name;
  final String activePhaseId;
  final String activeRoundId;
  final bool isTheOwner;

  LeagueDto({
    required this.id,
    required this.name,
    required this.activePhaseId,
    required this.activeRoundId,
    this.isTheOwner = false,
  });

  factory LeagueDto.fromJson(Map<String, dynamic> json) {
    return LeagueDto(
      id: json['id'],
      name: json['name'],
      activePhaseId: json['activePhaseId'] ?? '',
      activeRoundId: json['activeRoundId'] ?? '',
      isTheOwner: json['isTheOwner'] ?? false,
    );
  }

  static List<LeagueDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LeagueDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'activePhaseId': activePhaseId,
      'activeRoundId': activeRoundId,
      'isTheOwner': isTheOwner,
    };
  }
}
