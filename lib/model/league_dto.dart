class LeagueDto {
  final String name;
  final String major;

  LeagueDto({required this.name, required this.major});

  factory LeagueDto.fromJson(Map<String, dynamic> json) {
    return LeagueDto(name: json['name'], major: json['major']);
  }

  static List<LeagueDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => LeagueDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'name': name, 'major': major};
  }
}
