import 'dart:async';
import 'package:flutter/material.dart';
import 'package:jasa_app/AppLoader.dart';
import 'package:jasa_app/ForgotAuth/ResetPasswordPage.dart';
import 'package:jasa_app/navigationPage.dart';
import 'package:jasa_app/services/auth_service.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum OtpMode { register, forgotPassword }

class UiPinCode extends StatefulWidget {
  final String phone;
  final OtpMode mode;

  const UiPinCode({super.key, required this.phone, required this.mode});
  @override
  State<UiPinCode> createState() => _UiPinCodeState();
}

class _UiPinCodeState extends State<UiPinCode> {
  bool isLoading = false;
  late BuildContext pageContext;
  final TextEditingController otpController = TextEditingController();
  final String dummyCode = "123456";

  bool isVerifying = false;
  StreamController<ErrorAnimationType>? errorController;
  bool hasError = false;
  int secondsRemaining = 55;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    errorController = StreamController<ErrorAnimationType>();
  }

  void startTimer() {
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (secondsRemaining > 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  String get formattedTime => secondsRemaining.toString().padLeft(2, '0');

  @override
  void dispose() {
    timer?.cancel();
    errorController?.close();
    super.dispose();
  }

  // ====== KALAU ADA API SISA GANTI BAGIAN INI AJA ===//
  Future<void> validateOtp(String value) async {
    showLoadingDialog();

    bool isValid = await AuthServices.verifyOtp(value);

    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).pop();

    if (isValid) {
      showVerificationSuccess();
    } else {
      setState(() {
        hasError = true;
      });

      errorController?.add(ErrorAnimationType.shake);
      otpController.clear();
    }
  }
  // == END ==//

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

                      setState(() {
                        isLoading = true;
                      });

                      await Future.delayed(const Duration(seconds: 2));

                      if (!mounted) return;

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
    pageContext = context;
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

                              const Text(
                                "We sent a 6-digit code to\n+62 8••• •••• 1234",
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
                                      controller: otpController,
                                      autoFocus: true,
                                      keyboardType: TextInputType.number,
                                      animationType: AnimationType.fade,
                                      errorAnimationController: errorController,
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
                                      const Padding(
                                        padding: EdgeInsets.only(top: 8),
                                        child: Text(
                                          "Kode OTP salah. Coba lagi.",
                                          style: TextStyle(
                                            color: Colors.red,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),

                                    const SizedBox(height: 15),

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
                                                "Resend code in 00:$formattedTime",
                                                style: const TextStyle(
                                                  color: Colors.black54,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          )
                                        : TextButton(
                                            onPressed: () {
                                              setState(() {
                                                secondsRemaining = 55;
                                              });
                                              startTimer();
                                            },
                                            child: const Text(
                                              "Resend Code",
                                              style: TextStyle(
                                                color: Color(0xff5f6dfc),
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                  ],
                                ),
                              ),

                              const SizedBox(height: 30),

                              const Text(
                                "Try: 123456",
                                style: TextStyle(color: Colors.white70),
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
    if (widget.mode == OtpMode.register) {
      Navigator.pushAndRemoveUntil(
        pageContext,
        MaterialPageRoute(builder: (_) => const Navigationpage()),
        (route) => false,
      );
    } else {
      Navigator.pushReplacement(
        pageContext,
        MaterialPageRoute(builder: (_) => const ResetpasswordPage()),
      );
    }
  }
}
