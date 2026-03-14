import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:jasa_app/utils/session_manager.dart';

class UserService {
  static const String baseUrl = "http://192.168.1.9:8085/api/v1";

  static Future<Map<String, dynamic>?> getProfile() async {
    // ambil token dari session
    String? token = await SessionManager.getToken();

    if (token == null) return null; // belum login

    var response = await http.get(
      Uri.parse("$baseUrl/user/auth/profile"),
      headers: {
        "Authorization": "Bearer $token",
        "X-API-PLATFORM": "mobile",
        "X-API-VERSION": "1",
        "X-API-CLIENT-KEY": "YMo38JAe9pug",
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
