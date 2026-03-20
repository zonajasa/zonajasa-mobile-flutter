import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import 'package:jasa_app/model/category.dart';
import 'package:jasa_app/model/layanan_jasa.dart';
import 'package:jasa_app/model/review.dart';
import 'package:jasa_app/model/service.dart';
import 'package:jasa_app/pages/review/service_reviews_screen.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';

class ProviderDetailScreen extends StatefulWidget {
  final String serviceId;

  const ProviderDetailScreen({super.key, required this.serviceId});

  @override
  State<ProviderDetailScreen> createState() => _ProviderDetailScreenState();
}

class _ProviderDetailScreenState extends State<ProviderDetailScreen> {
  bool _isFollowing = false;
  late Service service;
  late Category category;
  int _serviceVisibleCount = 4;
  int _reviewVisibleCount = 3;
  final ScrollController _serviceScrollController = ScrollController();
  final ScrollController _reviewScrollController = ScrollController();

  @override
  void initState() {
    super.initState();

    service = demoServices.firstWhere((s) => s.id == widget.serviceId);
    category = demoCategories.firstWhere((c) => c.id == service.categoryId);

    _serviceScrollController.addListener(() {
      if (_serviceScrollController.position.pixels ==
          _serviceScrollController.position.maxScrollExtent) {
        if (_serviceVisibleCount < demoLayananJasa.length) {
          setState(() {
            _serviceVisibleCount += 4;
          });
        }
      }
    });

    _reviewScrollController.addListener(() {
      if (_reviewScrollController.position.pixels ==
          _reviewScrollController.position.maxScrollExtent) {
        if (_reviewVisibleCount < demoLayananJasa.length) {
          setState(() {
            _reviewVisibleCount += 3;
          });
        }
      }
    });
  }

  @override
  void dispose() {
    _serviceScrollController.dispose();
    _reviewScrollController.dispose();
    super.dispose();
  }

