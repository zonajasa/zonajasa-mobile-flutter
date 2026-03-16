import 'package:flutter/material.dart';
import 'package:jasa_app/ui_otp.dart';

class RegisterCard extends StatefulWidget {
  const RegisterCard({super.key});

  @override
  State<RegisterCard> createState() => _RegisterCardState();
}

class _RegisterCardState extends State<RegisterCard> {
  bool _isPasswordVisible = false;
  final FocusNode _focusNode = FocusNode();

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
        child: Column(
          children: [
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.person, size: 25),
                prefixIconColor: WidgetStateColor.resolveWith((states) {
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
            ),
            SizedBox(height: 10),
            TextFormField(
              decoration: InputDecoration(
                prefixIcon: const Icon(
                  Icons.phone_android,
                  size: 25, // ukuran icon lebih besar
                ),
                prefixIconColor: WidgetStateColor.resolveWith((states) {
                  if (states.contains(WidgetState.focused)) {
                    return const Color(0xff0e86e4);
                  }
                  return const Color(0xff9b9bb4);
                }),
                hintText: "No. whatsApp",
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
            ),
            SizedBox(height: 10),
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
            ),
            SizedBox(height: 20),
            //tombol daftar
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
                  ).push(MaterialPageRoute(builder: (context) => UiPinCode()));
                },
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: const Text(
                    "Daftar",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
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
    );
  }
}
