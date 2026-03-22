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
    service: demoServices.firstWhere((s) => s.id == '1'),
    layananDipilih: demoLayananJasa.where((e) => e.serviceId == '1').toList(),
    tanggal: DateTime.now(),
    totalHarga: 120000,
    status: "on_the_way",
  ),
  Booking(
    id: "2",
    service: demoServices.firstWhere((s) => s.id == '2'),
    layananDipilih: demoLayananJasa.where((e) => e.serviceId == '2').toList(),
    tanggal: DateTime.now(),
    totalHarga: 120000,
    status: "done",
  ),
];
