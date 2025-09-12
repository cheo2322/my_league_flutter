import 'package:dio/dio.dart';
import 'package:my_league_flutter/config/config.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/model/positions_table_dto.dart';
import 'package:my_league_flutter/model/round_dto.dart';

class LeagueService {
  final Dio _dio;

  LeagueService() : _dio = Dio(BaseOptions(baseUrl: "${ConfigUtils.baseUrl}/leagues"));

  Future<DefaultDto?> postLeague(LeagueDto body) async {
    try {
      final response = await _dio.post("", data: body.toJson());
      return DefaultDto.fromJson(response.data);
    } catch (e) {
      print("Error en postLeague: $e");
      return null;
    }
  }

  Future<List<DefaultDto>?> getTeamsFromLeague(String leagueId) async {
    try {
      final response = await _dio.get("/$leagueId/teams");
      return DefaultDto.fromJsonList(response.data);
    } catch (e) {
      print("Error in GET teams");
      return null;
    }
  }

  Future<DefaultDto?> addTeamToLeague(DefaultDto teamDto, String leagueId) async {
    try {
      final response = await _dio.post("/$leagueId/team", data: teamDto.toJson());
      return DefaultDto.fromJson(response.data);
    } catch (e) {
      print("Error in createTeam");

      return null;
    }
  }

  Future<List<DefaultDto>> getLeagues(String token) async {
    try {
      final response = await _dio.get(
        "",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      print('Leagues retrieved: ${response.data}');
      return DefaultDto.fromJsonList(response.data);
    } catch (e) {
      print('Error getting leagues: $e');
      return [];
    }
  }

  Future<LeagueDto?> getLeague(String leagueId, String? token) async {
    try {
      final response = await _dio.get(
        "/$leagueId",
        options: Options(headers: {"Authorization": "Bearer ${token ?? ''}"}),
      );

      return LeagueDto.fromJson(response.data);
    } catch (e) {
      print("Error in GET league: $e");
      return null;
    }
  }

  Future<PositionsTableDto?> getLeaguePositions(
    String leagueId,
    String phaseId,
    String roundId,
  ) async {
    try {
      final response = await _dio.get("/$leagueId/positions/$phaseId/$roundId");

      print("League positions retrieved: ${response.data}");

      return PositionsTableDto.fromJson(response.data);
    } catch (e) {
      print("Error in GET league positions: $e");
      return null;
    }
  }

  Future<List<RoundDto>> getRoundsFromActivePhaseByLeagueId(String leagueId) async {
    try {
      final response = await _dio.get("/$leagueId/phases/active/rounds");
      return RoundDto.fromJsonList(response.data);
    } catch (e) {
      print("Error in GET rounds from active phase: $e");
      return [];
    }
  }
}
