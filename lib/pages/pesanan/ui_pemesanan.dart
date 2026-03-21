import 'package:flutter/material.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import 'package:jasa_app/model/booking.dart';
import 'package:intl/intl.dart';

class PemesananPage extends StatefulWidget {
  const PemesananPage({super.key});

  @override
  State<PemesananPage> createState() => _PemesananPageState();
}

class _PemesananPageState extends State<PemesananPage> {
  final List<Booking> bookings = demoBookings;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pesanan Saya"),
        backgroundColor: AppColors.white,
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: bookings.isEmpty
          ? const Center(child: Text("Belum ada pesanan 😢"))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: bookings.length,
              itemBuilder: (context, index) {
                final booking = bookings[index];
                final service = booking.service;
                final layanan = booking.layananDipilih;

                return Container(
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
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.asset(
                              service.image,
                              width: 70,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          ),

                          const SizedBox(width: 12),

                          // 🔥 INFO
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  service.name,
                                  style: AppTextStyles.body1.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),

                                Text(
                                  layanan.map((e) => e.name).join(", "),
                                  style: AppTextStyles.body2.copyWith(
                                    color: AppColors.textSecondary,
                                  ),
                                ),

                                const SizedBox(height: 6),

                                Text(
                                  DateFormat(
                                    'dd MMM yyyy • HH:mm',
                                  ).format(booking.tanggal),
                                  style: AppTextStyles.body2.copyWith(
                                    color: Colors.grey,
                                  ),
                                ),

                                const SizedBox(height: 8),

                                Text(
                                  "${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(booking.totalHarga)}",
                                  style: AppTextStyles.body1.copyWith(
                                    color: AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 🔥 STATUS + BUTTON
                      Row(
                        children: [
                          // STATUS
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: booking.status == "progress"
                                  // ignore: deprecated_member_use
                                  ? Colors.orange.withOpacity(0.1)
                                  // ignore: deprecated_member_use
                                  : Colors.green.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              booking.status == "progress"
                                  ? "On Progress"
                                  : "Done",
                              style: TextStyle(
                                color: booking.status == "progress"
                                    ? Colors.orange
                                    : Colors.green,
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),

                          const Spacer(),

                          // LACAK
                          TextButton(
                            onPressed: () {
                              print("Lacak");
                            },
                            child: const Text("Lacak"),
                          ),

                          // CHAT
                          ElevatedButton(
                            onPressed: () {
                              print("Chat ${service.nomorwa}");
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              foregroundColor: Colors.white,
                            ),
                            child: const Text("Chat"),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}
