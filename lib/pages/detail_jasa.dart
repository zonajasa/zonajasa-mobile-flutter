import 'package:flutter/material.dart';
import 'package:jasa_app/pages/providerLayanan.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import 'package:jasa_app/model/category.dart';
import 'package:jasa_app/model/layanan_jasa.dart';
import 'package:jasa_app/model/review.dart';
import 'package:jasa_app/model/review_card.dart';
import 'package:jasa_app/pages/booking/booking_screen.dart';
import 'package:jasa_app/pages/provider_detail_screen.dart';
import 'package:jasa_app/pages/review/service_reviews_screen.dart';
import 'package:jasa_app/pages/service_image_carousel.dart';
import 'package:jasa_app/model/service.dart';

class DetailJasa extends StatefulWidget {
  final String serviceId;

  const DetailJasa({super.key, required this.serviceId});

  @override
  State<DetailJasa> createState() => _DetailJasaState();
}

class _DetailJasaState extends State<DetailJasa> {
  final int quantity = 1;
  late MapboxMap mapboxMap;
  PointAnnotationManager? _annotationManager;

  Future<void> _onMapCreated(MapboxMap map) async {
    mapboxMap = map;
    _annotationManager = await mapboxMap.annotations
        .createPointAnnotationManager();

    final service = demoServices.firstWhere((s) => s.id == widget.serviceId);
    await Future.delayed(const Duration(milliseconds: 800));

    final bytes = await DefaultAssetBundle.of(
      context,
    ).load("images/location.png");

    final image = MbxImage(
      width: 640,
      height: 640,
      data: bytes.buffer.asUint8List(),
    );
    final style = mapboxMap.style;

    await style.addStyleImage("my-marker", 1.0, image, false, [], [], null);

    await _addMarker(service);
  }

  Future<void> _addMarker(Service service) async {
    if (_annotationManager == null) return;

    final point = Point(
      coordinates: Position(service.longitude, service.latitude),
    );

    await _annotationManager!.create(
      PointAnnotationOptions(
        geometry: point,
        iconImage: "my-marker",
        iconSize: 0.04,
      ),
    );

    await mapboxMap.flyTo(
      CameraOptions(
        center: Point(
          coordinates: Position(service.longitude, service.latitude),
        ),
        zoom: 14,
      ),
      MapAnimationOptions(duration: 500),
    );
  }

