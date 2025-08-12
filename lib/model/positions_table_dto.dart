import 'package:my_league_flutter/model/position_dto.dart';

class PositionsTableDto {
  final String id;
  final int round;
  final List<PositionDto> positions;

  const PositionsTableDto({
    required this.id,
    required this.round,
    required this.positions,
  });

  factory PositionsTableDto.fromJson(Map<String, dynamic> json) {
    return PositionsTableDto(
      id: json['id'] as String,
      round: json['round'] as int,
      positions: PositionDto.fromJsonList(json['positions'] as List),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'round': round,
      'positions': PositionDto.listToJson(positions),
    };
  }

  static List<PositionsTableDto> listFromJson(List<dynamic> jsonList) {
    return jsonList.map((json) => PositionsTableDto.fromJson(json)).toList();
  }

  static List<Map<String, dynamic>> listToJson(List<PositionsTableDto> rounds) {
    return rounds.map((round) => round.toJson()).toList();
  }

  @override
  String toString() {
    return 'RoundPositionsDto(id: $id, round: $round, positions: $positions)';
  }
}
