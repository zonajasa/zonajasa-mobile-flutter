import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jasa_app/core/constants/app_constants.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';

class Alljasascreen extends StatefulWidget {
  const Alljasascreen({super.key});

  @override
  State<Alljasascreen> createState() => _AlljasascreenState();
}

class _AlljasascreenState extends State<Alljasascreen> {
  final List<String> _selectedFilters = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(child: Column(children: [_buildHeader(context)])),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Container(
    color: AppColors.white,
    padding: const EdgeInsets.all(AppConstants.paddingM),
    child: Row(
      children: [
        IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const HugeIcon(
            icon: HugeIcons.strokeRoundedArrowLeft01,
            color: AppColors.black,
            size: 24,
            strokeWidth: 3,
          ),
        ),
        Expanded(
          child: Text(
            'Semua Penyedia Terdekat',
            style: AppTextStyles.titleLarge.copyWith(
              color: AppColors.textPrimary,
            ),
          ),
        ),
        IconButton(
          onPressed: () => {},
          icon: Stack(
            children: [
              const HugeIcon(
                icon: HugeIcons.strokeRoundedFilterHorizontal,
                color: AppColors.textPrimary,
                size: 24,
              ),
              // if (_selectedFilters.isNotEmpty)
              //   Positioned(
              //     right: 0,
              //     top: 0,
              //     child: Container(
              //       width: 8,
              //       height: 8,
              //       decoration: const BoxDecoration(
              //         color: AppColors.accent,
              //         shape: BoxShape.circle,
              //       ),
              //     ),
              //   ),
            ],
          ),
        ),
      ],
    ),
  );
}