  @override
  Widget build(BuildContext context) {
    final service = demoServices.firstWhere((s) => s.id == widget.serviceId);
    final reviews = demoReviews
        .where((r) => r.serviceId == widget.serviceId)
        .toList();
    final layananList = demoLayananJasa
        .where((item) => item.serviceId == service.id)
        .toList();
    return Scaffold(
      body: Stack(
        children: [
          CustomScrollView(
            slivers: [
              // == FOTO
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                leading: Container(
                  margin: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    // ignore: deprecated_member_use
                    color: Colors.white.withOpacity(0.8),
                    shape: BoxShape.circle,
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      // ignore: deprecated_member_use
                      color: Colors.white.withOpacity(0.8),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.favorite_border),
                      onPressed: () {},
                    ),
                  ),
                ],
                flexibleSpace: FlexibleSpaceBar(
                  background: ServiceImageCarousel(images: service.images),
                ),
              ),
              // DETAIL JASA
              SliverToBoxAdapter(
                child: Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Service Name & Price
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              service.name,
                              style: AppTextStyles.headline2,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Rating
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            double rating = service.rating;
                            return Icon(
                              index < rating.floor()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: Colors.amber,
                              size: 16,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            '${service.rating} (${service.reviewCount} reviews)',
                            style: AppTextStyles.body2,
                          ),
                        ],
                      ),
                      // == Jenis kategory
                      const SizedBox(height: 5),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Wrap(
                              spacing: 8,
                              children: service.categoryId.map((id) {
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

                                return ActionChip(
                                  label: Text(
                                    cat.name,
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: Color(0xff0e86e4),
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  backgroundColor: const Color(0xffe3f2fd),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => Providerlayanan(
                                          service: service,
                                          categoryId: id,
                                        ),
                                      ),
                                    );
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),

                      const Divider(),

                      const SizedBox(height: 16),

                      // Description
                      const Text('Deskripsi Jasa'),
                      const SizedBox(height: 8),
                      Text(service.description),

                      const SizedBox(height: 24),

                      // Features
                      const Text(
                        'Layanan jasa yang tersedia',
                        style: AppTextStyles.headline3,
                      ),
                      const SizedBox(height: 12),
                      layananList.isEmpty
                          ? const Text(
                              "Belum ada layanan tersedia",
                              style: TextStyle(color: Colors.grey),
                            )
                          : Column(
                              children: layananList
                                  .take(5)
                                  .map(
                                    (item) => Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                            size: 20,
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(child: Text(item.name)),
                                        ],
                                      ),
                                    ),
                                  )
                                  .toList(),
                            ),
                      if (layananList.length > 5)
                        Padding(
                          padding: const EdgeInsets.only(top: 4),
                          child: Text(
                            "+${layananList.length - 5} layanan lainnya",
                            style: const TextStyle(
                              fontSize: 13,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      // end
                    ],
                  ),
                ),
              ),
              // MAP LOKASI
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(16),
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Lokasi', style: AppTextStyles.headline3),
                      const SizedBox(height: 12),

                      /// MAP
                      Container(
                        height: 200,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        clipBehavior: Clip.hardEdge,
                        child: MapWidget(
                          key: const ValueKey("mapWidget"),

                          onMapCreated: _onMapCreated,

                          cameraOptions: CameraOptions(
                            center: Point(
                              coordinates: Position(
                                service.longitude,
                                service.latitude,
                              ),
                            ),
                            zoom: 14,
                          ),

                          styleUri: MapboxStyles.MAPBOX_STREETS,
                        ),
                      ),

                      const SizedBox(height: 10),

                      /// ALAMAT TEXT
                      Text(
                        service.address,
                        style: AppTextStyles.body2.copyWith(
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // AKUN PEMILIK JASA
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(16),
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Profil pemilik jasa',
                        style: AppTextStyles.headline3,
                      ),
                      const SizedBox(height: 12),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProviderDetailScreen(service: service),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: Image.network(
                                'https://images.unsplash.com/photo-1607346256330-dee7af15f7c5',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,

                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        width: 60,
                                        height: 60,
                                        color: AppColors.lightGrey,
                                        child: const Center(
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                          ),
                                        ),
                                      );
                                    },

                                errorBuilder: (context, error, stackTrace) {
                                  return Container(
                                    width: 60,
                                    height: 60,
                                    color: AppColors.lightGrey,
                                    child: const Icon(
                                      Icons.business,
                                      color: AppColors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    service.company,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      ...List.generate(5, (index) {
                                        double rating = service.rating;
                                        return Icon(
                                          index < rating.floor()
                                              ? Icons.star
                                              : Icons.star_border,
                                          color: Colors.amber,
                                          size: 16,
                                        );
                                      }),
                                      const SizedBox(width: 4),
                                      Text(
                                        service.rating.toStringAsFixed(1),

                                        style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '(${service.reviewCount} reviews)',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              // REVIEW
              SliverToBoxAdapter(
                child: Container(
                  margin: const EdgeInsets.only(top: 8),
                  padding: const EdgeInsets.all(16),
                  color: AppColors.white,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Reviews', style: AppTextStyles.headline3),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => ServiceReviewsScreen(
                                    serviceId: widget.serviceId,
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              'Lihat semua',
                              style: AppTextStyles.body2.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Show first 3 reviews
                      ...reviews
                          .take(3)
                          .map((review) => ReviewCard(review: review)),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
      // TOMBOL BOOKING
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
          child: SizedBox(
            height: 50,
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BookingNow(serviceId: service.id),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
              child: const Text(
                "Pilih Layanan",
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
    );
  }
}
