import 'package:dio/dio.dart';
import 'package:my_league_flutter/config/config.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/team_dto.dart';

class TeamService {
  final Dio _dio;

  TeamService() : _dio = Dio(BaseOptions(baseUrl: "${ConfigUtils.baseUrl}/teams"));

  Future<TeamDto?> getTeamInfo(String teamId) async {
    try {
      final response = await _dio.get("/$teamId");

      return TeamDto.fromJson(response.data);
    } catch (e) {
      print("Error en getTeamsInfo: $e");
      return null;
    }
  }

  Future<List<DefaultDto>> getTeamsFromLeague(String leagueId) async {
    try {
      final response = await _dio.get("", queryParameters: {"leagueId": leagueId});

      final List<dynamic> data = response.data;
      return data.map((json) => DefaultDto.fromJson(json)).toList();
    } catch (e) {
      print("Error en getTeamsFromLeague: $e");
      return [];
    }
  }
}
