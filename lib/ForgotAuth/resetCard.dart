// ignore_for_file: deprecated_member_use

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jasa_app/core/constants/app_constants.dart';
import 'package:jasa_app/login.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import 'package:jasa_app/services/auth_service.dart';

class Resetcard extends StatefulWidget {
  final String kodeUser;
  const Resetcard({super.key, required this.kodeUser});

  @override
  State<Resetcard> createState() => _ResetcardState();
}

class _ResetcardState extends State<Resetcard> {
  bool isPasswordInvalid = false;
  bool isConfirmInvalid = false;

  bool hasSubmitted = false;

  bool _isConfirmVisible = false;
  bool _isPasswordVisible = false;

  final _passwordFocus = FocusNode();
  final _confirmFocus = FocusNode();

  String passwordError = "";
  String confirmError = "";
  bool isLoading = false;

  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    _passwordFocus.addListener(() {
      setState(() {});
    });

    _confirmFocus.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 200, left: 20, right: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding: const EdgeInsets.all(AppConstants.paddingM),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                ),
                child: Row(
                  children: [
                    const HugeIcon(
                      icon: HugeIcons.strokeRoundedInformationCircle,
                      color: AppColors.primary,
                      size: 24,
                    ),
                    const SizedBox(width: AppConstants.paddingM),
                    Expanded(
                      child: Text(
                        'Buat kata sandi yang kuat dengan minimal 8 karakter, yang terdiri dari huruf besar, huruf kecil, angka, dan karakter khusus.',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 50),
              //PASSWORD BARU
              TextFormField(
                controller: passwordController,
                focusNode: _passwordFocus,
                obscureText: !_isPasswordVisible,
                onChanged: (_) {
                  if (passwordError.isNotEmpty) {
                    setState(() => passwordError = "");
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, size: 25),
                  prefixIconColor: WidgetStateColor.resolveWith((states) {
                    final isFocused = states.contains(WidgetState.focused);

                    if (isFocused) {
                      if (isPasswordInvalid) {
                        return Colors.red;
                      }
                      return const Color(0xff0e86e4);
                    }

                    return const Color(0xff9b9bb4);
                  }),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: (_passwordFocus.hasFocus || hasSubmitted)
                          ? (isPasswordInvalid
                                ? Colors.red
                                : const Color(0xff0e86e4))
                          : const Color(0xff9b9bb4),
                    ),
                    onPressed: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),
                  hintText: "Kata Sandi Baru",
                  hintStyle: const TextStyle(
                    fontSize: 15, // teks hint lebih besar
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, // tinggi kotak input lebih kecil
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xff9b9bb4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xff9b9bb4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xff0e86e4),
                      width: 2,
                    ), // biru saat fokus
                  ),
                ),
                validator: (value) {
                  if (passwordError.isNotEmpty) {
                    isPasswordInvalid = true;
                    return passwordError;
                  }

                  if (value == null || value.isEmpty) {
                    isPasswordInvalid = true;
                    return "Password tidak boleh kosong";
                  }

                  isPasswordInvalid = false;
                  return null;
                },
              ),
              SizedBox(height: 20),
              //KONFIRMASI PASSWORD
              TextFormField(
                controller: confirmController,
                focusNode: _confirmFocus,
                obscureText: !_isConfirmVisible,
                onChanged: (_) {
                  if (confirmError.isNotEmpty) {
                    setState(() => confirmError = "");
                  }
                },
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.lock, size: 25),
                  prefixIconColor: WidgetStateColor.resolveWith((states) {
                    final isFocused = states.contains(WidgetState.focused);

                    if (isFocused) {
                      if (isConfirmInvalid) {
                        return Colors.red;
                      }
                      return const Color(0xff0e86e4);
                    }

                    return const Color(0xff9b9bb4);
                  }),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isConfirmVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                      color: (_confirmFocus.hasFocus || hasSubmitted)
                          ? (isConfirmInvalid
                                ? Colors.red
                                : const Color(0xff0e86e4))
                          : const Color(0xff9b9bb4),
                    ),
                    onPressed: () {
                      setState(() {
                        _isConfirmVisible = !_isConfirmVisible;
                      });
                    },
                  ),
                  hintText: "Konfirmasi Kata Sandi Baru",
                  hintStyle: const TextStyle(
                    fontSize: 15, // teks hint lebih besar
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(
                    vertical: 12, // tinggi kotak input lebih kecil
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xff9b9bb4)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(color: Color(0xff9b9bb4)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: const BorderSide(
                      color: Color(0xff0e86e4),
                      width: 2,
                    ), // biru saat fokus
                  ),
                ),
                validator: (value) {
                  if (confirmError.isNotEmpty) {
                    isConfirmInvalid = true;
                    return confirmError;
                  }

                  if (value == null || value.isEmpty) {
                    isConfirmInvalid = true;
                    return "Konfirmasi password tidak boleh kosong";
                  }

                  if (value != passwordController.text) {
                    isConfirmInvalid = true;
                    return "Password tidak sama";
                  }

                  isConfirmInvalid = false;
                  return null;
                },
              ),
              SizedBox(height: 35),
              //TOMBOL UBAH PASSWORD
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xff0e86e4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadiusGeometry.circular(15),
                    ),
                  ),
                  onPressed: isLoading
                      ? null
                      : () async {
                          setState(() {
                            hasSubmitted = false;
                          });
                          if (!_formKey.currentState!.validate()) return;

                          setState(() => isLoading = true);

                          try {
                            await AuthService.resetPassword(
                              kodeUser: widget.kodeUser,
                              password: passwordController.text,
                              passwordConfirmation: confirmController.text,
                            );

                            if (!mounted) return;

                            setState(() => isLoading = false);

                            Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (_) => Login()),
                              (route) => false,
                            );
                          } catch (e) {
                            if (!mounted) return;

                            final errorString = e
                                .toString()
                                .replaceAll("Exception:", "")
                                .trim();

                            try {
                              final decoded = jsonDecode(errorString);
                              final errors = decoded["errors"];

                              for (var err in errors) {
                                if (err["field"] == "password") {
                                  passwordError = err["message"];
                                }

                                if (err["field"] == "password_confirmation") {
                                  confirmError = err["message"];
                                }
                              }
                            } catch (_) {}

                            setState(() {
                              isLoading = false;
                            });
                            _formKey.currentState?.validate();
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: const Text(
                      "Ubah Password",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 15),
            ],
          ),
        ),
      ),
    );
  }
}
