import 'package:flutter/material.dart';
import 'package:jasa_app/AppLoader.dart';
import 'package:jasa_app/navigationPage.dart';
import 'package:jasa_app/login_card.dart';
import 'package:jasa_app/register.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
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
                        // CardLogin(),
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
                          setState(() {
                            isLoading = true;
                          });

                          await Future.delayed(const Duration(seconds: 3));

                          if (!mounted) return;

                          Navigator.of(context).pushReplacement(
                            MaterialPageRoute(
                              builder: (context) => Navigationpage(),
                            ),
                          );
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
                    // login with sosial medoaia
                    Align(
                      alignment: Alignment.center,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 50,
                          vertical: 10,
                        ),
                        child: Row(
                          children: [
                            const Expanded(
                              child: Divider(
                                color: Colors.grey, // warna garis
                                thickness: 0.5, // ketebalan garis
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                              ),
                              child: const Text(
                                "Atau lanjutkan dengan",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xff9b9bb4),
                                ),
                              ),
                            ),
                            const Expanded(
                              child: Divider(
                                color: Colors.grey, // warna garis
                                thickness: 0.5, // ketebalan garis
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // tombol sosial media
                    SizedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                            ),
                            onPressed: () {},
                            icon: Image.asset(
                              'images/google.png',
                              width: 28,
                              height: 28,
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                            ),
                            onPressed: () {},
                            icon: Image.asset(
                              'images/fb.png',
                              width: 27,
                              height: 27,
                            ),
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            style: IconButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.blue,
                            ),
                            onPressed: () {},
                            icon: Image.asset(
                              'images/apple.png',
                              width: 28,
                              height: 28,
                            ),
                          ),
                        ],
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
