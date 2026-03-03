class AuthService {
  static Future<bool> verifyOtp(String otp) async {
    await Future.delayed(const Duration(seconds: 2));

    // nanti diganti http call
    return otp == "123456";
  }
}
