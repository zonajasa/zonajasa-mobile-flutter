import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import 'package:jasa_app/model/review.dart';

class ServiceReviewsScreen extends StatefulWidget {
  final String serviceId;

  const ServiceReviewsScreen({super.key, required this.serviceId});

  @override
  State<ServiceReviewsScreen> createState() => _ServiceReviewsScreenState();
}

class _ServiceReviewsScreenState extends State<ServiceReviewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ulasan & Ratings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(text: 'Semua Ulasan'),
            Tab(text: '5 Star'),
            Tab(text: '3-4 Star'),
            Tab(text: '1-2 Star'),
          ],
          labelColor: AppColors.primary,
          unselectedLabelColor: AppColors.textSecondary,
          indicatorColor: AppColors.primary,
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: _buildRatingSummary(),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildReviewsList(null),
                _buildReviewsList(5),
                _buildReviewsList(3),
                _buildReviewsList(1),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: () {
              _showWriteReviewBottomSheet();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text(
              'Tulis Ulasan',
              style: AppTextStyles.buttonPrimary,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRatingSummary() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                '4.8',
                style: TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              RatingBarIndicator(
                rating: 4.8,
                itemBuilder: (context, index) =>
                    const Icon(Icons.star, color: AppColors.warning),
                itemCount: 5,
                itemSize: 20.0,
              ),
              const SizedBox(height: 8),
              Text('Based on 256 reviews', style: AppTextStyles.caption),
            ],
          ),
        ),
        Expanded(
          flex: 3,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildRatingBar(5, 180),
              _buildRatingBar(4, 40),
              _buildRatingBar(3, 20),
              _buildRatingBar(2, 10),
              _buildRatingBar(1, 6),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRatingBar(int stars, int count) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$stars', style: AppTextStyles.body2),
          const Icon(Icons.star, size: 14, color: AppColors.warning),
          const SizedBox(width: 8),
          Expanded(
            child: Stack(
              children: [
                Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: AppColors.lightGrey,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
                LayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.maxWidth * (count / 256);
                    return Container(
                      height: 6,
                      width: width,
                      decoration: BoxDecoration(
                        color: AppColors.warning,
                        borderRadius: BorderRadius.circular(3),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Text('$count', style: AppTextStyles.caption),
        ],
      ),
    );
  }

  Widget _buildReviewsList(int? starFilter) {
    // Mock reviews data
    final reviews = demoReviews
        .where((r) => r.serviceId == widget.serviceId)
        .toList();

    final filteredReviews = starFilter == null
        ? reviews
        : reviews.where((review) {
            if (starFilter == 5) return review.rating == 5;
            if (starFilter == 3) return review.rating >= 3 && review.rating < 5;
            return review.rating < 3;
          }).toList();

    if (filteredReviews.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.rate_review_outlined,
              size: 64,
              color: AppColors.grey,
            ),
            const SizedBox(height: 16),
            Text(
              'Belum ada ulasan dalam kategori ini',
              style: AppTextStyles.body1.copyWith(color: AppColors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(16),
      itemCount: filteredReviews.length,
      separatorBuilder: (context, index) => const Divider(),
      itemBuilder: (context, index) {
        final review = filteredReviews[index];
        return _buildReviewItem(review);
      },
    );
  }

  Widget _buildReviewItem(Review review) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: buildUserImage(review.userImage),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  review.userName,
                  style: AppTextStyles.body1.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(timeAgo(review.createdAt), style: AppTextStyles.caption),
              ],
            ),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                // ignore: deprecated_member_use
                color: AppColors.warning.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    review.rating.toString(),
                    style: AppTextStyles.body2.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.star, size: 14, color: AppColors.warning),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Text(review.comment, style: AppTextStyles.body2),
        const SizedBox(height: 12),
        _buildReviewImages(review.images),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.thumb_up_alt_outlined, size: 16),
              label: const Text('Helpful'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                visualDensity: VisualDensity.compact,
              ),
            ),
            TextButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.flag_outlined, size: 16),
              label: const Text('Report'),
              style: TextButton.styleFrom(
                foregroundColor: AppColors.textSecondary,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ],
        ),
      ],
    );
  }

  String timeAgo(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} detik yang lalu';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} menit yang lalu';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} jam yang lalu';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} hari yang lalu';
    } else if (difference.inDays < 30) {
      return '${(difference.inDays / 7).floor()} minggu yang lalu';
    } else if (difference.inDays < 365) {
      return '${(difference.inDays / 30).floor()} bulan yang lalu';
    } else {
      return '${(difference.inDays / 365).floor()} tahun yang lalu';
    }
  }

  Widget buildUserImage(String image) {
    if (image.startsWith('http')) {
      return Image.network(
        image,
        width: 40,
        height: 40,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Container(width: 40, height: 40, color: AppColors.lightGrey);
        },
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.person, size: 40);
        },
      );
    } else {
      return Image.asset(image, width: 40, height: 40, fit: BoxFit.cover);
    }
  }

  Widget _buildReviewImages(List<String> images) {
    if (images.isEmpty) return const SizedBox.shrink();

    return SizedBox(
      height: 80,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: images.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.network(
                images[index],
                width: 80,
                height: 80,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.broken_image),
              ),
            ),
          );
        },
      ),
    );
  }

  // === TAMPILAN FORM TAMBAH REVIEW
  void _showWriteReviewBottomSheet() {
    double rating = 0;
    final commentController = TextEditingController();
    List<File> selectedImages = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
                left: 16,
                right: 16,
                top: 16,
              ),
              child: SafeArea(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom: MediaQuery.of(context).viewInsets.bottom + 16,
                      top: 16,
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Tulis Ulasan',
                              style: AppTextStyles.headline3,
                            ),
                            IconButton(
                              icon: const Icon(Icons.close),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Center(
                          child: Column(
                            children: [
                              const Text(
                                'Bagaimana pengalaman Anda?',
                                style: AppTextStyles.body1,
                              ),
                              const SizedBox(height: 12),
                              RatingBar.builder(
                                initialRating: 0,
                                minRating: 1,
                                direction: Axis.horizontal,
                                allowHalfRating: true,
                                itemCount: 5,
                                itemSize: 36,
                                glow: false,
                                itemPadding: const EdgeInsets.symmetric(
                                  horizontal: 4.0,
                                ),
                                itemBuilder: (context, _) => const Icon(
                                  Icons.star,
                                  color: AppColors.warning,
                                ),
                                onRatingUpdate: (value) {
                                  setState(() {
                                    rating = value;
                                  });
                                },
                              ),
                              const SizedBox(height: 8),
                              Text(
                                rating > 0
                                    ? _getRatingText(rating)
                                    : 'Ketuk untuk memberi penilaian',
                                style: AppTextStyles.body2.copyWith(
                                  color: rating > 0
                                      ? AppColors.warning
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),
                        TextField(
                          controller: commentController,
                          maxLines: 4,
                          decoration: const InputDecoration(
                            hintText:
                                'Ceritakan lebih banyak tentang pengalaman Anda...',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            const Icon(
                              Icons.camera_alt_outlined,
                              color: AppColors.primary,
                            ),
                            const SizedBox(width: 8),
                            TextButton(
                              onPressed: () {
                                pickImage(setState, selectedImages);
                              },
                              child: Text(
                                'Tambahkan Foto',
                                style: AppTextStyles.body2.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                          ],
                        ),
                        Wrap(
                          spacing: 8,
                          children: selectedImages.map((file) {
                            return Image.file(
                              file,
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            );
                          }).toList(),
                        ),
                        const SizedBox(height: 24),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: rating > 0
                                ? () {
                                    Navigator.pop(context);
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                        content: Text(
                                          'Review submitted successfully!',
                                        ),
                                      ),
                                    );
                                  }
                                : null, // ⬅️ ini auto disable button
                            style: ElevatedButton.styleFrom(
                              backgroundColor: rating > 0
                                  ? AppColors.primary
                                  : AppColors.grey,
                              foregroundColor: AppColors.white,
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: const Text(
                              'Kirim Ulasan',
                              style: AppTextStyles.buttonPrimary,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _getRatingText(double rating) {
    if (rating >= 5) return 'Excellent';
    if (rating >= 4) return 'Very Good';
    if (rating >= 3) return 'Good';
    if (rating >= 2) return 'Fair';
    return 'Poor';
  }

  Future<void> pickImage(Function setState, List<File> selectedImages) async {
    final picker = ImagePicker();

    final pickedFiles = await picker.pickMultiImage();

    if (pickedFiles.isNotEmpty) {
      setState(() {
        selectedImages.addAll(pickedFiles.map((e) => File(e.path)));
      });
    }
  }
}
