import 'package:flutter/material.dart';
import 'package:jasa_app/model/layanan_jasa.dart';
import 'package:jasa_app/model/service.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:intl/intl.dart';

class Searchresultpage extends StatefulWidget {
  final String searchQuery;

  const Searchresultpage({super.key, required this.searchQuery});

  @override
  State<Searchresultpage> createState() => _SearchresultpageState();
}

class _SearchresultpageState extends State<Searchresultpage> {
  MapboxMap? mapboxMap;
  PointAnnotationManager? pointAnnotationManager;

  List<Service> filteredServices = [];

  @override
  void initState() {
    super.initState();
    _processSearch(); // ✅ hanya search di sini
  }

  // ===================== LOGIC SEARCH =====================
  void _processSearch() {
    final results = demoLayananJasa.where((layanan) {
      return layanan.name.toLowerCase().contains(
        widget.searchQuery.toLowerCase(),
      );
    }).toList();

    final services = results.map((layanan) {
      return demoServices.firstWhere(
        (service) => service.id == layanan.serviceId,
      );
    }).toList();

    final uniqueServices = {for (var s in services) s.id: s}.values.toList();

    setState(() {
      filteredServices = uniqueServices;
    });
  }

  // ===================== MAP =====================
  void _onMapCreated(MapboxMap mapboxMap) async {
    this.mapboxMap = mapboxMap;

    /// default camera dulu
    mapboxMap.setCamera(
      CameraOptions(center: Point(coordinates: Position(122.0, -3.9)), zoom: 5),
    );

    /// 🔥 buat manager
    pointAnnotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();

    /// 🔥 load custom marker (kayak DetailJasa)
    final bytes = await DefaultAssetBundle.of(
      context,
    ).load("images/location.png");

    final image = MbxImage(
      width: 640,
      height: 640,
      data: bytes.buffer.asUint8List(),
    );

    await mapboxMap.style.addStyleImage(
      "my-marker",
      1.0,
      image,
      false,
      [],
      [],
      null,
    );

    /// 🔥 tampilkan marker
    _addMarkers();
  }

  void _addMarkers() async {
    if (pointAnnotationManager == null) return;

    for (var service in filteredServices) {
      await pointAnnotationManager!.create(
        PointAnnotationOptions(
          geometry: Point(
            coordinates: Position(service.longitude, service.latitude),
          ),
          iconImage: "my-marker",
          iconSize: 0.05,
        ),
      );
    }

    /// 🔥 auto focus ke hasil pertama
    if (filteredServices.isNotEmpty) {
      final first = filteredServices.first;

      await mapboxMap!.flyTo(
        CameraOptions(
          center: Point(coordinates: Position(first.longitude, first.latitude)),
          zoom: 14,
        ),
        MapAnimationOptions(duration: 800),
      );
    }
  }

  // ===================== UI =====================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Hasil: ${widget.searchQuery}")),
      body: Stack(
        children: [
          /// MAP
          MapWidget(
            key: const ValueKey("mapWidget"),
            styleUri: MapboxStyles.MAPBOX_STREETS,
            onMapCreated: _onMapCreated,
          ),

          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: filteredServices.length,
                itemBuilder: (context, index) {
                  final service = filteredServices[index];

                  final layanan = demoLayananJasa.firstWhere(
                    (l) => l.serviceId == service.id,
                  );

                  return _buildCard(service, layanan);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCard(Service service, LayananJasa layanan) {
    return GestureDetector(
      onTap: () {
        mapboxMap?.flyTo(
          CameraOptions(
            center: Point(
              coordinates: Position(service.longitude, service.latitude),
            ),
            zoom: 15,
          ),
          MapAnimationOptions(duration: 500),
        );
      },

      child: Container(
        width: 250,
        margin: const EdgeInsets.symmetric(horizontal: 10),
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            // ignore: deprecated_member_use
            BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 8),
          ],
        ),

        child: Row(
          children: [
            /// IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                layanan.image,
                width: 70,
                height: 70,
                fit: BoxFit.cover,
              ),
            ),

            const SizedBox(width: 10),

            /// TEXT
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    service.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    layanan.name,
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp ',
                      decimalDigits: 0,
                    ).format(layanan.harga),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
