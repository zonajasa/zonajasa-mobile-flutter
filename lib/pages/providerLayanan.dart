import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jasa_app/core/constants/app_constants.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import 'package:jasa_app/model/category.dart';
import 'package:jasa_app/model/layanan_jasa.dart';
import 'package:jasa_app/model/service.dart';
import 'package:intl/intl.dart';
import 'package:jasa_app/pages/booking/booking_screen.dart';

class Providerlayanan extends StatelessWidget {
  final Service service;
  final String categoryId;

  const Providerlayanan({
    super.key,
    required this.service,
    required this.categoryId,
  });

  String getCategoryName(String id) {
    final cat = demoCategories.firstWhere(
      (c) => c.id == id,
      orElse: () => Category(
        id: '',
        name: 'Unknown',
        icon: '',
        image: '',
        description: '',
      ),
    );
    return cat.name;
  }

  Widget buildImage(String image) {
    if (image.startsWith('http')) {
      return Image.network(
        image,
        height: 110,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    } else {
      return Image.asset(
        image,
        height: 110,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // ignore: unused_local_variable
    final layanan = demoLayananJasa
        .where((l) => l.serviceId == service.id)
        .toList();
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(children: [_buildHeader(context), _buildResults()]),
      ),
    );
  }

  // ============ APP BAR ================================================//
  Widget _buildHeader(BuildContext context) {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: AppColors.black,
              size: 24,
            ),
          ),
          Expanded(
            child: Text(
              '${getCategoryName(categoryId)} - ${service.name}',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  //====================== LIST DATA ====================================//
  Widget _buildResults() {
    final layanan = demoLayananJasa
        .where((l) => l.serviceId == service.id && l.categoryId == categoryId)
        .toList();

    if (layanan.isEmpty) {
      return const Expanded(
        child: Center(
          child: Text(
            "Belum ada layanan tersedia",
            style: TextStyle(color: Colors.grey),
          ),
        ),
      );
    }

    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(AppConstants.paddingM),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.8,
          crossAxisSpacing: AppConstants.paddingM,
          mainAxisSpacing: AppConstants.paddingM,
        ),
        itemCount: layanan.length,
        itemBuilder: (context, index) {
          final item = layanan[index];

          return Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: buildImage(item.image),
                ),

                /// NAMA LAYANAN
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                /// HARGA LAYANAN
                Text(
                  NumberFormat.currency(
                    locale: 'id_ID',
                    symbol: 'Rp',
                    decimalDigits: 0,
                  ).format(item.harga),
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xff0e86e4),
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 6),

                /// 🔥 BUTTON / CTA
                SizedBox(
                  width: double.infinity,
                  height: 30,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BookingNow(
                            serviceId: item.serviceId,
                            selectedLayananId: item.id,
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xffe3f2fd),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.zero,
                    ),
                    child: const Text(
                      "Pilih",
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xff0e86e4),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
