import 'package:dio/dio.dart';
import 'package:my_league_flutter/model/match_details.dart';
import 'package:my_league_flutter/model/match_dto.dart';

class MatchService {
  final Dio _dio;

  MatchService({String baseUrl = "https://my-league-backend.onrender.com/my_league/v1"})
    : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  @Deprecated("Not available")
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

  Future<MatchDetailsDto?> getMatchDetails(String matchId, String? token) async {
    try {
      final response = await _dio.get(
        '/matches/$matchId/details',
        options: Options(headers: {"Authorization": "Bearer ${token ?? ''}"}),
      );
      print("Fetched match details: ${response.data}");
      return MatchDetailsDto.fromJson(response.data);
    } catch (e) {
      print("Error fetching match details: $e");
      return null;
    }
  }

  Future<bool> updateMatchResult(
    String matchId,
    int homeResult,
    int visitResult,
    String? token,
  ) async {
    try {
      final response = await _dio.patch(
        '/matches/$matchId',
        queryParameters: {'homeResult': homeResult, 'visitResult': visitResult},
        options: Options(headers: {"Authorization": "Bearer ${token ?? ''}"}),
      );

      if (response.statusCode == 200 && response.data == "OK") {
        print("Resultado actualizado correctamente");
        return true;
      } else {
        print("Error inesperado: ${response.statusCode} → ${response.data}");
        return false;
      }
    } catch (e) {
      print("Error al actualizar resultado: $e");
      return false;
    }
  }
}
