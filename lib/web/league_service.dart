import 'package:dio/dio.dart';
import 'package:my_league_flutter/model/default_dto.dart';
import 'package:my_league_flutter/model/league_dto.dart';

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
}
