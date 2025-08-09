class MatchDto {
  final String? id;
  final String homeTeam;
  final String visitTeam;
  final int? homeResult;
  final int? visitResult;
  final String status;
  final String date;
  final String time;

  MatchDto({
    required this.id,
    required this.homeTeam,
    required this.visitTeam,
    required this.homeResult,
    required this.visitResult,
    required this.status,
    required this.date,
    required this.time,
  });

  factory MatchDto.fromJson(Map<String, dynamic> json) {
    return MatchDto(
      id: json['id'],
      homeTeam: json['homeTeam'],
      visitTeam: json['visitTeam'],
      homeResult: json['homeResult'],
      visitResult: json['visitResult'],
      status: json['status'],
      date: json['date'],
      time: json['time'],
    );
  }

  static List<MatchDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => MatchDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'home': homeTeam,
      'visit': visitTeam,
      'homeResult': homeResult,
      'visitResult': visitResult,
      'status': status,
      'date': date,
      'time': time,
    };
  }
}
