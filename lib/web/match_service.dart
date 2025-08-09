import 'package:dio/dio.dart';
import 'package:my_league_flutter/model/match_dto.dart';

class MatchService {
  final Dio _dio;

  MatchService({
    String baseUrl = "https://my-league-backend.onrender.com/my_league/v1",
  }) : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<List<MatchDto>> getMatches() async {
    try {
      final response = await _dio.get('/matches');
      print("Fetched matches: ${response.data}");
      return MatchDto.fromJsonList(response.data);
    } catch (e) {
      print("Error fetching matches: $e");
      return [];
    }
  }
}
