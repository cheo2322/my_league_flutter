import 'package:dio/dio.dart';
import 'package:my_league_flutter/model/team_dto.dart';

class TeamService {
  final Dio _dio;

  TeamService({
    String baseUrl = "https://my-league-backend.onrender.com/my_league/v1",
  }) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<TeamDto?> getTeamInfo(String teamId) async {
    try {
      final response = await _dio.get("/teams/$teamId");

      return TeamDto.fromJson(response.data);
    } catch (e) {
      print("Error en getTeamsInfo: $e");
      return null;
    }
  }
}
