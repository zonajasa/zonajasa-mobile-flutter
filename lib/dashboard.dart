import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  bool _isLoading = true;
  int _selectedIndex = 0;
  BottomNavigationBarType _bottomNavType = BottomNavigationBarType.fixed;

  @override
  void initState() {
    super.initState();
    _fakeLoading();
  }

  void _fakeLoading() async {
    await Future.delayed(const Duration(seconds: 2));
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading ? _buildSkeleton() : _buildHome(),
      //tombol navigasi bawah
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xff0e86e4),
        unselectedItemColor: const Color(0xff757575),
        type: _bottomNavType,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
            icon: FaIcon(FontAwesomeIcons.house),
            activeIcon: FaIcon(FontAwesomeIcons.solidHouse),
            label: 'Beranda',
          ),
          BottomNavigationBarItem(
            // ignore: deprecated_member_use
            icon: FaIcon(FontAwesomeIcons.circleUp),
            // ignore: deprecated_member_use
            activeIcon: FaIcon(FontAwesomeIcons.solidCircleUp),
            label: 'Explore',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.commentDots),
            activeIcon: FaIcon(FontAwesomeIcons.solidCommentDots),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: FaIcon(FontAwesomeIcons.user),
            activeIcon: FaIcon(FontAwesomeIcons.solidUser),
            label: 'Akun',
          ),
        ],
      ),
    );
  }
}

//////////////////////////// DASHBOARD ////////////////////////////
class _buildHome extends StatefulWidget {
  const _buildHome({super.key});

  @override
  State<_buildHome> createState() => _buildHomeState();
}

class _buildHomeState extends State<_buildHome> {
  String currentLocation = "Mendeteksi lokasi...";

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
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

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];

    setState(() {
      currentLocation =
          "${place.subLocality ?? place.locality}, ${place.locality}";
    });
  }

  bool isNotifPressed = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      color: const Color(0xffeeeefa),
      child: Stack(
        children: [
          //layout header
          Container(
            height: MediaQuery.of(context).size.height * 0.50,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: Image.asset("images/home.png", fit: BoxFit.cover),
                  ),
                  Positioned(
                    bottom: -10,
                    left: -50,
                    child: Image.asset("images/pohon.png", width: 250),
                  ),
                  Positioned(
                    bottom: -130,
                    right: -15,
                    child: Image.asset("images/orang1.png", width: 150),
                  ),
                  Positioned(
                    bottom: -100,
                    right: 40,
                    child: Image.asset("images/orang2.png", width: 160),
                  ),
                ],
              ),
            ),
          ),
          //pencarian
          Positioned(
            top: 55,
            left: 20,
            right: 65,
            child: SearchAnchor(
              builder: (context, controller) {
                return SearchBar(
                  controller: controller,
                  backgroundColor: const WidgetStatePropertyAll(Colors.white),
                  elevation: const WidgetStatePropertyAll(0),
                  constraints: const BoxConstraints(minHeight: 45),

                  shape: WidgetStatePropertyAll(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        topRight: Radius.circular(28),
                        bottomRight: Radius.circular(28),
                      ),
                    ),
                  ),
                  padding: const WidgetStatePropertyAll(
                    EdgeInsets.symmetric(horizontal: 12),
                  ),
                  leading: const FaIcon(
                    FontAwesomeIcons.magnifyingGlass,
                    color: Colors.grey,
                    size: 20,
                  ),
                  hintText: "Cari layanan di sini...",
                  trailing: [
                    IconButton(
                      icon: const FaIcon(
                        FontAwesomeIcons.circleArrowDown,
                        size: 26,
                        color: Color(0xff0e86e4),
                      ),
                      onPressed: () {
                        print("Menu kategori ditekan");
                      },
                    ),
                    if (controller.text.isNotEmpty)
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () {
                          controller.clear();
                          setState(() {});
                        },
                      ),
                  ],
                  onChanged: (_) {
                    setState(() {});
                  },
                );
              },
              suggestionsBuilder: (context, controller) {
                return [];
              },
            ),
          ),
          // icon notifikasi
          Positioned(
            top: 60,
            right: 18,
            child: GestureDetector(
              onTapDown: (_) {
                setState(() {
                  isNotifPressed = true;
                });
              },
              onTapUp: (_) {
                setState(() {
                  isNotifPressed = false;
                });
                print("Notif ditekan");
              },
              onTapCancel: () {
                setState(() {
                  isNotifPressed = false;
                });
              },
              child: AnimatedScale(
                scale: isNotifPressed ? 1.2 : 1.0,
                duration: const Duration(milliseconds: 100),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.solidBell,
                      size: 39,
                      color: Color(0xff0e86e4),
                    ),

                    // Icon utama
                    FaIcon(
                      FontAwesomeIcons.solidBell,
                      size: 34,
                      color: isNotifPressed ? Color(0xff0e86e4) : Colors.white,
                    ),
                  ],
                ),
              ),
            ),
          ),
          // konten welcome
          Positioned(
            top: 125,
            left: 17,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Halo, Miftah!",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 15),
                Text(
                  "Butuh bantuan atau jasa?",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Temukan layanan terbaik",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Disekitar anda",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          // lokasi saat ini
          Positioned(
            top: 120,
            right: 10,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                borderRadius: BorderRadius.circular(20),
                gradient: const LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0xffd9ecff), Color(0xffcce5f8)],
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FaIcon(
                    FontAwesomeIcons.locationDot,
                    size: 18,
                    color: Color(0xff0e86e4),
                  ),
                  SizedBox(width: 6),
                  Text(
                    currentLocation,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),
          ),
          //menu layanan
          Positioned(
            top: MediaQuery.of(context).size.height * 0.46,
            left: 15,
            right: 15,
            child: Container(
              height: 90,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    // ignore: deprecated_member_use
                    color: Colors.black.withOpacity(0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 6),
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

//////////// LOADING  /////////
class _buildSkeleton extends StatelessWidget {
  const _buildSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: LoadingAnimationWidget.halfTriangleDot(
        color: Color(0xff0e86e4),
        size: 100,
      ),
    );
  }
}
