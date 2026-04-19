import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:jasa_app/utils/session_manager.dart';

class AuthService {
  static String baseUrl = dotenv.env['API_BASE_URL']!;

  static Future login(String ephone, String password) async {
    print("LOGIN REQUEST START");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/user/auth/login"),
    );

    request.headers.addAll({
      "X-API-PLATFORM": "mobile",
      "X-API-VERSION": "1",
      "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
    });

    request.fields["nomor_whatsapp"] = ephone;
    request.fields["password"] = password;

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print("LOGIN RESPONSE RECEIVED");
    print(responseBody);

    return jsonDecode(responseBody);
  }

  //REGISTER
  static Future<Map<String, dynamic>> register({
    required String nama,
    required String noWhatsapp,
    required String password,
  }) async {
    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/user/auth/register"),
    );

    request.headers.addAll({
      "X-API-PLATFORM": "mobile",
      "X-API-VERSION": "1",
      "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
    });

    request.fields["full_name"] = nama;
    request.fields["nomor_whatsapp"] = noWhatsapp;
    request.fields["password"] = password;

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    final data = jsonDecode(responseBody);

    return {"statusCode": response.statusCode, "data": data};
  }

  //VERIFIKASI OTP REGISTRASI
  static Future<bool> verifyOtp({
    required String otp,
    required String kodeUser,
    required String type,
  }) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/user/auth/verify-otp"),
      );

      request.headers.addAll({
        "X-API-PLATFORM": "mobile",
        "X-API-VERSION": "1",
        "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
      });

      request.fields["otp"] = otp;
      request.fields["kode_user"] = kodeUser;
      request.fields["type"] = type;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      final data = jsonDecode(responseBody);

      print("VERIFY OTP RESPONSE: $data");

      if (response.statusCode == 200) {
        if (type == "register_token") {
          final token = data['data']['token'];
          final nama = data['data']['user']['full_name'];

          await SessionManager.saveUser(token, nama);
        }
        return true;
      } else {
        throw Exception(data['message'] ?? 'OTP salah');
      }
    } catch (e) {
      rethrow;
    }
  }

  // RESEND OTP
  static Future<Map<String, dynamic>> resendOtp({
    required String kodeUser,
  }) async {
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/user/auth/resend-otp"),
      );

      request.headers.addAll({
        "X-API-PLATFORM": "mobile",
        "X-API-VERSION": "1",
        "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
      });

      request.fields["kode_user"] = kodeUser;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      final data = jsonDecode(responseBody);

      print("RESEND OTP RESPONSE: $data");

      return {"statusCode": response.statusCode, "data": data};
    } catch (e) {
      throw Exception("Gagal resend OTP");
    }
  }

  //FORGOT PASSWORD
  static Future<Map<String, dynamic>> forgotPassword({
    required String phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/user/auth/forgot-password"),
        headers: {
          "Content-Type": "application/json",
          "X-API-PLATFORM": "mobile",
          "X-API-VERSION": "1",
          "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
        },
        body: jsonEncode({"nomor_whatsapp": phone}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data["message"] ?? "Gagal request reset");
      }
    } catch (e) {
      rethrow;
    }
  }

  //RESET PASSWORD
  static Future<Map<String, dynamic>> resetPassword({
    required String kodeUser,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await http.post(
        Uri.parse("$baseUrl/user/auth/reset-password"),
        headers: {
          "Content-Type": "application/json",
          "X-API-PLATFORM": "mobile",
          "X-API-VERSION": "1",
          "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
        },
        body: jsonEncode({
          "kode_user": kodeUser,
          "password": password,
          "password_confirmation": passwordConfirmation,
        }),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200) {
        return data;
      } else {
        throw Exception(data["message"] ?? "Reset password gagal");
      }
    } catch (e) {
      rethrow;
    }
  }
}

// OTP DUMMY
class AuthOtp {
  static Future<bool> verifyResetOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == "111222";
  }
}
