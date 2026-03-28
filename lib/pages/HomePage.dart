import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:jasa_app/model/category.dart';
import 'package:jasa_app/model/layanan_jasa.dart';
import 'package:jasa_app/model/service.dart';
import 'package:jasa_app/pages/allJasaScreen.dart';
import 'package:jasa_app/pages/detail_jasa.dart';
import 'package:jasa_app/services/user_service.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _buildHome());
  }
}

//////////////////////////// HomePage ////////////////////////////
class _buildHome extends StatefulWidget {
  const _buildHome();

  @override
  State<_buildHome> createState() => _buildHomeState();
}

class _buildHomeState extends State<_buildHome> {
  int selectedCategoryIndex = 0;
  bool isLoadingProviders = false;
  Position? _userPosition;
  String currentLocation = "Mendeteksi lokasi...";
  bool isLoadingMore = false;
  int _visibleCount = 4;
  final ScrollController _listScrollController = ScrollController();
  double headerOpacity = 1.0;
  @override
  void initState() {
    super.initState();
    _getLocation();
    getProfile();

    _listScrollController.addListener(() {
      if (_listScrollController.position.pixels >=
              _listScrollController.position.maxScrollExtent - 100 &&
          !isLoadingMore &&
          _visibleCount < filteredServices.length) {
        setState(() {
          isLoadingMore = true;
        });

        Future.delayed(const Duration(seconds: 2), () {
          if (!mounted) return;

          setState(() {
            _visibleCount += 4;
            isLoadingMore = false;
          });
        });
      }
    });
  }

  String getCategoryName(String categoryId) {
    final category = demoCategories.firstWhere(
      (cat) => cat.id == categoryId,
      orElse: () => Category(
        id: '',
        name: 'Unknown',
        icon: '',
        image: '',
        description: '',
      ),
    );

    return category.name;
  }

  String namaLengkap = "";

  Future<void> getProfile() async {
    final result = await UserService.getProfile();

    if (result == null) {
      debugPrint("Gagal load profile");
      return;
    }

    final data = result["data"];
    if (data == null) return;

    setState(() {
      namaLengkap = data["nama_lengkap"] ?? "";
    });
  }

  Future<void> _getLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      setState(() {
        currentLocation = "GPS tidak aktif";
      });
      return;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) {
      setState(() {
        currentLocation = "Izin lokasi ditolak";
      });
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );

    List<Placemark> placemarks = await placemarkFromCoordinates(
      position.latitude,
      position.longitude,
    );

    Placemark place = placemarks[0];

    setState(() {
      _userPosition = position;
      currentLocation =
          "${place.subLocality ?? place.locality}, ${place.locality}";
    });
  }

  bool isNotifPressed = false;

  List<Service> currentServices = [];

  List<Service> get filteredServices {
    String categoryId = demoCategories[selectedCategoryIndex].id;

    return demoServices
        .where((service) => service.categoryId.contains(categoryId))
        .toList();
  }

  final List<Map<String, String>> menuItems = [
    {'imagePath': 'images/BlueWrench.png', 'label': 'Tukang'},
    {'imagePath': 'images/YellowLightning.png', 'label': 'Listrik'},
    {'imagePath': 'images/BlueCircle.png', 'label': 'Kebersihan'},
    {'imagePath': 'images/BlueCar.png', 'label': 'Service'},
    {'imagePath': 'images/YellowLightning.png', 'label': 'Bangunan'},
    {'imagePath': 'images/BlueCircle.png', 'label': 'Darurat'},
  ];

  void _refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          _buildHeader(context),
          _buildMenu(
            context: context,
            menuItems: menuItems,
            selectedIndex: selectedCategoryIndex,
            onTapMenu: (index) async {
              setState(() {
                selectedCategoryIndex = index;
                isLoadingProviders = true;
                _visibleCount = 4; // 🔥 konsisten
              });

              await Future.delayed(const Duration(milliseconds: 600));

              setState(() {
                isLoadingProviders = false;
              });
            },
          ),
          _buildServiceSection(
            context: context,
            isLoading: isLoadingProviders,
            services: filteredServices,
            getCategoryName: getCategoryName,
            visibleCount: _visibleCount,
            scrollController: _listScrollController,
            userPosition: _userPosition,
            categoryId: demoCategories[selectedCategoryIndex].id,
          ),
          _buildSearch(_refresh),
          _buildUserAvatar(
            isPressed: isNotifPressed,
            onTapDown: () => setState(() => isNotifPressed = true),
            onTapUp: () => setState(() => isNotifPressed = false),
            onTapCancel: () => setState(() => isNotifPressed = false),
          ),
        ],
      ),
    );
  }
}

