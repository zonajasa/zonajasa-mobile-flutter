import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jasa_app/core/theme/DottedLine.dart';
import 'package:jasa_app/login.dart';
import 'package:jasa_app/pages/pemilik_jasa/profil_datajasa.dart';
import 'package:jasa_app/services/user_service.dart';
import 'package:jasa_app/splash_screen.dart';
import 'package:jasa_app/utils/session_manager.dart';

class Profileui extends StatefulWidget {
  const Profileui({super.key});

  @override
  State<Profileui> createState() => _ProfileuiState();
}

class _ProfileuiState extends State<Profileui> {
  final ScrollController _scrollController = ScrollController();
  double scrollOffset = 0;
  String currentLocation = "Mendeteksi lokasi...";
  bool switchValue = false;
  bool isPemilikJasa = false;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      setState(() {
        scrollOffset = _scrollController.offset;
      });
    });

    _getLocation();
    getProfile();
    checkLogin();
  }

  // tambahkan state untuk profile
  String namaLengkap = "";
  String email = "";
  String noWhatsapp = "";

  Future<void> getProfile() async {
    final result = await UserService.getProfile();

    if (!mounted) return;

    if (result == null) {
      debugPrint("Gagal load profile");
      return;
    }

    final data = result["data"];
    if (data == null) return;

    setState(() {
      namaLengkap = data["full_name"] ?? "";
      noWhatsapp = data["no_whatsapp"] ?? "";
      isPemilikJasa = data["role"] == "pemilik_jasa";
      switchValue = isPemilikJasa;
    });
  }

  Future<void> checkLogin() async {
    String? token = await SessionManager.getToken();

    if (!mounted) return;

    setState(() {
      isLogin = token != null;
    });
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (!mounted) return;
      setState(() {
        currentLocation = "GPS tidak aktif";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        currentLocation = "Izin lokasi ditolak";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );

    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (!mounted) return;

      if (placemarks.isEmpty) {
        setState(() {
          currentLocation = "Lokasi tidak ditemukan";
        });
        return;
      }

      final place = placemarks.first;

      setState(() {
        currentLocation =
            "${place.subLocality ?? place.locality ?? 'Unknown'}, ${place.locality ?? ''}";
      });
    } catch (e) {
      debugPrint("Geocoding error: $e");

      if (!mounted) return;

      setState(() {
        currentLocation = "Lokasi tidak ditemukan";
      });
    }
  }

  void showConfirmPemilikJasa() {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const FaIcon(
                  FontAwesomeIcons.store,
                  size: 40,
                  color: Color(0xff0e86e4),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Menjadi Pemilik Jasa?",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Apakah Anda yakin ingin menjadi pemilik jasa?",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 25),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          Navigator.pop(dialogContext);
                        },
                        child: const Text("Tidak"),
                      ),
                    ),

                    const SizedBox(width: 10),

                    Expanded(
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff0e86e4),
                        ),
                        onPressed: () async {
                          Navigator.pop(dialogContext);
                          showLoadingDialog();

                          await Future.delayed(const Duration(seconds: 2));

                          if (!mounted) return;

                          if (Navigator.canPop(context)) {
                            Navigator.pop(context);
                          }

                          if (!mounted) return;

                          setState(() {
                            switchValue = true;
                            isPemilikJasa = true;
                          });

                          showIncompleteProfileDialog();
                        },
                        child: const Text(
                          "Ya",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          elevation: 10,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: const SizedBox(
            width: 150,
            height: 150,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 45,
                  height: 45,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Color(0xff0e86e4),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Processing...",
                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void showIncompleteProfileDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.orange.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: Colors.orange,
                    size: 40,
                  ),
                ),

                const SizedBox(height: 15),

                const Text(
                  "Profil Belum Lengkap",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 10),

                const Text(
                  "Lengkapi profil usaha kamu dulu agar bisa menerima order.",
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.black54),
                ),

                const SizedBox(height: 25),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff0e86e4),
                    ),
                    onPressed: () {
                      Navigator.pop(context);

                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const ProfilDatajasa(),
                        ),
                      );
                    },
                    child: const Text(
                      "Lengkapi Sekarang",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  bool isNotifPressed = false;
  bool isLogin = false;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            controller: _scrollController,
            child: Container(
              color: Color(0xffeeeefa),
              child: Column(
                children: [
                  Stack(
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.none,
                    children: [
                      // BACKGROUND GRADIENT
                      Container(
                        height: MediaQuery.of(context).size.height / 2.4,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              const Color(0xff0247ae),
                              const Color(0xff0e86e4),
                              // ignore: deprecated_member_use
                              const Color(0xff0e86e4).withOpacity(0.0),
                            ],
                            stops: const [0.0, 0.6, 1.0],
                          ),
                        ),
                      ),
                      // DATA PROFILE
                      if (isPemilikJasa) ...[
                        Container(
                          margin: EdgeInsets.only(
                            top: (screenHeight * 0.22).clamp(140, 220),
                            left: 20,
                            right: 20,
                          ),
                          padding: const EdgeInsets.only(bottom: 10, top: 60),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                // ignore: deprecated_member_use
                                Colors.white.withOpacity(0.6),
                                Colors.white,
                                Colors.white,
                              ],
                              stops: [0.0, 0.60, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    namaLengkap.isNotEmpty
                                        ? namaLengkap
                                        : "Nama belum tersedia",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(width: 5),
                                  FaIcon(
                                    FontAwesomeIcons.buildingCircleCheck,
                                    size: 15,
                                    color: Colors.blue,
                                  ),
                                ],
                              ),
                              Text(
                                "CV Lorem Impsum",
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                              const SizedBox(height: 5),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.locationDot,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    currentLocation,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 15),
                              DottedLine(),
                              const SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: const [
                                  Column(
                                    children: [
                                      Text("AVG rating"),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.solidStar,
                                            size: 15,
                                            color: Colors.orange,
                                          ),
                                          SizedBox(width: 5),
                                          Text("0.0"),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      Text("Pengalaman"),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.award,
                                            size: 15,
                                            color: Colors.orange,
                                          ),
                                          SizedBox(width: 5),
                                          Text(
                                            "0 Tahun",
                                            style: TextStyle(
                                              color: Colors.blue,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),

                                  Column(
                                    children: [
                                      Text("Total Jasa"),
                                      Row(
                                        children: [
                                          FaIcon(
                                            FontAwesomeIcons.briefcase,
                                            size: 15,
                                            color: Colors.green,
                                          ),
                                          SizedBox(width: 5),
                                          Text("0"),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              const SizedBox(height: 10),
                            ],
                          ),
                        ),
                      ] else ...[
                        Container(
                          margin: EdgeInsets.only(
                            top: (screenHeight * 0.22).clamp(140, 220),
                            left: 20,
                            right: 20,
                          ),
                          padding: const EdgeInsets.only(bottom: 10, top: 60),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                // ignore: deprecated_member_use
                                Colors.white.withOpacity(0.6),
                                Colors.white,
                                Colors.white,
                              ],
                              stops: [0.0, 0.60, 1.0],
                            ),
                            borderRadius: BorderRadius.circular(15),
                          ),

                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    namaLengkap.isNotEmpty
                                        ? namaLengkap
                                        : "Nama belum tersedia",
                                    style: TextStyle(
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),

                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  FaIcon(
                                    FontAwesomeIcons.locationDot,
                                    size: 15,
                                    color: Colors.grey,
                                  ),
                                  SizedBox(width: 5),
                                  Text(
                                    currentLocation,
                                    style: TextStyle(color: Colors.grey),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),
                              DottedLine(),
                              const SizedBox(height: 10),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Aktifkan mode pemilik jasa untuk mulai \nmenerima orderan",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      fontSize: 15,
                                      color: Colors.grey.shade600,
                                    ),
                                  ),
                                ],
                              ),

                              const SizedBox(height: 5),
                            ],
                          ),
                        ),
                      ],
                      // FOTO
                      Positioned(
                        top: (screenHeight * 0.13).clamp(80, 140),
                        child: Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 5),
                          ),
                          child: const CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage("images/orang.png"),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  //TOMBOL SWITCH
                  Container(
                    margin: const EdgeInsets.only(left: 20, right: 20),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 8,
                          offset: Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  isPemilikJasa
                                      ? "Status Jasa"
                                      : "Jadi Pemilik Jasa",
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                ),
                                Text(
                                  isPemilikJasa
                                      ? (switchValue
                                            ? "Saat ini jasa Anda aktif"
                                            : "Saat ini jasa Anda tidak aktif")
                                      : "Aktifkan untuk mulai jual jasa",
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: isPemilikJasa
                                        ? (switchValue
                                              ? Colors.green
                                              : Colors.red)
                                        : Colors.grey,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        CupertinoSwitch(
                          value: switchValue,
                          activeTrackColor: CupertinoColors.activeBlue,
                          onChanged: (bool value) {
                            if (!isPemilikJasa) {
                              // onboarding
                              if (value == true) {
                                showConfirmPemilikJasa();
                              }
                            } else {
                              // toggle jasa ON/OFF
                              setState(() {
                                switchValue = value;
                              });

                              // TODO: nanti connect API
                            }
                          },
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 10),

                  // MENU PROFILE
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Pengaturan Akun",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),

                  //DATA MENU
                  Container(
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(15),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black12,
                          blurRadius: 10,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        if (isPemilikJasa) ...[
                          const SizedBox(height: 5),

                          // MY DASHBOARD
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.dashboard,
                                color: Colors.orange,
                              ),
                            ),
                            title: const Text(
                              "My Dashboard",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text("Pantau performa jasa Anda"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {},
                          ),

                          const Divider(height: 1),

                          // ORDER MASUK
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.shopping_bag,
                                color: Colors.green,
                              ),
                            ),
                            title: const Text(
                              "Order Masuk",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text("Lihat pesanan pelanggan"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {},
                          ),

                          const Divider(height: 1),

                          // KELOLA JASA
                          ListTile(
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.blue.shade100,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: const Icon(
                                Icons.build,
                                color: Colors.blue,
                              ),
                            ),
                            title: const Text(
                              "Kelola Jasa",
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            subtitle: const Text("Tambah & edit layanan"),
                            trailing: const Icon(
                              Icons.arrow_forward_ios,
                              size: 16,
                            ),
                            onTap: () {},
                          ),

                          const Divider(height: 1),
                        ],
                        // EDIT PROFILE
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const FaIcon(
                              FontAwesomeIcons.solidUser,
                              color: Colors.white,
                            ),
                          ),
                          title: const Text(
                            "Edit Profil",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text(
                            "Ubah foto, nama, nomor HP, dsb",
                          ),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {},
                        ),

                        const Divider(height: 1),

                        // NOTIFIKASI
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.green.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(
                              Icons.notifications,
                              color: Colors.green,
                            ),
                          ),
                          title: const Text(
                            "Notifikasi",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text("Pengaturan push notifikasi"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {},
                        ),

                        const Divider(height: 1),

                        // KEAMANAN
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: const Icon(Icons.shield, color: Colors.blue),
                          ),
                          title: const Text(
                            "Keamanan",
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: const Text("Ubah password akun"),
                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),
                          onTap: () {},
                        ),
                        const Divider(height: 1),
                        // LOGOUT
                        ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(10),
                            child: FaIcon(
                              isLogin
                                  ? FontAwesomeIcons.arrowRightFromBracket
                                  : FontAwesomeIcons.rightToBracket,
                              color: isLogin ? Colors.red : Colors.green,
                            ),
                          ),

                          title: Text(
                            isLogin ? "Logout" : "Login",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),

                          trailing: const Icon(
                            Icons.arrow_forward_ios,
                            size: 16,
                          ),

                          onTap: () async {
                            if (isLogin) {
                              final bool? confirm = await showDialog<bool>(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: const Text("Logout"),
                                  content: const Text(
                                    "Yakin mau keluar dari akun?",
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, false),
                                      child: const Text("Batal"),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: const Text(
                                        "Logout",
                                        style: TextStyle(color: Colors.red),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                              if (confirm ?? false) {
                                await SessionManager.logout();

                                if (!context.mounted) return;

                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => SplashS(),
                                  ),
                                  (route) => false,
                                );
                              }
                            } else {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => Login(),
                                ),
                              );
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 30),
                ],
              ),
            ),
          ),

          // APP BAR FAKE
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Builder(
              builder: (context) {
                bool isScrolled = scrollOffset > 10;

                return AnimatedContainer(
                  duration: const Duration(milliseconds: 200),

                  height: kToolbarHeight + MediaQuery.of(context).padding.top,

                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top,
                    left: 20,
                    right: 20,
                  ),

                  decoration: BoxDecoration(
                    color: isScrolled
                        ? const Color(0xfff5f5f7)
                        : Colors.transparent,

                    boxShadow: isScrolled
                        ? [
                            BoxShadow(
                              // ignore: deprecated_member_use
                              color: Colors.black.withOpacity(0.08),
                              blurRadius: 8,
                            ),
                          ]
                        : [],
                  ),

                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Text(
                        "Profile",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isScrolled ? Colors.black : Colors.white,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          //end
        ],
      ),
    );
  }
}
