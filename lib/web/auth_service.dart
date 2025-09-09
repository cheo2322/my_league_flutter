import 'package:dio/dio.dart';
import 'package:my_league_flutter/config/config.dart';
import 'package:my_league_flutter/model/login_dto.dart';

class AuthService {
  final Dio _dio;

  AuthService({Dio? dio}) : _dio = dio ?? Dio(BaseOptions(baseUrl: '${ConfigUtils.baseUrl}/auth'));

  Future<LoginDto?> register({
    required String username,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post(
        '/register',
        data: {'username': username, 'email': email, 'password': password},
      );

      final statusCode = response.statusCode;

      if (statusCode == 200) {
        return LoginDto.fromJson(response.data);
      } else {
        return null;
      }
    } on DioException catch (e) {
      if (e.response != null) {
        final errorCode = e.response?.statusCode;
        final errorMessage = e.response?.data.toString();
        print('Error $errorCode: $errorMessage');
        return null;
      } else {
        throw Exception('Error de red: ${e.message}');
      }
    }
  }

  Future<String?> login({required String email, required String password}) async {
    try {
      final response = await _dio.post('/login', data: {'email': email, 'password': password});

      return response.data.toString();
    } on DioException {
      return null;
    }
  }
}