  Future<void> openWhatsApp() async {
    final phone = service.nomorwa.toString();
    final message =
        "Halo, saya tertarik dengan layanan ${service.name} dari ${service.company}. Bisa diskusi lebih lanjut?";
    final url = "https://wa.me/$phone?text=${Uri.encodeComponent(message)}";

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tidak bisa membuka WhatsApp"),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void shareToApp(String app) async {
    final message =
        "Halo! Lihat layanan ${service.name} dari ${service.company}.\nDeskripsi: ${service.description}\nHarga: Rp${service.price}";

    if (app == "whatsapp") {
      final uri = Uri.parse(
        "whatsapp://send?text=${Uri.encodeComponent(message)}",
      );
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // fallback ke web
        final webUri = Uri.parse(
          "https://wa.me/?text=${Uri.encodeComponent(message)}",
        );
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } else if (app == "telegram") {
      final uri = Uri.parse("tg://msg?text=${Uri.encodeComponent(message)}");
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        // fallback web Telegram
        final webUri = Uri.parse(
          "https://t.me/share/url?url=${Uri.encodeComponent(message)}",
        );
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } else {
      // default fallback ke share sheet
      // ignore: deprecated_member_use
      Share.share(message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          _buildAppBar(),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProviderInfo(),
                _buildStatsSection(),
                _buildTabSection(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // wallpaper perusahaan & TOMBOL SHERE
  Widget _buildAppBar() {
    return SliverAppBar(
      expandedHeight: 200,
      pinned: true,
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.black26,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.arrow_back, color: AppColors.white),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        PopupMenuButton<String>(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.black26,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.share, color: AppColors.white),
          ),
          onSelected: (value) {
            shareToApp(value);
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: "whatsapp",
              child: Row(
                children: [
                  FaIcon(FontAwesomeIcons.whatsapp, color: Colors.green),
                  const SizedBox(width: 8),
                  Text("WhatsApp"),
                ],
              ),
            ),
            PopupMenuItem(
              value: "telegram",
              child: Row(
                children: [
                  Icon(Icons.telegram, color: Colors.blue),
                  const SizedBox(width: 8),
                  Text("Telegram"),
                ],
              ),
            ),
            PopupMenuItem(
              value: "other",
              child: Row(
                children: [
                  Icon(Icons.share),
                  const SizedBox(width: 8),
                  Text("Lainnya"),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(width: 8),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Stack(
          children: [
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Image.asset(service.image, fit: BoxFit.cover),
            ),
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  // ignore: deprecated_member_use
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  //data profile
  Widget _buildProviderInfo() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //detail profil pemilik jasa
          Row(
            children: [
              //foto pemilik jasa
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.asset(
                  service.image,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    //nama dan CV dan rating
                    Row(
                      children: [
                        Text(service.company, style: AppTextStyles.headline2),
                        const SizedBox(width: 8),
                        FaIcon(
                          FontAwesomeIcons.buildingCircleCheck,
                          color: AppColors.primary,
                          size: 20,
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(service.name, style: AppTextStyles.body1),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        const Icon(
                          Icons.star,
                          color: AppColors.warning,
                          size: 16,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          service.rating.toString(),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '(${service.reviewCount.toString()} reviews)',
                          style: AppTextStyles.body2.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    ServiceReviewsScreen(serviceId: service.id),
                              ),
                            );
                          },
                          child: Text(
                            'Lihat semua',
                            style: AppTextStyles.body2.copyWith(
                              color: AppColors.primary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          //tombol hubungi pemilik jasa dan followers
          Row(
            children: [
              // OPEN WA
              Expanded(
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Menghubungi via WhatsApp..."),
                          duration: Duration(seconds: 2),
                        ),
                      );
                      openWhatsApp();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.success,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        FaIcon(FontAwesomeIcons.whatsapp, color: Colors.white),
                        SizedBox(width: 5),
                        Text(
                          "Hubungi pemilik jasa",
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // FOLLOWERS
              Container(
                decoration: BoxDecoration(
                  color: _isFollowing
                      ? AppColors.lightGrey
                      // ignore: deprecated_member_use
                      : AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: IconButton(
                  icon: FaIcon(
                    _isFollowing
                        ? FontAwesomeIcons.check
                        : FontAwesomeIcons.heartCirclePlus,
                    color: _isFollowing ? AppColors.accent : AppColors.primary,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFollowing = !_isFollowing;
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          _isFollowing
                              ? 'Following provider'
                              : 'Unfollowed provider',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //data pengalaman kerja
  Widget _buildStatsSection() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.symmetric(vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.lightGrey),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildStatItem('5 Tahun', 'Pengalaman kerja'),
          _buildVerticalDivider(),
          _buildStatItem('120+', 'Total Jasa'),
          _buildVerticalDivider(),
          _buildStatItem('95%', 'Tingkat Penyelesaian'),
        ],
      ),
    );
  }

  Widget _buildStatItem(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }

  Widget _buildVerticalDivider() {
    return Container(height: 40, width: 1, color: AppColors.lightGrey);
  }

  //buat konten atau informasi dalam akun pemilik jasa/provider
  Widget _buildTabSection() {
    return DefaultTabController(
      length: 3,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 24),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: TabBar(
              tabs: [
                Tab(text: 'Layanan Jasa'),
                Tab(text: 'Info Company'),
                Tab(text: 'Reviews'),
              ],
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primary,
            ),
          ),
          SizedBox(
            height: 580, // Fixed height for demo purposes
            child: TabBarView(
              children: [
                _buildServicesTab(),
                _buildAboutTab(),
                _buildReviewsTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  //info company
  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'About ServicePro Solutions',
            style: AppTextStyles.headline3,
          ),
          const SizedBox(height: 16),
          const Text(
            'ServicePro Solutions is a leading provider of home repair and maintenance services with over 5 years of experience in the industry. We specialize in plumbing, electrical work, furniture assembly, and painting services.\n\nOur team of skilled professionals is dedicated to delivering high-quality service with attention to detail and customer satisfaction as our top priority. We take pride in our work and strive to exceed your expectations with every project.',
            style: AppTextStyles.body2,
          ),
          const SizedBox(height: 24),
          const Text('Work Hours', style: AppTextStyles.headline3),
          const SizedBox(height: 8),

          _buildWorkHoursItem('Monday - Friday', '8:00 AM - 6:00 PM'),
          _buildWorkHoursItem('Saturday', '9:00 AM - 4:00 PM'),
          _buildWorkHoursItem('Sunday', 'Closed'),
          const SizedBox(height: 24),

          const Text('Contact Information', style: AppTextStyles.headline3),
          const SizedBox(height: 16),
          _buildContactItem(
            Icons.email_outlined,
            'Email',
            'info@servicepro.com',
          ),
          _buildContactItem(Icons.phone_outlined, 'Phone', '+1 (555) 123-4567'),
          _buildContactItem(
            Icons.location_on_outlined,
            'Address',
            '123 Service St, City, State',
          ),
          _buildContactItem(
            Icons.language_outlined,
            'Website',
            'www.servicepro.com',
          ),
        ],
      ),
    );
  }

  Widget _buildWorkHoursItem(String day, String hours) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(day, style: AppTextStyles.body2),
          Text(
            hours,
            style: AppTextStyles.body2.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildAreaItem(String area, String response) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const Icon(
            Icons.location_on_outlined,
            size: 16,
            color: AppColors.primary,
          ),
          const SizedBox(width: 8),
          Text(area, style: AppTextStyles.body2),
          const Spacer(),
          Text(
            response,
            style: AppTextStyles.caption.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 2),
              Text(value, style: AppTextStyles.body2),
            ],
          ),
        ],
      ),
    );
  }

  //layanan jasa AMAN SCROLLING
  Widget _buildServicesTab() {
    final layananList = demoLayananJasa
        .where((item) => item.serviceId == service.id)
        .toList();

    if (layananList.isEmpty) {
      return const Center(child: Text("Belum ada layanan tersedia"));
    }

    final visibleList = layananList.take(_serviceVisibleCount).toList();

    return ListView.separated(
      controller: _serviceScrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      physics: const BouncingScrollPhysics(),
      itemCount: visibleList.length + 1,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        if (index == visibleList.length) {
          return _serviceVisibleCount < layananList.length
              ? const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              : const SizedBox();
        }

        final item = visibleList[index];

        return Container(
          decoration: BoxDecoration(
            color: AppColors.background,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                // ignore: deprecated_member_use
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                // ICON / IMAGE (sementara pakai icon dulu)
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: AppColors.primary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.build, color: AppColors.primary),
                ),

                const SizedBox(width: 16),

                // INFO
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(item.name, style: AppTextStyles.headline3),
                      const SizedBox(height: 6),

                      Text(
                        "Harga mulai",
                        style: AppTextStyles.caption.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        NumberFormat.currency(
                          locale: 'id_ID',
                          symbol: 'Rp',
                          decimalDigits: 0,
                        ).format(item.harga),
                        style: AppTextStyles.price,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // detail reviews
  Widget _buildReviewsTab() {
    final reviews = demoReviews
        .where((r) => r.serviceId == service.id)
        .toList();

    if (reviews.isEmpty) {
      return const Center(child: Text("Belum ada review"));
    }
    final visibleReviews = reviews.take(_reviewVisibleCount).toList();
    // Display a summary of reviews with a button to see all reviews
    return ListView(
      controller: _reviewScrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
      physics: const BouncingScrollPhysics(),
      children: [
        _buildReviewSummary(reviews),
        const SizedBox(height: 24),

        ...visibleReviews.map(
          (r) => Column(
            children: [
              _buildReviewItem(
                name: r.userName,
                image: r.userImage,
                rating: r.rating,
                date: _formatDate(r.createdAt),
                comment: r.comment,
              ),
              const Divider(),
            ],
          ),
        ),
        if (_reviewVisibleCount < reviews.length)
          const Padding(
            padding: EdgeInsets.all(16),
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }

  Widget _buildReviewSummary(List<Review> reviews) {
    final avg =
        reviews.map((e) => e.rating).reduce((a, b) => a + b) / reviews.length;

    return Row(
      children: [
        Text(
          avg.toStringAsFixed(1),
          style: const TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(width: 16),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RatingBar.builder(
              initialRating: avg,
              minRating: 1,
              allowHalfRating: true,
              itemCount: 5,
              itemSize: 18,
              ignoreGestures: true,
              itemBuilder: (context, _) =>
                  const Icon(Icons.star, color: AppColors.warning),
              onRatingUpdate: (_) {},
            ),
            const SizedBox(height: 4),
            Text(
              'Berdasarkan ${reviews.length} ulasan',
              style: AppTextStyles.caption,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReviewItem({
    required String name,
    required String image,
    required double rating,
    required String date,
    required String comment,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset(
                  image,
                  width: 40,
                  height: 40,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: AppTextStyles.body1.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Row(
                      children: [
                        RatingBar.builder(
                          initialRating: rating,
                          minRating: 1,
                          allowHalfRating: true,
                          itemCount: 5,
                          itemSize: 14,
                          ignoreGestures: true,
                          itemBuilder: (context, _) =>
                              const Icon(Icons.star, color: AppColors.warning),
                          onRatingUpdate: (_) {},
                        ),
                        const SizedBox(width: 8),
                        Text(
                          date,
                          style: AppTextStyles.caption.copyWith(
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(comment, style: AppTextStyles.body2),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final diff = DateTime.now().difference(date);

    if (diff.inDays > 0) {
      return '${diff.inDays} hari lalu';
    } else if (diff.inHours > 0) {
      return '${diff.inHours} jam lalu';
    } else {
      return 'Baru saja';
    }
  }
}
