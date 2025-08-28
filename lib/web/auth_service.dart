import 'package:dio/dio.dart';

class AuthService {
  final Dio _dio;

  AuthService({Dio? dio})
    : _dio =
          dio ??
          Dio(
            BaseOptions(
              baseUrl:
                  'https://my-league-backend.onrender.com/my_league/v1/auth',
            ),
          );

  Future<String> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {'username': username, 'email': email, 'password': password},
      );

      return response.data.toString();
    } on DioException catch (e) {
      if (e.response != null) {
        return "nothing";
      } else {
        throw Exception('Error de red: ${e.message}');
      }
    }
  }

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/login',
        data: {'email': email, 'password': password},
      );

      return response.data.toString();
    } on DioException catch (e) {
      return null;
    }
  }
}
