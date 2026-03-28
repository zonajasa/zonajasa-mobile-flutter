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
  final String? selectedLayananId;
  const BookingNow({
    super.key,
    required this.serviceId,
    this.selectedLayananId,
  });

  @override
  State<BookingNow> createState() => _BookingNowState();
}

class _BookingNowState extends State<BookingNow> {
  String? _selectedCategoryId;
  bool isLoading = false;
  DateTime _selectedDate = DateTime.now().add(const Duration(days: 1));
  String _selectedTime = '10:00 AM';
  // String? _selectedLayananId;
  final List<String> _selectedLayananIds = [];

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
  void initState() {
    super.initState();

    if (widget.selectedLayananId != null) {
      _selectedLayananIds.add(widget.selectedLayananId!);

      final layanan = demoLayananJasa.firstWhere(
        (l) => l.id == widget.selectedLayananId,
      );

      _selectedCategoryId = layanan.categoryId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isValid = _selectedLayananIds.isNotEmpty;
    final service = demoServices.firstWhere((s) => s.id == widget.serviceId);
    final category = demoCategories.firstWhere(
      (c) => service.categoryId.contains(c.id),
    );
    final layananList = demoLayananJasa
        .where(
          (item) =>
              item.serviceId == service.id &&
              (_selectedCategoryId == null ||
                  item.categoryId == _selectedCategoryId),
        )
        .toList();

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
                                    service.company,
                                    style: AppTextStyles.headline3,
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  const SizedBox(height: 4),

                                  Text(
                                    service.name,
                                    style: AppTextStyles.body2.copyWith(
                                      color: Colors.black,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
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

                      //PILIH KATEGORI
                      const Text(
                        'Pilih Kategori',
                        style: AppTextStyles.headline3,
                      ),
                      const SizedBox(height: 12),

                      SizedBox(
                        height: 40,
                        child: ListView(
                          scrollDirection: Axis.horizontal,
                          children: service.categoryId.map((id) {
                            final cat = demoCategories.firstWhere(
                              (c) => c.id == id,
                            );
                            final isSelected = _selectedCategoryId == id;

                            return Padding(
                              padding: const EdgeInsets.only(right: 8, left: 4),
                              child: ChoiceChip(
                                label: Text(cat.name),
                                selected: isSelected,
                                onSelected: (_) {
                                  setState(() {
                                    _selectedCategoryId = id;
                                    _selectedLayananIds.clear();
                                  });
                                },
                                selectedColor: AppColors.primary,
                                labelStyle: TextStyle(
                                  color: isSelected
                                      ? Colors.white
                                      : Colors.black,
                                ),
                              ),
                            );
                          }).toList(),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // PILIHAN JASA
                      const Text(
                        'Pilih Layanan jasa',
                        style: AppTextStyles.headline3,
                      ),
                      const SizedBox(height: 12),

                      _selectedCategoryId == null
                          ? const Row(
                              children: [
                                Icon(
                                  Icons.info_outline,
                                  size: 16,
                                  color: Colors.grey,
                                ),
                                SizedBox(width: 6),
                                Text(
                                  "Silakan pilih kategori terlebih dahulu",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ],
                            )
                          : layananList.isEmpty
                          ? const Text(
                              "Tidak ada layanan di kategori ini",
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
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.white,
            boxShadow: [
              BoxShadow(
                color: AppColors.shadow,
                blurRadius: 10,
                offset: const Offset(0, -2),
              ),
            ],
          ),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Total harga', style: AppTextStyles.body2),
                  const SizedBox(height: 4),
                  Text(
                    _selectedLayananIds.isEmpty
                        ? "Rp 0"
                        : NumberFormat.currency(
                            locale: 'id_ID',
                            symbol: 'Rp',
                            decimalDigits: 0,
                          ).format(totalHarga),
                    style: AppTextStyles.headline2.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 16),

              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: (!isValid || isLoading)
                        ? null
                        : () async {
                            setState(() => isLoading = true);

                            await Future.delayed(const Duration(seconds: 2));

                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                builder: (_) => BookingBerhasil(),
                              ),
                            );
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isValid
                          ? AppColors.primary
                          : Colors.grey.shade400, // 🔥 abu-abu kalau disabled
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
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
                              "Booking Sekarang",
                              key: ValueKey('text'),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                ),
              ),
            ],
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

            if (isSelected)
              const Icon(Icons.check_circle, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
