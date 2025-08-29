import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:my_league_flutter/model/favourites_dto.dart';

class MainService {
  final Dio _dio;

  MainService({String baseUrl = "https://my-league-backend.onrender.com/my_league/v1/main"})
    : _dio = Dio(BaseOptions(baseUrl: baseUrl));

  final FlutterSecureStorage secureStorage = FlutterSecureStorage();

  Future<FavouritesDto?> getFavourites() async {
    try {
      final token = await secureStorage.read(key: 'auth_token');
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
