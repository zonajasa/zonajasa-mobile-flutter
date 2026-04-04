import 'dart:convert';
import 'package:http/http.dart' as http;

class AuthService {
  static const String baseUrl = "https://api.zonajasa.com/api/v1";

  static Future login(String ephone, String password) async {
    print("LOGIN REQUEST START");

    var request = http.MultipartRequest(
      "POST",
      Uri.parse("$baseUrl/user/auth/login"),
    );

    request.headers.addAll({
      "X-API-PLATFORM": "mobile",
      "X-API-VERSION": "1",
      "X-API-CLIENT-KEY": "wcvHp8fCDa0V",
    });

    request.fields["nomor_whatsapp"] = ephone;
    request.fields["password"] = password;

    var response = await request.send();
    var responseBody = await response.stream.bytesToString();

    print("LOGIN RESPONSE RECEIVED");
    print(responseBody);

    return jsonDecode(responseBody);
  }
}

// OTP DUMMY
class AuthOtp {
  static Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 2));

    return otp == "123456";
  }

  static Future<bool> verifyRegisterOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == "123456";
  }

  static Future<bool> verifyResetOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 1));
    return otp == "111222";
  }
}
