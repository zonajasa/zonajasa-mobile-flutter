import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import 'package:jasa_app/model/category.dart';
import 'package:jasa_app/model/layanan_jasa.dart';
import 'package:jasa_app/model/service.dart';
import 'package:intl/intl.dart';
import 'package:jasa_app/pages/booking/booking_success_screen.dart';

class BookingNow extends StatefulWidget {
  final String serviceId;
  const BookingNow({super.key, required this.serviceId});

  @override
  State<BookingNow> createState() => _BookingNowState();
}

class _BookingNowState extends State<BookingNow> {
  bool isLoading = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '10:00 AM';
  // String? _selectedLayananId;
  List<String> _selectedLayananIds = [];

  final List<String> _availableTimes = [
    '09:00 AM',
    '10:00 AM',
    '11:00 AM',
    '12:00 PM',
    '01:00 PM',
    '02:00 PM',
    '03:00 PM',
    '04:00 PM',
    '05:00 PM',
  ];

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final service = demoServices.firstWhere((s) => s.id == widget.serviceId);
    final category = demoCategories.firstWhere(
      (c) => c.id == service.categoryId,
    );
    final layananList = demoLayananJasa
        .where((item) => item.serviceId == service.id)
        .toList();
    // final selectedLayanan = layananList.firstWhere(
    //   (l) => l.id == _selectedLayananId,
    //   orElse: () => layananList.first,
    // );
    double totalHarga = layananList
        .where((l) => _selectedLayananIds.contains(l.id))
        .fold(0, (sum, item) => sum + item.harga);

    return Scaffold(
      appBar: AppBar(title: const Text('Pesan Layanan')),
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Summary
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.shadow,
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.asset(
                                service.image,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.name,
                                    style: AppTextStyles.headline3,
                                  ),
                                  const SizedBox(height: 4),
                                  // Text(
                                  //   '${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(selectedLayanan.harga)} - ${category.name}',
                                  //   style: AppTextStyles.price,
                                  // ),
                                  Text(
                                    _selectedLayananIds.isEmpty
                                        ? "Rp0 - ${category.name}"
                                        : "${NumberFormat.currency(locale: 'id_ID', symbol: 'Rp', decimalDigits: 0).format(totalHarga)} - ${category.name}",
                                    style: AppTextStyles.price,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Date Selection
                      const Text(
                        'Pilih Tanggal',
                        style: AppTextStyles.headline3,
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        height: 100,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: 14, // Show next 14 days
                          itemBuilder: (context, index) {
                            final date = DateTime.now().add(
                              Duration(days: index),
                            );
                            final isSelected =
                                _selectedDate.year == date.year &&
                                _selectedDate.month == date.month &&
                                _selectedDate.day == date.day;

                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedDate = date;
                                });
                              },
                              child: Container(
                                width: 70,
                                margin: const EdgeInsets.only(right: 12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primary
                                        : AppColors.border,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      DateFormat('EEE').format(date),
                                      style: AppTextStyles.body2.copyWith(
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      DateFormat('dd').format(date),
                                      style: AppTextStyles.headline3.copyWith(
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.textPrimary,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Text(
                                      DateFormat('MMM').format(date),
                                      style: AppTextStyles.caption.copyWith(
                                        color: isSelected
                                            ? AppColors.white
                                            : AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Time Selection
                      const Text('Pilih Waktu', style: AppTextStyles.headline3),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 10,
                        runSpacing: 10,
                        children: _availableTimes.map((time) {
                          final isSelected = _selectedTime == time;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedTime = time;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : AppColors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.border,
                                ),
                              ),
                              child: Text(
                                time,
                                style: AppTextStyles.body2.copyWith(
                                  color: isSelected
                                      ? AppColors.white
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 24),

                      // PILIHAN JASA
                      const Text(
                        'Pilih Layanan jasa',
                        style: AppTextStyles.headline3,
                      ),
                      const SizedBox(height: 12),
                      layananList.isEmpty
                          ? const Text(
                              "Belum ada layanan tersedia",
                              style: TextStyle(color: Colors.grey),
                            )
                          : Column(
                              children: layananList.map((item) {
                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 8),
                                  child: _buildJasaOption(item),
                                );
                              }).toList(),
                            ),

                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.all(16),
          height: 55,
          child: ElevatedButton(
            onPressed: isLoading
                ? null
                : () async {
                    if (_selectedLayananIds.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Layanan jasa belum kamu pilih"),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      return;
                    }

                    setState(() => isLoading = true);

                    await Future.delayed(const Duration(seconds: 2));

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => BookingBerhasil()),
                    );
                  },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.blue,
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isLoading
                  ? const SizedBox(
                      key: ValueKey('loading'),
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text(
                      "Booking Now",
                      key: ValueKey('text'),
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildJasaOption(LayananJasa item) {
    final isSelected = _selectedLayananIds.contains(item.id);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedLayananIds.remove(item.id); // unselect
          } else {
            _selectedLayananIds.add(item.id); // select
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            const FaIcon(FontAwesomeIcons.businessTime, color: Colors.grey),
            const SizedBox(width: 16),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: AppTextStyles.body1),

                  // 🔥 optional harga kecil (biar lebih jelas)
                  const SizedBox(height: 4),
                  Text(
                    NumberFormat.currency(
                      locale: 'id_ID',
                      symbol: 'Rp',
                      decimalDigits: 0,
                    ).format(item.harga),
                    style: AppTextStyles.caption,
                  ),
                ],
              ),
            ),

            // ✅ tetap pakai icon lama (clean look)
            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
