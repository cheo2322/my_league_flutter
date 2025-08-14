import 'package:dio/dio.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/model/phase_status.dart';
import 'package:my_league_flutter/model/positions_table_dto.dart';
import 'package:my_league_flutter/model/round_dto.dart';

class LeagueService {
  final Dio _dio;

  LeagueService({
    String baseUrl = "https://my-league-backend.onrender.com/my_league/v1",
  }) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<DefaultDto?> postLeague(LeagueDto body) async {
    try {
      final response = await _dio.post("/leagues", data: body.toJson());
      return DefaultDto.fromJson(response.data);
    } catch (e) {
      print("Error en postLeague: $e");
      return null;
    }
  }

  Future<List<DefaultDto>?> getTeamsFromLeague(String leagueId) async {
    try {
      final response = await _dio.get("/leagues/$leagueId/teams");
      return DefaultDto.fromJsonList(response.data);
    } catch (e) {
      print("Error in GET teams");
      return null;
    }
  }

  Future<DefaultDto?> addTeamToLeague(
    DefaultDto teamDto,
    String leagueId,
  ) async {
    try {
      final response = await _dio.post(
        "/leagues/$leagueId/team",
        data: teamDto.toJson(),
      );
      return DefaultDto.fromJson(response.data);
    } catch (e) {
      print("Error in createTeam");

      return null;
    }
  }

  Future<List<LeagueDto>> getLeagues() async {
    try {
      final response = await _dio.get("/leagues");
      print('Leagues retrieved: ${response.data}');
      return LeagueDto.fromJsonList(response.data);
    } catch (e) {
      print('Error getting leagues: $e');
      return [];
    }
  }

  Future<LeagueDto?> getLeague(String leagueId) async {
    try {
      final response = await _dio.get("/leagues/$leagueId");
      return LeagueDto.fromJson(response.data);
    } catch (e) {
      print("Error in GET league: $e");
      return null;
    }
  }

  Future<List<RoundDto>> getMainPage() async {
    try {
      final response = await _dio.get("/main");
      return RoundDto.fromJsonList(response.data);
    } catch (e) {
      print("Error in GET main page: $e");
      return [];
    }
  }

  Future<PositionsTableDto?> getLeaguePositions(
    String leagueId,
    String phaseId,
    String roundId,
  ) async {
    try {
      final response = await _dio.get(
        "/leagues/$leagueId/positions/$phaseId/$roundId",
      );

      print("League positions retrieved: ${response.data}");

      return PositionsTableDto.fromJson(response.data);
    } catch (e) {
      print("Error in GET league positions: $e");
      return null;
    }
  }

  Future<List<RoundDto>> getRoundsFromActivePhaseByLeagueId(
    String leagueId,
  ) async {
    try {
      final response = await _dio.get(
        "/leagues/$leagueId/phases/active/rounds",
      );
      return RoundDto.fromJsonList(response.data);
    } catch (e) {
      print("Error in GET rounds from active phase: $e");
      return [];
    }
  }
}
