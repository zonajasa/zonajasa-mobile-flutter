import 'package:flutter/material.dart';

class Step3Screen extends StatelessWidget {
  const Step3Screen({super.key});

  @override
  Widget build(BuildContext context) {
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
              _rowItem("Nama Jasa"),
              _divider(),

              _rowItem("Deskripsi Jasa"),
              _divider(),

              _buildLokasiItem(),
              _divider(),

              _buildLayananItem(),
              _divider(),

              _rowItem("Hari Operasional"),
              _divider(),

              _rowItem("Jam Operasional"),
              _divider(),

              _rowItem("Tarif Layanan"),
              _divider(),

              _rowItem("Galeri"),
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

Widget _buildLayananItem() {
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
            children: [
              /// kategori
              const Text(
                "AC Service",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              //layanan jasa
              Wrap(
                spacing: 8,
                children: const [
                  Chip(label: Text("Cuci AC")),
                  Chip(label: Text("Service AC")),
                ],
              ),

              const SizedBox(height: 10),

              /// kategori 2
              const Text(
                "Multimedia",
                style: TextStyle(fontWeight: FontWeight.w500),
              ),
              const SizedBox(height: 6),
              //layanan jasa
              Wrap(
                spacing: 8,
                children: const [Chip(label: Text("Editing Video"))],
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildLokasiItem() {
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
            children: const [
              /// alamat utama
              Text("Jl. Contoh Alamat No.123, Kota Kendari"),

              SizedBox(height: 6),

              /// koordinat
              Text(
                "Lat: -3.9985, Lng: 122.5123",
                style: TextStyle(fontSize: 12, color: Colors.grey),
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

Widget _rowItem(String title) {
  return Padding(
    padding: const EdgeInsets.all(14),
    child: Row(
      children: [
        SizedBox(width: 130, child: Text(title)),
        const Text(": "),
        const Expanded(child: Text("")),
      ],
    ),
  );
}
