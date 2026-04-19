import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jasa_app/utils/session_manager.dart';

//buat profile
class UserService {
  static String baseUrl = dotenv.env['API_BASE_URL']!;

  static Future<Map<String, dynamic>?> getProfile() async {
    // ambil token dari session
    String? token = await SessionManager.getToken();

    if (token == null) return null;

    var response = await http.post(
      Uri.parse("$baseUrl/user/auth/profile"),
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "X-API-PLATFORM": "mobile",
        "X-API-VERSION": "1",
        "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      print("Error fetching profile: ${response.statusCode}");
      return null;
    }
  }
}
