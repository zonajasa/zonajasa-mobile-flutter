import 'package:flutter/cupertino.dart';
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
  bool switchValue = false;

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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Leon S. Kurniawan",
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
                          "CV Harapan Bangsa",
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
              const SizedBox(height: 15),

              Container(
                margin: const EdgeInsets.only(left: 20, right: 20),
                padding: const EdgeInsets.only(bottom: 10, top: 10),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: [
                                FaIcon(
                                  FontAwesomeIcons.repeat,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 10),
                                Text(
                                  "Ubah Menjadi Pemilik jasa",
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ],
                        ),

                        Column(
                          children: [
                            CupertinoSwitch(
                              value: switchValue,
                              activeTrackColor: CupertinoColors.activeBlue,
                              onChanged: (bool value) {
                                setState(() {
                                  switchValue = value;
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // MENU PROFILE
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Pengaturan Akun",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              const SizedBox(height: 10),

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
                      subtitle: const Text("Ubah foto, nama, nomor HP, dsb"),
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
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
                      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                      onTap: () {},
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