Widget _buildHeader(BuildContext context) {
  return Positioned(
    top: 0,
    left: 0,
    right: 0,
    child: Container(
      height: MediaQuery.of(context).size.height / 6.5,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff0247ae), Color(0xff0e86e4)],
        ),
      ),
    ),
  );
}

Widget _buildSearch(VoidCallback refresh) {
  return Positioned(
    top: 55,
    left: 20,
    right: 65,
    child: SearchAnchor(
      builder: (context, controller) {
        return SearchBar(
          controller: controller,
          backgroundColor: const WidgetStatePropertyAll(Colors.white),
          elevation: const WidgetStatePropertyAll(0),
          constraints: const BoxConstraints(minHeight: 45),

          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                bottomLeft: Radius.circular(40),
                topRight: Radius.circular(28),
                bottomRight: Radius.circular(28),
              ),
            ),
          ),
          padding: const WidgetStatePropertyAll(
            EdgeInsets.symmetric(horizontal: 12),
          ),
          leading: const FaIcon(
            FontAwesomeIcons.magnifyingGlass,
            color: Colors.grey,
            size: 20,
          ),
          hintText: "Cari layanan di sini...",
          trailing: [
            IconButton(
              icon: const FaIcon(
                FontAwesomeIcons.circleArrowDown,
                size: 26,
                color: Color(0xff0e86e4),
              ),
              onPressed: () {
                print("Menu kategori ditekan");
              },
            ),
            if (controller.text.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  controller.clear();
                  refresh();
                },
              ),
          ],
          onChanged: (_) {
            refresh();
          },
        );
      },
      suggestionsBuilder: (context, controller) {
        return [];
      },
    ),
  );
}

Widget _buildUserAvatar({
  required bool isPressed,
  required VoidCallback onTapDown,
  required VoidCallback onTapUp,
  required VoidCallback onTapCancel,
}) {
  return Positioned(
    top: 58,
    right: 10,
    child: GestureDetector(
      onTapDown: (_) => onTapDown(),
      onTapUp: (_) => onTapUp(),
      onTapCancel: onTapCancel,
      child: AnimatedScale(
        scale: isPressed ? 1.1 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          width: 45,
          height: 45,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
            image: const DecorationImage(
              image: AssetImage("images/orang.png"),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildMenu({
  required BuildContext context,
  required List<Map<String, String>> menuItems,
  required int selectedIndex,
  required Function(int) onTapMenu,
}) {
  return Positioned(
    top: MediaQuery.of(context).size.height * 0.18,
    left: 15,
    right: 15,
    child: Container(
      height: 101,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            // ignore: deprecated_member_use
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(top: 5),
        itemCount: menuItems.length,
        separatorBuilder: (context, index) => Container(
          width: 1,
          margin: const EdgeInsets.symmetric(vertical: 1),
          color: Colors.grey[300],
        ),
        itemBuilder: (context, index) {
          final item = menuItems[index];

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: AnimatedImageButton(
              imagePath: item['imagePath']!,
              label: item['label']!,
              isSelected: selectedIndex == index,
              onTap: () => onTapMenu(index),
            ),
          );
        },
      ),
    ),
  );
}

Widget _buildServiceSection({
  required BuildContext context,
  required bool isLoading,
  required List<Service> services,
  required String Function(String) getCategoryName,
  required int visibleCount,
  required ScrollController scrollController,
  required Position? userPosition,
  required String categoryId,
}) {
  final visibleServices = services
      .take(visibleCount.clamp(0, services.length))
      .toList();
  return Positioned(
    top: MediaQuery.of(context).size.height * 0.18 + 120,
    left: 15,
    right: 15,
    bottom: 5,
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// ===== JUDUL ATAS =====
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              "Penyedia jasa terdekat",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Colors.black87,
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Alljasascreen()),
                );
              },
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                "Lihat semua",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xff0e86e4),
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 5),

        /// ===== LIST DATA =====
        Expanded(
          child: isLoading
              ? ListView.builder(
                  controller: scrollController,
                  itemCount: 5,
                  itemBuilder: (_, __) => _buildSkeleton(),
                )
              : ListView.separated(
                  controller: scrollController,
                  physics: const BouncingScrollPhysics(),
                  itemCount: visibleServices.length + 1,
                  padding: const EdgeInsets.only(top: 5),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index == visibleServices.length) {
                      return visibleCount < services.length
                          ? const Padding(
                              padding: EdgeInsets.all(16),
                              child: Center(child: CircularProgressIndicator()),
                            )
                          : const SizedBox();
                    }

                    final service = visibleServices[index];

                    double distance = userPosition != null
                        ? Geolocator.distanceBetween(
                                userPosition.latitude,
                                userPosition.longitude,
                                service.latitude,
                                service.longitude,
                              ) /
                              1000
                        : service.jarak;

                    final layananList = demoLayananJasa
                        .where(
                          (item) =>
                              item.serviceId == service.id &&
                              item.categoryId == categoryId,
                        )
                        .toList();

                    final displayed = layananList.isNotEmpty
                        ? layananList.first.name
                        : "";

                    final sisa = layananList.length - 1;

                    return InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                DetailJasa(serviceId: service.id),
                          ),
                        );
                      },
                      child: _buildServiceItem(
                        service,
                        layananList,
                        displayed,
                        sisa,
                        getCategoryName,
                        distance,
                        categoryId,
                      ),
                    );
                  },
                ),
        ),
      ],
    ),
  );
}

