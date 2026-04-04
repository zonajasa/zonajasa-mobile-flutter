import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jasa_app/services/auth_service.dart';
import 'package:jasa_app/ui_otp.dart';

class RegisterCard extends StatefulWidget {
  const RegisterCard({super.key});

  @override
  State<RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  bool _isLoading = false;
  bool _isPasswordVisible = false;
  final FocusNode _focusNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
                controller: _nameController,
                keyboardType: TextInputType.name,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.person, size: 25),
                  prefixIconColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.error)) {
                      return const Color.fromARGB(255, 167, 41, 32);
                    }
                    if (states.contains(WidgetState.focused)) {
                      return const Color(0xff0e86e4);
                    }
                    return const Color(0xff9b9bb4);
                  }),
                  hintText: "Nama Lengkap",
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
                  if (value == null || value.trim().isEmpty) {
                    return 'Masukkan nama lengkap';
                  }

                  final name = value.trim();

                  // minimal 3 karakter
                  if (name.length < 10) {
                    return 'Nama terlalu pendek';
                  }

                  // hanya huruf & spasi
                  if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(name)) {
                    return 'Nama hanya boleh huruf';
                  }

                  return null;
                },
              ),
              SizedBox(height: 10),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.phone_android,
                    size: 25, // ukuran icon lebih besar
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.error)) {
                      return const Color.fromARGB(255, 167, 41, 32);
                    }
                    if (states.contains(WidgetState.focused)) {
                      return const Color(0xff0e86e4);
                    }
                    return const Color(0xff9b9bb4);
                  }),
                  hintText: "Nomor whatsApp",
                  hintStyle: const TextStyle(
                    fontSize: 18, // teks hint lebih besar
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
              SizedBox(height: 10),
              TextFormField(
                controller: _passwordController,
                focusNode: _focusNode,
                obscureText: !_isPasswordVisible,
                decoration: InputDecoration(
                  prefixIcon: const Icon(
                    Icons.lock,
                    size: 25, // ukuran icon lebih besar
                  ),
                  prefixIconColor: WidgetStateColor.resolveWith((states) {
                    if (states.contains(WidgetState.error)) {
                      return const Color.fromARGB(255, 167, 41, 32);
                    }
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
                  hintText: "Password",
                  hintStyle: const TextStyle(
                    fontSize: 18, // teks hint lebih besar
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
                  if (value == null || value.isEmpty) {
                    return 'Masukkan password';
                  }

                  if (value.length < 8) {
                    return 'Minimal 8 karakter';
                  }

                  if (!RegExp(r'[A-Z]').hasMatch(value)) {
                    return 'Harus ada huruf besar';
                  }

                  if (!RegExp(r'[a-z]').hasMatch(value)) {
                    return 'Harus ada huruf kecil';
                  }

                  if (!RegExp(r'[0-9]').hasMatch(value)) {
                    return 'Harus ada angka';
                  }

                  if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                    return 'Harus ada karakter spesial';
                  }

                  return null;
                },
              ),
              SizedBox(height: 20),
              //tombol daftar
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
                            try {
                              if (!mounted) return;
                              setState(() => _isLoading = true);

                              final rawPhone = _phoneController.text;
                              final normalizedPhone = normalizePhone(rawPhone);

                              final name = _nameController.text;
                              final password = _passwordController.text;

                              final result = await AuthService.register(
                                nama: name,
                                noWhatsapp: normalizedPhone,
                                password: password,
                              );

                              final token = result['data']['wa_encrypted'];

                              if (!mounted) return;

                              setState(() => _isLoading = false);

                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => UiPinCode(
                                    phone: normalizedPhone,
                                    mode: OtpMode.register,
                                    token: token,
                                  ),
                                ),
                              );
                            } catch (e) {
                              if (!mounted) return;

                              setState(() => _isLoading = false);

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    e.toString().replaceAll("Exception: ", ""),
                                  ),
                                ),
                              );
                            }
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
                              "Daftar",
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
              //SYARAT DAN KETENTUAN
              Padding(
                padding: const EdgeInsets.only(top: 15, bottom: 10),
                child: Center(
                  child: Wrap(
                    alignment: WrapAlignment.center,
                    children: [
                      const Text(
                        "Dengan mendaftar kamu menyetujui ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 117, 117, 140),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // buka halaman Syarat & Ketentuan
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Syarat & Ketentuan",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0e86e4),
                          ),
                        ),
                      ),
                      const Text(
                        " dan ",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 117, 117, 140),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          // buka halaman Kebijakan Privasi
                        },
                        style: TextButton.styleFrom(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text(
                          "Kebijakan Privasi",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xff0e86e4),
                          ),
                        ),
                      ),
                      const Text(
                        " yang berlaku",
                        style: TextStyle(
                          fontSize: 16,
                          color: Color.fromARGB(255, 117, 117, 140),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
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
    _nameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
