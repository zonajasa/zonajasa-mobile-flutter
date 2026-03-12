import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

class Profileui extends StatefulWidget {
  const Profileui({super.key});

  @override
  State<Profileui> createState() => _ProfileuiState();
}

class _ProfileuiState extends State<Profileui> {
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
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
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
                  Container(
                    margin: const EdgeInsets.only(
                      top: 150,
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
                        const Text(
                          "XioFik Hasan",
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        const SizedBox(height: 5),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            FaIcon(
                              FontAwesomeIcons.locationDot,
                              size: 16,
                              color: Colors.grey,
                            ),
                            SizedBox(width: 5),
                            Text(
                              currentLocation,
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),

                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                    Text("4.5"),
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
                                      "3 Tahun",
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
                                    Text("20"),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                  // FOTO
                  Positioned(
                    top: 80,
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
              const SizedBox(height: 20),

              // MENU PROFILE
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text("Profile Setting"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.location_on_outlined),
                title: const Text("Location"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),

              ListTile(
                leading: const Icon(Icons.account_balance_wallet_outlined),
                title: const Text("Manage Withdrawals"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
