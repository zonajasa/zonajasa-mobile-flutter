import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:jasa_app/utils/api_helper.dart';
import 'package:jasa_app/utils/session_manager.dart';

class UserService {
  static String baseUrl = dotenv.env['API_BASE_URL']!;

  static Future<Map<String, dynamic>?> getProfile(BuildContext context) async {
    String? token = await SessionManager.getToken();

    if (token == null) return null;

    final data = await ApiHelper.post(
      context: context,
      url: "$baseUrl/user/auth/profile",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $token",
        "X-API-PLATFORM": "mobile",
        "X-API-VERSION": "1",
        "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
      },
    );

    return data;
  }
}