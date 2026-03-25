import 'package:flutter/material.dart';
import 'package:flutter_custom_textfields/flutter_custom_textfields.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import 'package:jasa_app/model/review.dart';

class ReviewCard extends StatelessWidget {
  final Review review;

  const ReviewCard({super.key, required this.review});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // User info and rating
          Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: AppColors.lightGrey,
                backgroundImage: AssetImage(review.userImage),
                onBackgroundImageError: (exception, stackTrace) {},
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      review.userName,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      DateFormatter.formatDate(
                        review.createdAt,
                        'MMM dd, yyyy',
                      ),
                      style: AppTextStyles.caption.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              ...List.generate(5, (index) {
                double rating = review.rating;
                return Icon(
                  index < rating.floor() ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                  size: 16,
                );
              }),
            ],
          ),

          const SizedBox(height: 12),

          // Review content
          Text(review.comment, style: AppTextStyles.body2),
        ],
      ),
    );
  }
}
