import 'dart:io';
import 'package:flutter/material.dart';

class Step3Screen extends StatefulWidget {
  final String namaUsaha;
  final String deskripsi;
  final String lokasi;
  final double latitude;
  final double longitude;

  final Map<String, dynamic> step2Data;

  const Step3Screen({
    super.key,
    required this.namaUsaha,
    required this.deskripsi,
    required this.lokasi,
    required this.latitude,
    required this.longitude,
    required this.step2Data,
  });

  @override
  State<Step3Screen> createState() => _Step3ScreenState();
}

class _Step3ScreenState extends State<Step3Screen> {
  bool isAgree = false;

  @override
  Widget build(BuildContext context) {
    final layanan = widget.step2Data["layanan"] as List;
    final days = widget.step2Data["days"] as List;
    final images = widget.step2Data["images"] as List<File>;

    final openTime = widget.step2Data["openTime"];
    final closeTime = widget.step2Data["closeTime"];

    int minPrice = 0;
    int maxPrice = 0;

    if (layanan.isNotEmpty) {
      final prices = layanan.map((e) => e["harga"] as int).toList();
      prices.sort();
      minPrice = prices.first;
      maxPrice = prices.last;
    }

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  children: [
                    _buildItem("Nama Jasa", widget.namaUsaha),
                    _divider(),

                    _buildItem("Deskripsi Jasa", widget.deskripsi),
                    _divider(),

                    _buildItem("Lokasi Jasa", widget.lokasi),
                    _divider(),

                    /// LAYANAN
                    _buildCustom(
                      "Layanan Jasa",
                      Wrap(
                        spacing: 8,
                        children: layanan.map((e) {
                          return Chip(label: Text(e["name"]));
                        }).toList(),
                      ),
                    ),
                    _divider(),

                    /// HARI
                    _buildCustom(
                      "Hari Operasional",
                      Wrap(
                        spacing: 8,
                        children: days.map<Widget>((d) {
                          return Chip(label: Text(d));
                        }).toList(),
                      ),
                    ),
                    _divider(),

                    /// JAM
                    _buildItem("Jam Operasional", "$openTime - $closeTime"),
                    _divider(),

                    /// TARIF
                    _buildItem(
                      "Tarif Layanan",
                      minPrice == 0
                          ? "-"
                          : minPrice == maxPrice
                          ? "Rp $minPrice"
                          : "Rp $minPrice - Rp $maxPrice",
                    ),
                    _divider(),

                    /// GALERI
                    _buildCustom(
                      "Galeri",
                      SizedBox(
                        height: 80,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: images.length,
                          itemBuilder: (_, i) {
                            return Container(
                              margin: const EdgeInsets.only(right: 10),
                              width: 80,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                image: DecorationImage(
                                  image: FileImage(images[i]),
                                  fit: BoxFit.cover,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          /// CHECKBOX
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Checkbox(
                  value: isAgree,
                  onChanged: (v) {
                    setState(() {
                      isAgree = v ?? false;
                    });
                  },
                ),
                const Expanded(
                  child: Text(
                    "Dengan ini saya setuju untuk semua ketentuan yang berlaku",
                  ),
                ),
              ],
            ),
          ),

          /// BUTTON
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text("Kembali"),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: isAgree ? _submit : null,
                    child: const Text("Buat Akun"),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(height: 1, color: Colors.grey.shade300);
  }

  Widget _buildItem(String title, String value) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        children: [
          SizedBox(width: 130, child: Text(title)),
          const Text(": "),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _buildCustom(String title, Widget child) {
    return Padding(
      padding: const EdgeInsets.all(14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 130, child: Text(title)),
          const Text(": "),
          Expanded(child: child),
        ],
      ),
    );
  }

  void _submit() {
    /// nanti kita isi di next step 🔥
    print("SUBMIT DATA");
  }
}