Widget _buildSkeleton() {
  return Container(
    height: 110,
    margin: const EdgeInsets.only(bottom: 12),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Row(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 16, width: 120, color: Colors.grey.shade300),
              const SizedBox(height: 8),
              Container(height: 14, width: 180, color: Colors.grey.shade200),
              const SizedBox(height: 8),
              Container(height: 14, width: 100, color: Colors.grey.shade200),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildServiceItem(
  Service service,
  List<LayananJasa> layananList,
  String displayed,
  int sisa,
  String Function(String) getCategoryName,
  double distance,
  String categoryId,
) {
  return Container(
    height: 110,
    padding: const EdgeInsets.symmetric(vertical: 8),
    decoration: BoxDecoration(
      color: Colors.white,
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
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 15, top: 8),
          child: CircleAvatar(
            radius: 35,
            backgroundImage: AssetImage(service.image),
          ),
        ),
        const SizedBox(width: 15),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                service.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                service.company,
                style: const TextStyle(fontSize: 15, color: Colors.black54),
              ),
              Row(
                children: [
                  ...List.generate(5, (index) {
                    double rating = service.rating;
                    return Icon(
                      index < rating.floor() ? Icons.star : Icons.star_border,
                      color: Colors.amber,
                      size: 16,
                    );
                  }),
                  const SizedBox(width: 3),
                  Text(
                    service.rating.toStringAsFixed(1),

                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(width: 5),

                  Container(height: 14, width: 1, color: Colors.grey.shade400),

                  const SizedBox(width: 5),

                  /// Jarak
                  Text(
                    "${distance.toStringAsFixed(1)} km",
                    style: const TextStyle(fontSize: 15, color: Colors.black54),
                  ),
                ],
              ),
              Text(
                layananList.isEmpty
                    ? "${getCategoryName(categoryId)} • Tidak ada layanan"
                    : sisa > 0
                    ? "${getCategoryName(categoryId)} • $displayed +$sisa lainnya"
                    : "${getCategoryName(categoryId)} • $displayed",
                style: TextStyle(
                  fontSize: 13,
                  color: layananList.isEmpty ? Colors.grey : Colors.black54,
                  fontStyle: layananList.isEmpty
                      ? FontStyle.italic
                      : FontStyle.normal,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

class AnimatedImageButton extends StatefulWidget {
  final String imagePath;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const AnimatedImageButton({
    super.key,
    required this.imagePath,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  State<AnimatedImageButton> createState() => _AnimatedImageButtonState();
}

class _AnimatedImageButtonState extends State<AnimatedImageButton> {
  bool isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTapDown: (_) {
            setState(() {
              isPressed = true;
            });
          },
          onTapUp: (_) {
            setState(() {
              isPressed = false;
            });
            widget.onTap();
          },
          onTapCancel: () {
            setState(() {
              isPressed = false;
            });
          },
          child: AnimatedScale(
            scale: widget.isSelected ? 1.2 : (isPressed ? 1.2 : 1.0),
            duration: const Duration(milliseconds: 100),
            child: Image.asset(widget.imagePath, width: 50, height: 50),
          ),
        ),
        const SizedBox(height: 6),
        Text(
          widget.label,
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: widget.isSelected ? Colors.blue : Colors.black87,
          ),
        ),
      ],
    );
  }
}
