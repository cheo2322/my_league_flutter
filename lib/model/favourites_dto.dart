import 'package:my_league_flutter/model/match_dto.dart';
import 'package:my_league_flutter/model/round_dto.dart';

class FavouritesDto {
  final String userId;
  final List<FavouriteLeague> leagues;
  final List<FavouriteTeam> teams;

  const FavouritesDto({required this.userId, required this.leagues, required this.teams});

  factory FavouritesDto.fromJson(Map<String, dynamic> json) {
    return FavouritesDto(
      userId: json['userId'],
      leagues: FavouriteLeague.fromJsonList(json['leagues'] ?? []),
      teams: FavouriteTeam.fromJsonList(json['teams'] ?? []),
    );
  }

  static List<FavouritesDto> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FavouritesDto.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'leagues': leagues.map((l) => l.toJson()).toList(),
      'teams': teams.map((t) => t.toJson()).toList(),
    };
  }
}

class FavouriteLeague {
  final String userId;
  final String name;
  final bool hasStarted;
  final RoundDto roundDto;

  const FavouriteLeague({
    required this.userId,
    required this.name,
    required this.hasStarted,
    required this.roundDto,
  });

  factory FavouriteLeague.fromJson(Map<String, dynamic> json) {
    return FavouriteLeague(
      userId: json['userId'],
      name: json['name'],
      hasStarted: json['hasStarted'],
      roundDto: RoundDto.fromJson(json['roundDto']),
    );
  }

  static List<FavouriteLeague> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FavouriteLeague.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'name': name,
      'hasStarted': hasStarted,
      'roundDto': roundDto.toJson(),
    };
  }
}

class FavouriteTeam {
  final String id;
  final String name;
  final MatchDto matchDto;

  const FavouriteTeam({required this.id, required this.name, required this.matchDto});

  factory FavouriteTeam.fromJson(Map<String, dynamic> json) {
    return FavouriteTeam(
      id: json['id'],
      name: json['name'],
      matchDto: MatchDto.fromJson(json['matchDto']),
    );
  }

  static List<FavouriteTeam> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => FavouriteTeam.fromJson(json)).toList();
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'matchDto': matchDto.toJson()};
  }
}
