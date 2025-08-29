import 'package:dio/dio.dart';
import 'package:my_league_flutter/model/favourites_dto.dart';

class MainService {
  final Dio _dio;

  MainService({String baseUrl = "https://my-league-backend.onrender.com/my_league/v1/main"})
    : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  Future<FavouritesDto?> getFavourites(String token) async {
    try {
      final response = await _dio.get(
        "/favourites",
        options: Options(headers: {"Authorization": "Bearer $token"}),
      );
      return FavouritesDto.fromJson(response.data);
    } catch (e) {
      print("Error in GET favourites: $e");
      return null;
    }
  }
}
