import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jasa_app/login.dart';
import 'package:jasa_app/main.dart';
import 'package:jasa_app/utils/session_manager.dart';

class ApiHelper {
  static Future<dynamic> post({
    required BuildContext context,
    required String url,
    required Map<String, String> headers,
    Map<String, dynamic>? body,
  }) async {
    final response = await http.post(
      Uri.parse(url),
      headers: headers,
      body: body != null ? jsonEncode(body) : null,
    );

    print("STATUS: ${response.statusCode}");
    print("BODY: ${response.body}");

    final data = jsonDecode(response.body);

    if (response.statusCode == 401) {
      await SessionManager.logout();

      final message = data["message"] ?? "Session expired";

      messengerKey.currentState?.showSnackBar(SnackBar(content: Text(message)));

      await Future.delayed(const Duration(seconds: 2));

      if (!context.mounted) return null;

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => Login()),
        (route) => false,
      );

      return null;
    }

    return data;
  }
}
