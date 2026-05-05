import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
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

  static Future<bool> becomeProvider(int userId, String namaLengkap) async {
    try {
      final token = await SessionManager.getToken();

      final response = await http.put(
        Uri.parse("$baseUrl/user/profile/$userId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "X-API-PLATFORM": "mobile",
          "X-API-VERSION": "1",
          "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "role_id": 2,
          "full_name": namaLengkap,
          "image": null,
        }),
      );

      print("STATUS: ${response.statusCode}");
      print("BODY: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error becomeProvider: $e");
      return false;
    }
  }

  static Future<bool> cancelProvider(int userId, String namaLengkap) async {
    try {
      final token = await SessionManager.getToken();

      final response = await http.put(
        Uri.parse("$baseUrl/user/profile/$userId"),
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
          "X-API-PLATFORM": "mobile",
          "X-API-VERSION": "1",
          "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
          "Content-Type": "application/json",
        },
        body: jsonEncode({
          "role_id": 1,
          "full_name": namaLengkap,
          "image": null,
        }),
      );

      print("CANCEL STATUS: ${response.statusCode}");
      print("CANCEL BODY: ${response.body}");

      return response.statusCode == 200;
    } catch (e) {
      print("Error cancelProvider: $e");
      return false;
    }
  }

  static Future<bool> createService(Map<String, dynamic> body) async {
    try {
      final token = await SessionManager.getToken();

      final response = await http.post(
        Uri.parse("$baseUrl/user/jasa"),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
          "X-API-PLATFORM": "mobile",
          "X-API-VERSION": "1",
          "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
        },
        body: jsonEncode(body),
      );

      print("CREATE SERVICE STATUS: ${response.statusCode}");
      print("CREATE SERVICE BODY: ${response.body}");

      return response.statusCode == 200 || response.statusCode == 201;
    } catch (e) {
      print("ERROR CREATE SERVICE: $e");
      return false;
    }
  }
}
