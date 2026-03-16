import 'package:flutter/material.dart';
import 'package:jasa_app/AppLoader.dart';
import 'package:jasa_app/navigationPage.dart';
import 'package:jasa_app/login_card.dart';
import 'package:jasa_app/register.dart';
import 'package:jasa_app/services/auth_service.dart';
import 'package:jasa_app/utils/session_manager.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  final TextEditingController noWaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    noWaController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? const AppLoader()
          : SingleChildScrollView(
              child: Container(
                height: MediaQuery.of(context).size.height,
                color: Color(0xffeeeefa),
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          height: MediaQuery.of(context).size.height / 2,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Color(0xff0247ae), Color(0xff0e86e4)],
                            ),
                          ),
                        ),
                        Container(
                          height: 300,
                          width: 300,
                          margin: EdgeInsets.only(left: 40, top: 45),
                          child: Image.asset('images/logo.png'),
                        ),
                        CardLogin(
                          noWaController: noWaController,
                          passwordController: passwordController,
                        ),
                      ],
                    ),
                    // Lupa kata sandi
                    Align(
                      alignment: Alignment.centerRight,
                      child: Padding(
                        padding: const EdgeInsets.only(right: 20),
                        child: TextButton(
                          onPressed: () {
                            // proses lupa password
                          },
                          child: const Text(
                            "Lupa kata sandi?",
                            style: TextStyle(color: Color(0xff0e86e4)),
                          ),
                        ),
                      ),
                    ),
                    // Tombol Login
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 10,
                      ),
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(
                            0xff0e86e4,
                          ), // warna tombol
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadiusGeometry.circular(15),
                          ),
                        ),
                        onPressed: () async {
                          if (noWaController.text.isEmpty ||
                              passwordController.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text(
                                  "Nomor WA dan password wajib diisi",
                                ),
                              ),
                            );
                            return;
                          }

                          setState(() {
                            isLoading = true;
                          });

                          try {
                            final result = await AuthService.login(
                              noWaController.text,
                              passwordController.text,
                            );

                            // pastikan status dicek sesuai backend
                            if (result["status"] == "success" ||
                                result["status"] == 200) {
                              String token = result["data"]["token"];
                              String nama =
                                  result["data"]["user"]["nama_lengkap"];

                              // Simpan token di session manager
                              await SessionManager.saveUser(token, nama);

                              if (!mounted) return;

                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Navigationpage(),
                                ),
                                (route) => false,
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    result["message"] ?? "Login gagal",
                                  ),
                                ),
                              );
                            }
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Login gagal")),
                            );
                          }

                          setState(() {
                            isLoading = false;
                          });
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: const Text(
                            "Masuk",
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // tulisan belum punya akun?
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 10,
                      ), // jarak atas 10 px
                      child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              "Belum punya akun?",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromARGB(255, 117, 117, 140),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => Register(),
                                  ),
                                );
                              },
                              child: Text(
                                "Daftar",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xff0e86e4),
                                ),
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
}
