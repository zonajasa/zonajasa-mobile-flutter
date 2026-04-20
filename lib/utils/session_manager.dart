import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  static Future saveUser(String token, String nama, String expiredAt) async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString("token", token);
    await prefs.setString("nama_lengkap", nama);
    await prefs.setString("expired_at", expiredAt);
  }

  static Future<String?> getExpiredAt() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("expired_at");
  }

  static Future<bool> isTokenExpired() async {
    final expiredAt = await getExpiredAt();

    if (expiredAt == null) return true;

    final expiryDate = DateTime.parse(expiredAt);
    return DateTime.now().isAfter(expiryDate);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("token");
  }

  static Future<String?> getNama() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString("nama_lengkap");
  }

  static Future logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("token");
    await prefs.remove("nama_lengkap");
    await prefs.remove("expired_at");
  }
}
