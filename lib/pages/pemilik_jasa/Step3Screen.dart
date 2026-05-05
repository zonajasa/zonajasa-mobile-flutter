import 'package:flutter/material.dart';
import 'package:jasa_app/model/category.dart';
import 'package:jasa_app/pages/pemilik_jasa/Step2Form.dart';

class Step3Screen extends StatefulWidget {
  final String namaUsaha;
  final String deskripsi;
  final String lokasi;
  final double latitude;
  final double longitude;
  final GlobalKey<Step2FormState> step2Key;

  const Step3Screen({
    super.key,
    required this.namaUsaha,
    required this.deskripsi,
    required this.lokasi,
    required this.latitude,
    required this.longitude,
    required this.step2Key,
  });

  @override
  State<Step3Screen> createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  bool isAgree = false;
  @override
  Widget build(BuildContext context) {
    final step2Data = widget.step2Key.currentState?.getData() ?? {};
    final layanan = step2Data["layanan"] ?? [];
    final days = step2Data["days"] ?? [];
    final openTime = step2Data["openTime"] ?? "";
    final closeTime = step2Data["closeTime"] ?? "";
    final images = step2Data["images"] ?? [];
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
              _rowItem("Nama Jasa", widget.namaUsaha),
              _divider(),

              _rowItem("Deskripsi Jasa", widget.deskripsi),
              _divider(),

              _buildLokasiItem(
                widget.lokasi,
                widget.latitude,
                widget.longitude,
              ),
              _divider(),

              _buildLayananItem(layanan),
              _divider(),

              _buildHariItem(days),
              _divider(),

              _buildJamItem(openTime, closeTime),
              _divider(),

              _buildTarifItem(layanan),
              _divider(),

              _buildGaleriItem(images),
            ],
          ),
        ),
        SizedBox(height: 10),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Checkbox(
              value: isAgree,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
              onChanged: (v) {
                setState(() {
                  isAgree = v ?? false;
                });
              },
            ),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    isAgree = !isAgree;
                  });
                },
                child: Text(
                  "Dengan ini saya setuju untuk semua ketentuan yang berlaku",
                  style: TextStyle(fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

Widget _buildGaleriItem(List images) {
  return Padding(
    padding: const EdgeInsets.all(14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 130, child: Text("Galeri")),
        const Text(": "),
        Expanded(
          child: images.isEmpty
              ? const Text("-")
              : Row(
                  children: List.generate(3, (index) {
                    final hasImage = index < images.length;

                    return Expanded(
                      child: Container(
                        margin: EdgeInsets.only(right: index != 2 ? 8 : 0),
                        height: 70,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.grey.shade200,
                          image: hasImage
                              ? DecorationImage(
                                  image: FileImage(images[index]),
                                  fit: BoxFit.cover,
                                )
                              : null,
                        ),
                        child: !hasImage
                            ? const Center(
                                child: Icon(
                                  Icons.image,
                                  size: 20,
                                  color: Colors.grey,
                                ),
                              )
                            : null,
                      ),
                    );
                  }),
                ),
        ),
      ],
    ),
  );
}

Widget _buildTarifItem(List layanan) {
  if (layanan.isEmpty) {
    return _rowItem("Tarif Layanan", "-");
  }

  /// ambil semua harga
  final prices = layanan
      .map<int>((e) => e["harga"] ?? 0)
      .where((p) => p > 0)
      .toList();

  if (prices.isEmpty) {
    return _rowItem("Tarif Layanan", "-");
  }

  prices.sort();

  final min = prices.first;
  final max = prices.last;

  String format(int value) {
    return value.toString().replaceAllMapped(
      RegExp(r'\B(?=(\d{3})+(?!\d))'),
      (match) => '.',
    );
  }

  final text = min == max
      ? "Rp ${format(min)}"
      : "Rp ${format(min)} - Rp ${format(max)}";

  return _rowItem("Tarif Layanan", text);
}

Widget _buildJamItem(String openTime, String closeTime) {
  final isEmpty = openTime.isEmpty || closeTime.isEmpty;

  return Padding(
    padding: const EdgeInsets.all(14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 130, child: Text("Jam Operasional")),
        const Text(": "),
        Expanded(
          child: Text(
            isEmpty ? "-" : "Jam $openTime Sampai $closeTime",
            style: const TextStyle(fontWeight: FontWeight.w500),
          ),
        ),
      ],
    ),
  );
}

Widget _buildHariItem(List days) {
  return Padding(
    padding: const EdgeInsets.all(14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(width: 130, child: Text("Hari Operasional")),
        const Text(": "),
        Expanded(
          child: Wrap(
            spacing: 8,
            runSpacing: 6,
            children: days.map<Widget>((day) {
              return Chip(label: Text(day));
            }).toList(),
          ),
        ),
      ],
    ),
  );
}

Widget _buildLayananItem(List layanan) {
  final Map<int, List<Map<String, dynamic>>> grouped = {};

  for (var item in layanan) {
    final int categoryId = item["categoryId"];

    if (!grouped.containsKey(categoryId)) {
      grouped[categoryId] = [];
    }

    grouped[categoryId]!.add(item);
  }

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
            children: grouped.entries.map((entry) {
              final categoryId = entry.key;
              final items = entry.value;

              /// ambil nama kategori
              final category = demoCategories.firstWhere(
                (c) => c.id == categoryId.toString(),
              );

              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name,
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 6),

                  Wrap(
                    spacing: 8,
                    runSpacing: 6,
                    children: items.map<Widget>((item) {
                      return Chip(label: Text(item["name"] ?? "-"));
                    }).toList(),
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
