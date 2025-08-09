import 'package:dio/dio.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/league_dto.dart';
import 'package:my_league_flutter/model/phase_status.dart';

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

  Future<List<DefaultDto>> getLeagues() async {
    try {
      final response = await _dio.get("/leagues");
      print('Leagues retrieved: ${response.data}');
      return DefaultDto.fromJsonList(response.data);
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

  Future<List<PhaseDto>> getLeaguePhases(String leagueId) async {
    try {
      final response = await _dio.get("/leagues/$leagueId/phases");
      return PhaseDto.fromJsonList(response.data);
    } catch (e) {
      print("Error in GET league phases: $e");
      return [];
    }
  }
}
