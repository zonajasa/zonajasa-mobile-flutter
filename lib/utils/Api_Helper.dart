import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jasa_app/login.dart';
import 'package:jasa_app/utils/session_manager.dart';
import 'package:jasa_app/utils/snackbar_helper.dart';

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

    final data = jsonDecode(response.body);

    // 🔥 GLOBAL 401 HANDLER
    if (response.statusCode == 401) {
      await SessionManager.logout();

      if (!context.mounted) return null;

      AppSnackbar.showError(context, data["message"] ?? "Session expired");

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
