import 'package:flutter/material.dart';
import 'package:jasa_app/ui_otp.dart';

class Forgotcard extends StatefulWidget {
  const Forgotcard({super.key});

  @override
  State<Forgotcard> createState() => _ForgotcardState();
}

class _ForgotcardState extends State<Forgotcard> {
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.only(top: 300, left: 20, right: 20),
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
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
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.phone_android, size: 25),
                  prefixIconColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.error)) {
                      return const Color.fromARGB(255, 167, 41, 32);
                    }
                    if (states.contains(WidgetState.focused)) {
                      return const Color(0xff0e86e4);
                    }
                    return const Color(0xff9b9bb4);
                  }),
                  hintText: "Nomor WhatsApp",
                  hintStyle: const TextStyle(fontSize: 18),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(vertical: 12),
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
                    ),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Masukkan nomor WhatsApp';
                  }

                  final phone = value.replaceAll(' ', '');

                  if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
                    return 'Nomor harus berupa angka';
                  }

                  if (phone.length < 10 || phone.length > 15) {
                    return 'Nomor tidak valid';
                  }

                  if (!phone.startsWith('08') && !phone.startsWith('62')) {
                    return 'Gunakan format 08 atau 62';
                  }

                  return null;
                },
              ),
              SizedBox(height: 35),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff0e86e4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: _isLoading
                      ? null
                      : () async {
                          if (_formKey.currentState!.validate()) {
                            setState(() => _isLoading = true);

                            final rawPhone = _phoneController.text;
                            final normalizedPhone = normalizePhone(rawPhone);

                            await Future.delayed(
                              const Duration(milliseconds: 800),
                            ); // simulasi API

                            setState(() => _isLoading = false);

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (_) => UiPinCode(
                            //       phone: normalizedPhone,
                            //       mode: OtpMode.forgotPassword,
                            //     ),
                            //   ),
                            // );
                          }
                        },
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      child: _isLoading
                          ? const SizedBox(
                              key: ValueKey('loading'),
                              height: 30,
                              width: 30,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ),
                            )
                          : const Text(
                              "Kirim Kode Verifikasi",
                              key: ValueKey('text'),
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
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

  String normalizePhone(String phone) {
    phone = phone.replaceAll(' ', '');

    if (phone.startsWith('08')) {
      return '62${phone.substring(1)}';
    }

    return phone;
  }

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }
}
