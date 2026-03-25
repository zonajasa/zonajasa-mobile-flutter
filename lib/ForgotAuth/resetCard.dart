// ignore_for_file: deprecated_member_use

import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jasa_app/core/constants/app_constants.dart';
import 'package:jasa_app/login.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';

class Resetcard extends StatefulWidget {
  const Resetcard({super.key});

  @override
  State<Resetcard> createState() => _ResetcardState();
}

class _ResetcardState extends State<Resetcard> {
  bool _isPasswordVisible = false;
  final FocusNode _focusNode = FocusNode();
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
            TextFormField(
              focusNode: _focusNode,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock,
                  size: 25, // ukuran icon lebih besar
                ),
                prefixIconColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.focused)) {
                    return const Color(0xff0e86e4);
                  }
                  return const Color(0xff9b9bb4);
                }),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: _focusNode.hasFocus
                        ? const Color(0xff0e86e4)
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
            ),
            SizedBox(height: 20),
            TextFormField(
              focusNode: _focusNode,
              obscureText: !_isPasswordVisible,
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.lock,
                  size: 25, // ukuran icon lebih besar
                ),
                prefixIconColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.focused)) {
                    return const Color(0xff0e86e4);
                  }
                  return const Color(0xff9b9bb4);
                }),
                suffixIcon: IconButton(
                  icon: Icon(
                    _isPasswordVisible
                        ? Icons.visibility_off
                        : Icons.visibility,
                    color: _focusNode.hasFocus
                        ? const Color(0xff0e86e4)
                        : const Color(0xff9b9bb4),
                  ),
                  onPressed: () {
                    setState(() {
                      _isPasswordVisible = !_isPasswordVisible;
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
            ),
            SizedBox(height: 35),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff0e86e4),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusGeometry.circular(15),
                  ),
                ),
                onPressed: () {
                  // proses otp
                  Navigator.of(
                    context,
                  ).push(MaterialPageRoute(builder: (context) => Login()));
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
    );
  }
}
