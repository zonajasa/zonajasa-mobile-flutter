import 'package:flutter/material.dart';
import 'package:jasa_app/ForgotAuth/ForgotPasswordPage.dart';
import 'package:jasa_app/navigationPage.dart';
import 'package:jasa_app/login_card.dart';
import 'package:jasa_app/register.dart';
import 'package:jasa_app/services/auth_service.dart';
import 'package:jasa_app/utils/session_manager.dart';
import 'package:jasa_app/utils/snackbar_helper.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isButtonLoading = false;
  final TextEditingController noWaController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  Map<String, String> fieldErrors = {};
  @override
  void dispose() {
    noWaController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
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
                      Form(
                        key: _formKey,
                        child: CardLogin(
                          noWaController: noWaController,
                          passwordController: passwordController,
                          fieldErrors: fieldErrors,
                          onClearError: (field) {
                            setState(() {
                              fieldErrors.remove(field);
                            });
                          },
                        ),
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
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => Forgotpasswordpage(),
                            ),
                          );
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
                      onPressed: isButtonLoading
                          ? null
                          : () async {
                              setState(() {
                                fieldErrors.clear();
                              });

                              if (!_formKey.currentState!.validate()) return;

                              final start = DateTime.now();

                              setState(() {
                                isButtonLoading = true;
                              });

                              try {
                                final result = await AuthService.login(
                                  noWaController.text,
                                  passwordController.text,
                                );

                                final diff = DateTime.now().difference(start);

                                if (diff.inMilliseconds < 500) {
                                  await Future.delayed(
                                    Duration(
                                      milliseconds: 500 - diff.inMilliseconds,
                                    ),
                                  );
                                }

                                if (result["status"] == 200) {
                                  if (!mounted) return;

                                  String token = result["data"]["token"];
                                  String nama =
                                      result["data"]["user"]["full_name"];

                                  await SessionManager.saveUser(token, nama);

                                  if (!mounted) return;

                                  setState(() => isButtonLoading = false);

                                  Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => Navigationpage(),
                                    ),
                                    (route) => false,
                                  );
                                } else {
                                  if (result["errors"] != null) {
                                    Map<String, String> errors = {};

                                    for (var e in result["errors"]) {
                                      errors[e["field"]] = e["message"];
                                    }

                                    if (!mounted) return;

                                    setState(() {
                                      fieldErrors = errors;
                                      isButtonLoading = false;
                                    });

                                    _formKey.currentState!.validate();
                                  } else {
                                    if (!mounted) return;

                                    setState(() => isButtonLoading = false);

                                    AppSnackbar.showError(
                                      context,
                                      result["message"] ?? "Login gagal",
                                    );
                                  }
                                }
                              } catch (e) {
                                if (!mounted) return;

                                setState(() => isButtonLoading = false);

                                AppSnackbar.showError(
                                  context,
                                  "Login gagal, coba lagi ya",
                                );
                              }
                            },

                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: isButtonLoading
                            ? const SizedBox(
                                height: 30,
                                width: 30,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Text(
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
                    padding: const EdgeInsets.only(top: 10), // jarak atas 10 px
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
        ],
      ),
    );
  }
}
