import 'package:flutter/material.dart';
import 'package:jasa_app/model/category.dart';
import 'package:jasa_app/pages/pemilik_jasa/Step2Form.dart';

class Step3Screen extends StatelessWidget {
  final String namaUsaha;
  final String deskripsi;
  final String lokasi;
  final double latitude;
  final double longitude;
  final Map<String, List<LayananItem>> layananPerCategory;

  const Step3Screen({
    super.key,
    required this.namaUsaha,
    required this.deskripsi,
    required this.lokasi,
    required this.latitude,
    required this.longitude,
    required this.layananPerCategory,
  });

  @override
  Widget build(BuildContext context) {
    print("STEP3 DATA:");
    print(layananPerCategory);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Cek Kembali Data Jasa Anda",
          style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
        ),
        SizedBox(height: 20),
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              _rowItem("Nama Jasa", namaUsaha),
              _divider(),

              _rowItem("Deskripsi Jasa", deskripsi),
              _divider(),

              _buildLokasiItem(lokasi, latitude, longitude),
              _divider(),

              _buildLayananItem(layananPerCategory),
              _divider(),

              _rowItem("Hari Operasional", ""),
              _divider(),

              _rowItem("Jam Operasional", ""),
              _divider(),

              _rowItem("Tarif Layanan", ""),
              _divider(),

              _rowItem("Galeri", ""),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: false,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (v) {},
            ),

            Expanded(
              child: Text(
                "Dengan ini saya setuju untuk semua ketentuan yang berlaku",
                style: TextStyle(fontSize: 12),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildLayananItem(Map<String, List<LayananItem>> layananPerCategory) {
  return Padding(
    padding: const EdgeInsets.all(14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 130, child: Text("Layanan Jasa")),
        const Text(": "),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: layananPerCategory.entries.map((entry) {
              final categoryId = entry.key;
              final layananList = entry.value;

              final category = demoCategories.firstWhere(
                (c) => c.id == categoryId,
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  /// NAMA KATEGORI
                  Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  /// CHIP LAYANAN
                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: layananList
                        .map(
                          (item) => Chip(
                            label: Text(
                              item.nameController.text.isEmpty
                                  ? "(kosong)"
                                  : item.nameController.text,
                            ),
                          ),
                        )
                        .toList(),
                  ),

                  const SizedBox(height: 10),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

Widget _buildLokasiItem(String lokasi, double lat, double lng) {
  return Padding(
    padding: const EdgeInsets.all(14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 130, child: Text("Lokasi Jasa")),
        const Text(": "),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// alamat utama
              Text(lokasi.isEmpty ? "-" : lokasi),

              const SizedBox(height: 6),

              /// koordinat
              Text(
                "Lat: ${lat.toStringAsFixed(5)}, Lng: ${lng.toStringAsFixed(5)}",
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _divider() {
  return Divider(height: 1, color: Colors.grey.shade400);
}

Widget _rowItem(String title, String value) {
  return Padding(
    padding: const EdgeInsets.all(14),
    child: Row(
      children: [
        SizedBox(width: 130, child: Text(title)),
        const Text(": "),
        Expanded(
          child: Text(value, maxLines: 4, overflow: TextOverflow.ellipsis),
        ),
      ],
    ),
  );
}
