import 'dart:async';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UiPinCode extends StatefulWidget {
  const UiPinCode({super.key});

  @override
  State<UiPinCode> createState() => _UiPinCodeState();
}

class _UiPinCodeState extends State<UiPinCode> {
  final TextEditingController otpController = TextEditingController();

  int secondsRemaining = 55;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
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
    otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff5f6dfc), Color(0xff9f5afd)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
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
                    color: Color(0xff5f6dfc),
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
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Column(
                    children: [
                      /// PIN FIELD
                      PinCodeTextField(
                        appContext: context,
                        length: 6,
                        controller: otpController,
                        autoFocus: true,
                        keyboardType: TextInputType.number,
                        animationType: AnimationType.fade,
                        enableActiveFill: true,
                        pinTheme: PinTheme(
                          shape: PinCodeFieldShape.box,
                          borderRadius: BorderRadius.circular(12),
                          fieldHeight: 55,
                          fieldWidth: 45,
                          inactiveColor: Colors.grey.shade300,
                          selectedColor: const Color(0xff5f6dfc),
                          activeColor: const Color(0xff5f6dfc),
                          inactiveFillColor: Colors.grey.shade200,
                          selectedFillColor: Colors.white,
                          activeFillColor: Colors.white,
                        ),
                        onChanged: (value) {},
                        onCompleted: (value) {
                          debugPrint("OTP: $value");
                        },
                      ),

                      const SizedBox(height: 10),

                      /// RESEND
                      secondsRemaining > 0
                          ? Text(
                              "Resend code in 00:$formattedTime",
                              style: const TextStyle(color: Colors.black54),
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
      ),
    );
  }
}
