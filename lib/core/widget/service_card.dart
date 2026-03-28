import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class ServiceCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String price;
  final String? originalPrice;
  final double? rating;
  final int? reviewCount;
  final String? category;
  final String? services;
  final VoidCallback? onTap;
  final String? subtitle;
  final VoidCallback? onFavoriteTap;
  final String? badge;
  final bool isHorizontal;

  const ServiceCard({
    super.key,
    this.subtitle,
    required this.imageUrl,
    required this.title,
    required this.price,
    this.originalPrice,
    this.rating,
    this.reviewCount,
    this.onTap,
    this.category,
    this.services,
    this.onFavoriteTap,
    this.badge,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    return isHorizontal ? _buildHorizontalCard() : _buildVerticalCard();
  }

  // ================== VERTICAL ==================
  Widget _buildVerticalCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(flex: 3, child: _buildImageSection()),
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.body1.copyWith(
                        fontSize: 14,
                        height: 1.2,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),

                    const SizedBox(height: 4),

                    /// CATEGORY
                    if (category != null)
                      Text(
                        category!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),

                    /// SERVICES
                    if (services != null)
                      Text(
                        services!,
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                          fontSize: 12,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),

                    /// RATING
                    if (rating != null) _buildRatingSection(),

                    const Spacer(),

                    /// PRICE
                    _buildPriceSection(),
                    const SizedBox(height: 6),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== HORIZONTAL ==================
  Widget _buildHorizontalCard() {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 120,
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          boxShadow: [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            SizedBox(width: 100, child: _buildImageSection()),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppConstants.paddingS),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: AppTextStyles.body1,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (rating != null) _buildRatingSection(),
                    _buildPriceSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ================== IMAGE ==================
  Widget _buildImageSection() {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: imageUrl.startsWith('http')
              ? CachedNetworkImage(
                  imageUrl: imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                  placeholder: (_, __) => Container(
                    color: AppColors.grey100,
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (_, __, ___) => _buildErrorImage(),
                )
              : Image.asset(
                  imageUrl,
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
        ),

        /// BADGE
        if (badge != null)
          Positioned(
            top: 6,
            left: 6,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.secondary,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                badge!,
                style: AppTextStyles.labelSmall.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildErrorImage() {
    return Container(
      color: AppColors.grey100,
      child: const HugeIcon(
        icon: HugeIcons.strokeRoundedImage01,
        color: AppColors.textSecondary,
      ),
    );
  }

  // ================== RATING ==================
  Widget _buildRatingSection() {
    return Row(
      children: [
        const HugeIcon(
          icon: HugeIcons.strokeRoundedStar,
          color: AppColors.accent,
          size: 12,
        ),
        const SizedBox(width: 4),
        Text(
          rating!.toStringAsFixed(1),
          style: AppTextStyles.labelSmall.copyWith(fontWeight: FontWeight.w600),
        ),
        if (reviewCount != null) ...[
          const SizedBox(width: 4),
          Text(
            '($reviewCount)',
            style: AppTextStyles.labelSmall.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ],
    );
  }

  // ================== PRICE ==================
  Widget _buildPriceSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Current price
        Text(
          price,
          style: AppTextStyles.productPrice.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        // Original price with breathing space
        if (originalPrice != null) ...[
          const SizedBox(height: 2),
          Text(
            originalPrice!,
            style: AppTextStyles.bodySmall.copyWith(
              color: AppColors.textSecondary,
              decoration: TextDecoration.lineThrough,
              fontSize: 12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }
}
