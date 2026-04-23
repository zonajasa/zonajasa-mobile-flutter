// ignore_for_file: dead_code

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';

class MapPickerScreen extends StatefulWidget {
  const MapPickerScreen({super.key});

  @override
  State<MapPickerScreen> createState() => _MapPickerScreenState();
}

class _MapPickerScreenState extends State<MapPickerScreen> {
  final MapController _mapController = MapController();

  LatLng selectedLocation = LatLng(-3.9985, 122.5149);
  String address = "Geser peta untuk memilih lokasi";
  bool isLoadingLocation = true;

  Future<String> getAddressFromLatLng(LatLng point) async {
    final token = dotenv.env['MAPBOX_TOKEN'];

    final url =
        "https://api.mapbox.com/geocoding/v5/mapbox.places/"
        "${point.longitude},${point.latitude}.json"
        "?language=id&access_token=$token";

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      final placeName = data["features"][0]["place_name"];
      if (!mounted) return "Lokasi tidak ditemukan";
      setState(() {
        address = placeName;
      });

      return placeName;
    }

    return "Lokasi tidak ditemukan";
  }

  @override
  void initState() {
    super.initState();
    _initMap();
  }

  Future<void> _initMap() async {
    try {
      final position = await Geolocator.getCurrentPosition();

      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      final place = placemarks.first;
      final city = place.locality ?? place.subAdministrativeArea ?? "Unknown";

      print("KOTA USER: $city");
      if (!mounted) return;
      final cityCenter = LatLng(position.latitude, position.longitude);

      setState(() {
        selectedLocation = cityCenter;
        isLoadingLocation = false;
      });

      _mapController.move(cityCenter, 13);
    } catch (e) {
      print("ERROR INIT MAP: $e");

      final fallback = LatLng(-3.9985, 122.5149);
      if (!mounted) return;
      setState(() {
        selectedLocation = fallback;
        isLoadingLocation = false;
      });

      _mapController.move(fallback, 13);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pilih Lokasi")),
      body: Stack(
        children: [
          /// MAP
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: selectedLocation,
              initialZoom: 13,
              minZoom: 12,
              maxZoom: 18,

              onTap: (tapPosition, point) {
                setState(() {
                  selectedLocation = point;
                });
              },

              onPositionChanged: (position, hasGesture) {
                if (hasGesture) {
                  final center = position.center;

                  // ignore: unnecessary_null_comparison
                  if (center == null) return;

                  setState(() {
                    selectedLocation = center;
                  });
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://api.mapbox.com/styles/v1/mapbox/streets-v12/tiles/{z}/{x}/{y}?access_token=${dotenv.env['MAPBOX_TOKEN']}",
                userAgentPackageName: 'com.example.app',
              ),

              MarkerLayer(
                markers: [
                  Marker(
                    point: selectedLocation,
                    width: 40,
                    height: 40,
                    child: const Icon(
                      Icons.location_on,
                      size: 40,
                      color: Colors.red,
                    ),
                  ),
                ],
              ),
            ],
          ),

          /// LOADING
          if (isLoadingLocation)
            const Center(child: CircularProgressIndicator()),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(address),
              const SizedBox(height: 10),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final resultAddress = await getAddressFromLatLng(
                      selectedLocation,
                    );
                    if (!mounted) return;
                    Navigator.pop(context, {
                      "address": resultAddress,
                      "lat": selectedLocation.latitude,
                      "lng": selectedLocation.longitude,
                    });
                  },
                  child: const Text("Gunakan Lokasi Ini"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
