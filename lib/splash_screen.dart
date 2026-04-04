import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jasa_app/navigationPage.dart';
import 'package:jasa_app/login.dart';
import 'package:jasa_app/register.dart';
import 'package:jasa_app/utils/session_manager.dart';

class SplashS extends StatefulWidget {
  const SplashS({super.key});

  @override
  State<SplashS> createState() => _SplashSState();
}

class _SplashSState extends State<SplashS> {
  int selectedIndex = 0;
  final PageController pageController = PageController();

  bool userClicked = false;
  DateTime? lastBackPressed;
  @override
  void initState() {
    super.initState();
    checkLogin();
  }

  void checkLogin() async {
    await Future.delayed(const Duration(seconds: 2));

    if (userClicked) return;

    String? token = await SessionManager.getToken();

    if (token != null && token.isNotEmpty) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const Navigationpage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (didPop) return;

        final now = DateTime.now();

        if (lastBackPressed == null ||
            now.difference(lastBackPressed!) > const Duration(seconds: 2)) {
          lastBackPressed = now;

          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Tekan sekali lagi untuk keluar'),
              duration: Duration(seconds: 2),
            ),
          );
        } else {
          // keluar app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            children: [
              //header
              ClipPath(
                clipper: BottomCurveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.65,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.fromARGB(255, 1, 80, 200),
                        Color(0xff0e86e4),
                      ],
                    ),
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 60),
                      child: Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.diagonal3Values(1.7, 1.4, 1.0),
                        child: Image.asset(
                          "images/BannerP1.png",
                          fit: BoxFit.fitHeight,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              //tombol login / register
              Padding(
                padding: const EdgeInsets.only(
                  left: 30,
                  right: 30,
                  top: 0,
                  bottom: 10,
                ),
                child: Container(
                  height: 55,
                  decoration: BoxDecoration(
                    color: const Color(0xff0247ae),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: const Color(0xff0247ae),
                      width: 2,
                    ),
                  ),
                  child: Stack(
                    children: [
                      AnimatedAlign(
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeInOut,
                        alignment: selectedIndex == 1
                            ? Alignment.centerLeft
                            : Alignment.centerRight,
                        child: FractionallySizedBox(
                          widthFactor: 0.5,
                          child: Container(
                            margin: const EdgeInsets.all(4),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(5),
                            ),
                          ),
                        ),
                      ),

                      Row(
                        children: [
                          /// MASUK
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                userClicked = true;

                                setState(() {
                                  selectedIndex = 0;
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Login(),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  "Masuk",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: selectedIndex == 0
                                        ? Colors.white
                                        : const Color(0xff0247ae),
                                  ),
                                ),
                              ),
                            ),
                          ),

                          /// DAFTAR
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                userClicked = true;

                                setState(() {
                                  selectedIndex = 1;
                                });

                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const Register(),
                                  ),
                                );
                              },
                              child: Center(
                                child: Text(
                                  "Daftar",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: selectedIndex == 1
                                        ? Colors.white
                                        : const Color(0xff0247ae),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              // konten data
              Column(
                children: [
                  const SizedBox(height: 5),

                  const Text(
                    "Layanan Jasa Terbaik di Sekitar Anda",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xff0247ae),
                    ),
                  ),

                  const SizedBox(height: 5),

                  const Divider(thickness: 1, indent: 30, endIndent: 30),

                  const SizedBox(height: 2),

                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                    child: IntrinsicHeight(
                      child: Row(
                        children: const [
                          Expanded(
                            child: ServiceImageItem(
                              imagePath: "images/BlueWrench.png",
                              label: "Tukang",
                            ),
                          ),

                          VerticalDivider(thickness: 1, width: 20),

                          Expanded(
                            child: ServiceImageItem(
                              imagePath: "images/YellowLightning.png",
                              label: "Listrik",
                            ),
                          ),

                          VerticalDivider(thickness: 1, width: 20),

                          Expanded(
                            child: ServiceImageItem(
                              imagePath: "images/BlueCircle.png",
                              label: "Kebersihan",
                            ),
                          ),

                          VerticalDivider(thickness: 1, width: 20),

                          Expanded(
                            child: ServiceImageItem(
                              imagePath: "images/BlueCar.png",
                              label: "Servis",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 2),

                  const Divider(thickness: 1, indent: 30, endIndent: 30),

                  Transform.translate(
                    offset: const Offset(0, -10),
                    child: TextButton(
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Navigationpage(),
                          ),
                          (route) => false,
                        );
                      },
                      child: const Text(
                        "Lewati",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 94, 93, 93),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              //tombol
            ],
          ),
        ),
      ),
    );
  }
}

class BottomCurveClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    Path path = Path();

    path.lineTo(0, size.height - 80);

    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 80,
    );

    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class ServiceImageItem extends StatelessWidget {
  final String imagePath;
  final String label;

  const ServiceImageItem({
    super.key,
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.contain),
        const SizedBox(height: 3),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xff0247ae),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
