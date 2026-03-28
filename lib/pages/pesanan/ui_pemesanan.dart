import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/booking.dart';
import 'package:intl/intl.dart';
import 'package:jasa_app/model/layanan_jasa.dart';
import 'package:jasa_app/pages/booking/booking_screen.dart';
import 'package:jasa_app/pages/detail_jasa.dart';
import 'package:jasa_app/pages/review/service_reviews_screen.dart';
import 'package:jasa_app/core/theme/DottedLine.dart';
import 'package:jasa_app/utils/booking_utils.dart';

class PemesananPage extends StatefulWidget {
  const PemesananPage({super.key});

  @override
  State<PemesananPage> createState() => _PemesananPageState();
}

class _PemesananPageState extends State<PemesananPage> {
  final List<Booking> bookings = demoBookings;

  List<Booking> get progressBookings => bookings
      .where(
        (b) =>
            b.status == "process" ||
            b.status == "on_the_way" ||
            b.status == "working",
      )
      .toList();

  List<Booking> get completedBookings =>
      bookings.where((b) => b.status == "done").toList();

  String _formatLayanan(List<LayananJasa>? layanan) {
    if (layanan == null || layanan.isEmpty) return "-";

    if (layanan.length <= 2) {
      return layanan.map((e) => e.name).join(", ");
    }

    return "${layanan.first.name} +${layanan.length - 1} lainnya";
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Pesanan Saya'),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'In Progress'),
              Tab(text: 'Completed'),
            ],
            labelColor: AppColors.primary,
            unselectedLabelColor: AppColors.textSecondary,
            indicatorColor: AppColors.primary,
          ),
        ),
        body: TabBarView(
          children: [
            _buildList(progressBookings),
            _buildList(completedBookings),
          ],
        ),
      ),
    );
  }

  Widget _buildList(List<Booking> list) {
    if (list.isEmpty) {
      return const Center(child: Text("Belum ada pesanan"));
    }

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      itemCount: list.length,
      itemBuilder: (context, index) {
        final booking = list[index];
        final service = booking.service;

        return ClipPath(
          clipper: TicketClipper(),
          child: Container(
            margin: const EdgeInsets.only(bottom: 16),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    // 🔥 IMAGE
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Image.asset(service.image, fit: BoxFit.cover),
                      ),
                    ),

                    const SizedBox(width: 12),

                    // 🔥 TEXT CONTENT
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _formatLayanan(booking.layananDipilih),
                            style: const TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            "Dijadwalkan pada: ${DateFormat('dd/MM/yyyy').format(booking.tanggal)}",
                            style: const TextStyle(
                              fontSize: 12,
                              color: Colors.black54,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              // ignore: deprecated_member_use
                              color: getStatusColor(
                                booking.status,
                                // ignore: deprecated_member_use
                              ).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              getStatusText(booking.status),
                              style: TextStyle(
                                color: getStatusColor(booking.status),
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp ',
                              decimalDigits: 0,
                            ).format(booking.totalHarga),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const DottedLine(),

                const SizedBox(height: 12),
                if (booking.status == "done") ...[
                  Row(
                    children: [
                      // TOMBOL BERI ULASAN
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ServiceReviewsScreen(serviceId: service.id),
                              ),
                            );
                          },
                          icon: FaIcon(FontAwesomeIcons.star, size: 18),
                          label: const Text("Beri Ulasan"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.warning,
                            side: BorderSide(color: AppColors.warning),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),
                      // TOMBOL PESAN LAGI
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    BookingNow(serviceId: service.id),
                              ),
                            );
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.arrowsRotate,
                            size: 14,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Pesan Lagi",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.success,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ] else ...[
                  Row(
                    children: [
                      // TOMBOL CHAT PEMILIK JASA
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            // TODO: chat
                          },
                          icon: FaIcon(FontAwesomeIcons.whatsapp, size: 18),
                          label: const Text("Chat"),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            side: BorderSide(color: AppColors.primary),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(width: 10),
                      // TOMBOL DETAIL JASA
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailJasa(serviceId: service.id),
                              ),
                            );
                          },
                          icon: FaIcon(
                            FontAwesomeIcons.circleInfo,
                            size: 18,
                            color: Colors.white,
                          ),
                          label: const Text(
                            "Detail jasa",
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class TicketClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    double radius = 20;

    Path path = Path();

    // kiri atas → tengah kiri (bolong)
    path.lineTo(0, size.height / 2 - radius);
    path.arcToPoint(
      Offset(0, size.height / 2 + radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // kiri bawah → kanan bawah
    path.lineTo(0, size.height);
    path.lineTo(size.width, size.height);

    // kanan bawah → tengah kanan (bolong)
    path.lineTo(size.width, size.height / 2 + radius);
    path.arcToPoint(
      Offset(size.width, size.height / 2 - radius),
      radius: Radius.circular(radius),
      clockwise: false,
    );

    // kanan atas → balik ke awal
    path.lineTo(size.width, 0);
    path.close();

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
