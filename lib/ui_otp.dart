import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jasa_app/AppLoader.dart';
import 'package:jasa_app/ForgotAuth/ResetPasswordPage.dart';
import 'package:jasa_app/navigationPage.dart';
import 'package:jasa_app/services/auth_service.dart';
import 'package:jasa_app/utils/snackbar_helper.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum OtpMode { register, forgotPassword }

String parseError(Object e) {
  return e.toString().replaceAll("Exception:", "").trim();
}

class UiPinCode extends StatefulWidget {
  final String expire;
  final String phone;
  final OtpMode mode;
  final String token;

  const UiPinCode({
    super.key,
    required this.phone,
    required this.mode,
    required this.token,
    required this.expire,
  });
  @override
  State<UiPinCode> createState() => _UiPinCodeState();
}

class _UiPinCodeState extends State<UiPinCode> {
  bool isDisposed = false;
  bool isResendLoading = false;
  String currentExpire = "";
  String errorMessage = "";
  bool isLoading = false;

  bool isVerifying = false;
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;

  int secondsRemaining = 0;
  Timer? timer;

  // ================= TIMER =================

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) {
        timer.cancel();
        return;
      }

      if (secondsRemaining > 0) {
        if (!mounted) return;
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void initExpireTimer() {
    final now = DateTime.now();

    DateTime expireTime;

    if (currentExpire.contains("T")) {
      expireTime = DateTime.parse(currentExpire);
    } else {
      final parts = currentExpire.split(":");

      expireTime = DateTime(
        now.year,
        now.month,
        now.day,
        int.parse(parts[0]),
        int.parse(parts[1]),
        int.parse(parts[2]),
      );
    }

    secondsRemaining = expireTime.difference(now).inSeconds;

    if (secondsRemaining < 0) secondsRemaining = 0;
  }

  String get formattedTime => secondsRemaining.toString().padLeft(2, '0');

  // ================= LIFECYCLE =================

  @override
  void initState() {
    super.initState();

    errorController = StreamController<ErrorAnimationType>();

    currentExpire = widget.expire;

    initExpireTimer();
    startTimer();
  }

  @override
  void dispose() {
    isDisposed = true;

    timer?.cancel();
    errorController?.close();

    super.dispose();
  }

  // ================= OTP VALIDATION =================

  Future<void> validateOtp(String value) async {
    showLoadingDialog();

    try {
      bool isValid;

      if (widget.mode == OtpMode.register) {
        isValid = await AuthService.verifyOtp(
          otp: value,
          kodeUser: widget.token,
          type: "register_token",
        );
      } else {
        isValid = await AuthService.verifyOtp(
          otp: value,
          kodeUser: widget.token,
          type: "forgot_token",
        );
      }

      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      if (isValid) {
        showVerificationSuccess();
      }
    } catch (e) {
      if (!mounted) return;

      Navigator.of(context, rootNavigator: true).pop();

      final msg = e.toString().toLowerCase();

      if (msg.contains("expired")) {
        setState(() {
          secondsRemaining = 0;
        });

        AppSnackbar.showError(context, parseError(e));
        return;
      }

      setState(() {
        hasError = true;
        errorMessage = parseError(e);
      });

      errorController?.add(ErrorAnimationType.shake);
    }
  }

  // ================= DIALOG =================
  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: SizedBox(
            width: 150,
            height: 150,
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xff0e86e4),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Verifying...",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showVerificationSuccess() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                  child: const FaIcon(
                    FontAwesomeIcons.check,
                    color: Colors.white,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 20),

                const Text(
                  "Verification Successful",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Your account has been verified successfully.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff0e86e4),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      Navigator.pop(context);
                      if (!mounted) return;
                      setState(() {
                        isLoading = true;
                      });
                      handleNavigationAfterOtp();
                    },
                    child: const Text(
                      "Continue",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: isLoading
          ? const AppLoader()
          : Container(
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xff0247ae), Color(0xff0e86e4)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              child: SafeArea(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return SingleChildScrollView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: constraints.maxHeight,
                        ),
                        child: IntrinsicHeight(
                          child: Column(
                            children: [
                              const SizedBox(height: 60),

                              /// ICON
                              Container(
                                padding: const EdgeInsets.all(20),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: FaIcon(
                                  FontAwesomeIcons.envelope,
                                  size: 40,
                                  color: Color(0xff0e86e4),
                                ),
                              ),

                              const SizedBox(height: 30),

                              /// TITLE
                              const Text(
                                "OTP Verification",
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),

                              const SizedBox(height: 10),

                              Text(
                                "Kami telah mengirimkan kode 6 digit ke\n${(widget.phone)}",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white70),
                              ),

                              const SizedBox(height: 40),

                              /// WHITE CARD
                              Container(
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 24,
                                ),
                                padding: const EdgeInsets.all(24),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    /// PIN FIELD
                                    PinCodeTextField(
                                      appContext: context,
                                      length: 6,
                                      autoFocus: true,
                                      keyboardType: TextInputType.number,
                                      animationType: AnimationType.fade,
                                      errorAnimationController: isDisposed
                                          ? null
                                          : errorController,
                                      enableActiveFill: true,
                                      pinTheme: PinTheme(
                                        shape: PinCodeFieldShape.box,
                                        borderRadius: BorderRadius.circular(12),
                                        fieldHeight: 55,
                                        fieldWidth: 45,
                                        inactiveColor: Colors.grey.shade300,
                                        selectedColor: hasError
                                            ? Colors.red
                                            : const Color(0xff0e86e4),
                                        activeColor: hasError
                                            ? Colors.red
                                            : const Color(0xff0e86e4),
                                        inactiveFillColor: Colors.grey.shade200,
                                        selectedFillColor: Colors.white,
                                        activeFillColor: Colors.white,
                                      ),
                                      onChanged: (value) {
                                        if (hasError) {
                                          setState(() {
                                            hasError = false;
                                          });
                                        }
                                      },
                                      onCompleted: (value) {
                                        validateOtp(value);
                                      },
                                    ),

                                    if (hasError)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 8),
                                        child: Text(
                                          errorMessage,
                                          style: const TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: 10),

                                    /// RESEND
                                    secondsRemaining > 0
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              const Icon(
                                                Icons.timer_outlined,
                                                size: 18,
                                                color: Colors.black54,
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                "Kirim ulang kode 00:$formattedTime",
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                        : TextButton(
                                            onPressed: isResendLoading
                                                ? null // 🔥 disable kalau lagi loading
                                                : () async {
                                                    if (!mounted) return;

                                                    setState(() {
                                                      isResendLoading = true;
                                                    });

                                                    try {
                                                      final res =
                                                          await AuthService.resendOtp(
                                                            kodeUser:
                                                                widget.token,
                                                          );

                                                      final statusCode =
                                                          res["statusCode"];
                                                      final result =
                                                          res["data"];

                                                      if (statusCode == 200) {
                                                        final expiredAt =
                                                            result["data"]["expired_at"];

                                                        if (!mounted) return;

                                                        timer?.cancel();

                                                        setState(() {
                                                          hasError = false;
                                                          currentExpire =
                                                              expiredAt;
                                                        });

                                                        initExpireTimer();
                                                        startTimer();
                                                        if (!mounted) return;
                                                        AppSnackbar.showSuccess(
                                                          context,
                                                          "Kode OTP baru dikirim",
                                                        );
                                                      } else {
                                                        AppSnackbar.showError(
                                                          context,
                                                          result["message"] ??
                                                              "Gagal kirim ulang",
                                                        );
                                                      }
                                                    } catch (e) {
                                                      AppSnackbar.showError(
                                                        context,
                                                        "Terjadi kesalahan",
                                                      );
                                                    }

                                                    if (!mounted) return;

                                                    setState(() {
                                                      isResendLoading = false;
                                                    });
                                                  },

                                            child: isResendLoading
                                                ? const SizedBox(
                                                    height: 18,
                                                    width: 18,
                                                    child:
                                                        CircularProgressIndicator(
                                                          strokeWidth: 2,
                                                          color: Color(
                                                            0xff5f6dfc,
                                                          ),
                                                        ),
                                                  )
                                                : const Text(
                                                    "Kirim Ulang Kode",
                                                    style: TextStyle(
                                                      color: Color(0xff5f6dfc),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                          ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  void handleNavigationAfterOtp() {
    if (!mounted) return;

    if (widget.mode == OtpMode.register) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const Navigationpage()),
        (route) => false,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ResetpasswordPage()),
      );
    }
  }
}
