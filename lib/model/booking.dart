import 'package:jasa_app/model/layanan_jasa.dart';
import 'package:jasa_app/model/service.dart';

class Booking {
  final String id;
  final Service service;
  final List<LayananJasa> layananDipilih;
  final DateTime tanggal;
  final double totalHarga;
  final String status;

  Booking({
    required this.id,
    required this.service,
    required this.layananDipilih,
    required this.tanggal,
    required this.totalHarga,
    this.status = "pending",
  });
}

final List<Booking> demoBookings = [
  Booking(
    id: "1",
    service: demoServices[0],
    layananDipilih: [demoLayananJasa.firstWhere((e) => e.serviceId == '1')],
    tanggal: DateTime.now(),
    totalHarga: 120000,
    status: "progress",
  ),
];
