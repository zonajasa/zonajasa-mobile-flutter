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
    try {
      var request = http.MultipartRequest(
        "POST",
        Uri.parse("$baseUrl/user/auth/register"),
      );

      request.headers.addAll({
        "X-API-PLATFORM": "mobile",
        "X-API-VERSION": "1",
        "X-API-CLIENT-KEY": dotenv.env['API_CLIENT_KEY']!,
      });

      request.fields["nama_lengkap"] = nama;
      request.fields["nomor_whatsapp"] = noWhatsapp;
      request.fields["password"] = password;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      final data = jsonDecode(responseBody);

      if (response.statusCode == 200 || response.statusCode == 201) {
        return data;
      } else {
        throw Exception(data['message'] ?? 'Register gagal');
      }
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  //VERIFIKASI OTP REGISTRASI
  static Future<bool> verifyOtp({
    required String otp,
    required String waEncrypted,
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
      request.fields["wa_encrypted"] = waEncrypted;

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();

      final data = jsonDecode(responseBody);

      print("VERIFY OTP RESPONSE: $data");

      if (response.statusCode == 200) {
        final token = data['data']['token'];
        final nama = data['data']['user']['nama_lengkap'];

        await SessionManager.saveUser(token, nama);

        return true;
      } else {
        throw Exception(data['message'] ?? 'OTP salah');
      }
    } catch (e) {
      throw Exception(e.toString());
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
