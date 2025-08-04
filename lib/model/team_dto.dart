class TeamDto {
  final String? id;
  final String name;
  final String leagueId;

  TeamDto({this.id, required this.name, required this.leagueId});

  factory TeamDto.fromJson(Map<String, dynamic> json) {
    return TeamDto(
      id: json['id'],
      name: json['name'],
      leagueId: json['leagueId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, leagueId: leagueId};
  }
}
