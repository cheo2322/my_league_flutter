import 'package:flutter_dotenv/flutter_dotenv.dart';

class ConfigUtils {
  static String get baseUrl {
    final url = dotenv.env['MY_LEAGUE_API_BASE_URL'];
    if (url == null || url.isEmpty) {
      throw Exception('MY_LEAGUE_API_BASE_URL no está definido en .env');
    }
    return url;
  }
}
