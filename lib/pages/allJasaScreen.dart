import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jasa_app/core/constants/app_constants.dart';
import 'package:jasa_app/core/widget/como_text_field.dart';
import 'package:jasa_app/core/widget/service_card.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import 'package:jasa_app/model/category.dart';
import 'package:jasa_app/model/layanan_jasa.dart';
import 'package:jasa_app/model/service.dart';
import 'package:jasa_app/pages/detail_jasa.dart';
import 'package:intl/intl.dart';

class Alljasascreen extends StatefulWidget {
  const Alljasascreen({super.key});

  @override
  State<Alljasascreen> createState() => _AlljasascreenState();
}

class _AlljasascreenState extends State<Alljasascreen> {
  final TextEditingController _searchController = TextEditingController();
  static const double defaultDistance = 50;
  final List<String> _selectedFilters = [];
  String _selectedCategory = 'All';
  String _selectedPriceRange = 'All';
  final List<Category> _categories = demoCategories;
  List<Service> searchResults = [];
  final List<Service> _allServices = demoServices;
  Position? _userPosition;
  double _maxDistance = 50;

  // ignore: unused_field
  bool _isLoading = false;

  Future<void> _getUserLocation() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition(
      // ignore: deprecated_member_use
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _userPosition = position;
    });
  }

  final List<String> _priceRanges = [
    'Semua',
    '< 100k',
    '100k - 300k',
    '300k - 500k',
    '> 500k',
  ];

  void _applyCurrentFilters([String query = ""]) {
    List<Service> filtered = _allServices;
    print("TOTAL AWAL: ${filtered.length}");

    // 🔍 SEARCH
    if (query.isNotEmpty) {
      filtered = filtered.where((service) {
        return service.name.toLowerCase().contains(query.toLowerCase()) ||
            service.description.toLowerCase().contains(query.toLowerCase());
      }).toList();
      print("SETELAH SEARCH: ${filtered.length}");
    }

    // 🧩 CATEGORY
    if (_selectedCategory != 'All') {
      filtered = filtered
          .where((service) => service.categoryId == _selectedCategory)
          .toList();
      print("SETELAH CATEGORY: ${filtered.length}");
    }

    // 📍 DISTANCE FILTER
    if (_userPosition != null && _maxDistance != defaultDistance) {
      filtered = filtered.where((service) {
        final distance =
            Geolocator.distanceBetween(
              _userPosition!.latitude,
              _userPosition!.longitude,
              service.latitude,
              service.longitude,
            ) /
            1000;

        return distance <= _maxDistance;
      }).toList();
      print("SETELAH DISTANCE: ${filtered.length}");

      // 🔥 TARUH DI SINI (SETELAH FILTER)
      filtered.sort((a, b) {
        final distA = Geolocator.distanceBetween(
          _userPosition!.latitude,
          _userPosition!.longitude,
          a.latitude,
          a.longitude,
        );

        final distB = Geolocator.distanceBetween(
          _userPosition!.latitude,
          _userPosition!.longitude,
          b.latitude,
          b.longitude,
        );

        return distA.compareTo(distB);
      });
    }

    // 💰 PRICE FILTER (pakai layananJasa)
    if (_selectedPriceRange != 'All') {
      filtered = filtered.where((service) {
        // ambil semua layanan dari provider ini
        final layanan = demoLayananJasa
            .where((l) => l.serviceId == service.id)
            .toList();

        if (layanan.isEmpty) return false;

        // cek apakah ADA yang masuk range
        return layanan.any((l) {
          final price = l.harga;

          switch (_selectedPriceRange) {
            case '< 100k':
              return price < 100000;
            case '100k - 300k':
              return price >= 100000 && price <= 300000;
            case '300k - 500k':
              return price > 300000 && price <= 500000;
            case '> 500k':
              return price > 500000;
            default:
              return true;
          }
        });
      }).toList();

      print("SETELAH PRICE: ${filtered.length}");
    }

    setState(() {
      searchResults = filtered;
    });
  }

  void _performSearch(String query) {
    _applyCurrentFilters(query);
  }

  void _loadInitialProducts() {
    setState(() {
      _isLoading = true;
      _selectedCategory = 'All';
      _selectedPriceRange = 'All';
      _maxDistance = defaultDistance;
      _selectedFilters.clear();
    });

    Future.delayed(const Duration(milliseconds: 300), () {
      setState(() {
        searchResults = _allServices;
        _isLoading = false;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getUserLocation();
    searchResults = _allServices;
    _loadInitialProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchSection(),
            _buildFilterChips(),
            _buildResultsHeader(),
            Expanded(
              child: _isLoading ? _buildLoadingState() : _buildSearchResults(),
            ),
          ],
        ),
      ),
    );
  }

  // NAMA PENCARIAN SCREEN
  Widget _buildHeader() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.all(AppConstants.paddingM),
      child: Row(
        children: [
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const FaIcon(
              FontAwesomeIcons.angleLeft,
              color: AppColors.black,
              size: 24,
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
            onPressed: _showFilterBottomSheet,
            icon: Stack(
              children: [
                const HugeIcon(
                  icon: HugeIcons.strokeRoundedFilterHorizontal,
                  color: AppColors.textPrimary,
                  size: 24,
                ),
                if (_selectedFilters.isNotEmpty)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.secondary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // PENCARIAN
  Widget _buildSearchSection() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingM,
        0,
        AppConstants.paddingM,
        AppConstants.paddingM,
      ),
      child: ComoTextField(
        controller: _searchController,
        hint: 'Cari penyedia jasa di sini...',
        prefixIcon: const HugeIcon(
          icon: HugeIcons.strokeRoundedSearch01,
          color: AppColors.textSecondary,
          size: 25,
          strokeWidth: 2,
        ),
        suffixIcon: _searchController.text.isNotEmpty
            ? GestureDetector(
                onTap: () {
                  _searchController.clear();
                  _performSearch('');
                },
                child: const HugeIcon(
                  icon: HugeIcons.strokeRoundedCancel01,
                  color: AppColors.textSecondary,
                  size: 25,
                  strokeWidth: 2,
                ),
              )
            : null,
        onChanged: (value) {
          _performSearch(value);
        },
      ),
    );
  }

  // HASIL RESULT HEADER
  Widget _buildResultsHeader() {
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.paddingM,
        vertical: AppConstants.paddingS,
      ),
      child: Row(
        children: [
          Text(
            '${searchResults.length} Penyedia jasa yang Ditemukan',
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  // KALAU KATEGORINYA UDAH DI PILIH BISA DI HAPUS ==============================
  Widget _buildFilterChips() {
    if (_selectedFilters.isEmpty) return const SizedBox.shrink();
    return Container(
      color: AppColors.white,
      padding: const EdgeInsets.fromLTRB(
        AppConstants.paddingM,
        0,
        AppConstants.paddingM,
        AppConstants.paddingS,
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            ...(_selectedFilters.map((filter) {
              return Container(
                margin: const EdgeInsets.only(right: AppConstants.paddingS),
                child: Chip(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  label: Text(
                    filter,
                    style: AppTextStyles.caption.copyWith(
                      color: AppColors.white,
                    ),
                  ),
                  backgroundColor: AppColors.grey900,
                  deleteIcon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: AppColors.white,
                    size: 16,
                  ),
                  onDeleted: () {
                    setState(() {
                      _selectedFilters.remove(filter);
                      _clearSpecificFilter(filter);
                    });
                  },
                ),
              );
            })),
            if (_selectedFilters.isNotEmpty)
              TextButton(
                onPressed: () {
                  setState(() {
                    _selectedFilters.clear();
                    _selectedCategory = 'All';
                    _selectedPriceRange = 'All';
                    _performSearch(_searchController.text);
                  });
                },
                child: Text(
                  'Hapus Semua',
                  style: AppTextStyles.body2.copyWith(
                    color: AppColors.secondary,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  void _clearSpecificFilter(String filter) {
    // CATEGORY
    if (_categories.any((c) => c.name == filter)) {
      _selectedCategory = 'All';
    }
    // PRICE
    else if (_priceRanges.contains(filter)) {
      _selectedPriceRange = 'All';
    }
    // DISTANCE
    else if (filter.contains('km')) {
      _maxDistance = defaultDistance;
    }

    _performSearch(_searchController.text);
  }
  //=============================================================================

  // HASIL PENCARIAN ================ LIST DATA =====================================
  Widget _buildSearchResults() {
    if (searchResults.isEmpty) {
      return _buildEmptyState();
    }
    return GridView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.75,
        crossAxisSpacing: AppConstants.paddingM,
        mainAxisSpacing: AppConstants.paddingM,
      ),
      itemCount: searchResults.length,
      itemBuilder: (context, index) {
        final service = searchResults[index];

        final layanan = demoLayananJasa
            .where((l) => l.serviceId == service.id)
            .toList();

        double minPrice = 0;
        if (layanan.isNotEmpty) {
          minPrice = layanan
              .map((e) => e.harga)
              .reduce((a, b) => a < b ? a : b);
        }

        final displayed = layanan.take(1).map((e) => e.name).join(', ');

        final sisa = layanan.length - 1;

        final categoryName = getCategoryName(service.categoryId);

        final servicesText = layanan.isEmpty
            ? "Tidak ada layanan"
            : sisa > 0
            ? "$displayed +$sisa lainnya"
            : displayed;

        return ServiceCard(
          imageUrl: service.image,
          title: service.name,
          category: categoryName,
          services: servicesText,
          price: minPrice > 0
              ? NumberFormat.currency(
                  locale: 'id_ID',
                  symbol: 'Rp ',
                  decimalDigits: 0,
                ).format(minPrice)
              : 'Harga N/A',
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DetailJasa(serviceId: service.id),
              ),
            );
          },
        );
      },
    );
  }

  // KALAU DATANYA / LIST DATA NYA KOSONG ===========================================
  Widget _buildEmptyState() {
    return Center(
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const HugeIcon(
              icon: HugeIcons.strokeRoundedSearch01,
              size: 64,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppConstants.paddingL),
            Text(
              'Tidak ditemukan penyedia jasa',
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingS),
            Text(
              'Coba cari dengan kata kunci yang berbeda \natau sesuaikan filter Anda',
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingL),
            OutlinedButton(
              onPressed: () {
                FocusScope.of(context).unfocus();
                _searchController.clear();
                _loadInitialProducts();
              },
              child: Text(
                'Hapus Pencarian',
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // LOADING LIST DATA
  Widget _buildLoadingState() {
    return const Center(
      child: CircularProgressIndicator(color: AppColors.grey900),
    );
  }

  //
  //
  // ====================================== FILTER ============================================= //
  //TAMPILAN DALAM FILTER
  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.85,
              maxChildSize: 0.95,
              minChildSize: 0.7,
              expand: false,
              builder: (context, scrollController) {
                return Container(
                  decoration: const BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(AppConstants.radiusXL),
                    ),
                  ),
                  child: Column(
                    children: [
                      _buildFilterHeader(),

                      Expanded(
                        child: ListView(
                          controller: scrollController,
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppConstants.paddingL,
                          ),
                          children: [
                            const SizedBox(height: AppConstants.paddingXL),
                            _buildCategoryFilter(setModalState),
                            _buildJarakFilter(setModalState),
                            _buildPriceRangeFilter(setModalState),
                            const SizedBox(height: AppConstants.paddingXL),
                          ],
                        ),
                      ),

                      _buildFilterActions(setModalState),
                    ],
                  ),
                );
              },
            );
          },
        );
      },
    );
  }

  //TAMPILAN DALAM FILTER -> ISI KATEGORI
  Widget _buildCategoryFilter(StateSetter setModalState) {
    return _buildFilterContainer(
      title: 'Kategori',
      icon: FontAwesomeIcons.layerGroup,
      child: Wrap(
        spacing: AppConstants.paddingS,
        runSpacing: AppConstants.paddingS,
        children: [
          GestureDetector(
            onTap: () {
              setModalState(() {
                _selectedCategory = 'All';
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.paddingM,
                vertical: AppConstants.paddingS,
              ),
              decoration: BoxDecoration(
                color: _selectedCategory == 'All'
                    ? AppColors.primary
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(AppConstants.radiusL),
                border: Border.all(
                  color: _selectedCategory == 'All'
                      ? AppColors.primary
                      : AppColors.grey200,
                ),
              ),
              child: Text(
                "Semua",
                style: AppTextStyles.bodyMedium.copyWith(
                  color: _selectedCategory == 'All'
                      ? AppColors.white
                      : AppColors.textPrimary,
                  fontWeight: _selectedCategory == 'All'
                      ? FontWeight.w600
                      : FontWeight.normal,
                ),
              ),
            ),
          ),

          ..._categories.map((category) {
            final isSelected = _selectedCategory == category.id;

            return GestureDetector(
              onTap: () {
                setModalState(() {
                  _selectedCategory = category.id;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppConstants.paddingM,
                  vertical: AppConstants.paddingS,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.grey100,
                  borderRadius: BorderRadius.circular(AppConstants.radiusL),
                  border: Border.all(
                    color: isSelected ? AppColors.primary : AppColors.grey200,
                  ),
                ),
                child: Text(
                  category.name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isSelected ? AppColors.white : AppColors.textPrimary,
                    fontWeight: isSelected
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  //TAMPILAN DALAM FILTER -> ISI JARAK FILTER
  Widget _buildJarakFilter(StateSetter setModalState) {
    final options = [5.0, 10.0, 20.0];

    return _buildFilterContainer(
      title: 'Jarak',
      icon: FontAwesomeIcons.map,
      child: Wrap(
        spacing: 8,
        children: [
          GestureDetector(
            onTap: () {
              setModalState(() {
                _maxDistance = 50;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: _maxDistance == 50
                    ? AppColors.primary
                    : AppColors.grey100,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                "Semua",
                style: TextStyle(
                  color: _maxDistance == 50 ? Colors.white : Colors.black,
                ),
              ),
            ),
          ),

          ...options.map((distance) {
            final isSelected = _maxDistance == distance;

            return GestureDetector(
              onTap: () {
                setModalState(() {
                  _maxDistance = distance;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primary : AppColors.grey100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "${distance.toInt()} km",
                  style: TextStyle(
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  //TAMPILAN DALAM FILTER -> HARGA JASA
  Widget _buildPriceRangeFilter(StateSetter setModalState) {
    return _buildFilterContainer(
      title: 'Kisaran Harga',
      icon: FontAwesomeIcons.rupiahSign,
      child: Column(
        children: _priceRanges.map((range) {
          final isSelected = _selectedPriceRange == range;

          return GestureDetector(
            onTap: () {
              setModalState(() {
                _selectedPriceRange = range;
              });
            },
            child: Container(
              margin: const EdgeInsets.only(bottom: AppConstants.paddingS),
              padding: const EdgeInsets.all(AppConstants.paddingM),
              decoration: BoxDecoration(
                color: isSelected
                    // ignore: deprecated_member_use
                    ? AppColors.primary.withOpacity(0.1)
                    : AppColors.grey50,
                borderRadius: BorderRadius.circular(AppConstants.radiusM),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.grey200,
                  width: isSelected ? 2 : 1,
                ),
              ),
              child: Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : Colors.transparent,
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.grey400,
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: isSelected
                        ? const Icon(Icons.check, color: Colors.white, size: 14)
                        : null,
                  ),
                  const SizedBox(width: AppConstants.paddingM),
                  Expanded(
                    child: Text(
                      range,
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: isSelected
                            ? AppColors.primary
                            : AppColors.textPrimary,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  //CONTAINER OTOMATIS UNTUK DATA DALAM FILTER
  Widget _buildFilterContainer({
    required String title,
    required IconData icon,
    required Widget child,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppConstants.paddingL),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppConstants.radiusM),
        border: Border.all(color: AppColors.grey200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            decoration: const BoxDecoration(
              color: AppColors.grey50,
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppConstants.radiusM),
              ),
            ),
            child: Row(
              children: [
                FaIcon(icon, color: AppColors.grey800, size: 20),
                const SizedBox(width: AppConstants.paddingS),
                Text(
                  title,
                  style: AppTextStyles.body1.copyWith(
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: child,
          ),
        ],
      ),
    );
  }

  //HEADER DALAM FILTER
  Widget _buildFilterHeader() {
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: const BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusXL),
        ),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.grey300,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: AppConstants.paddingM),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Filter Service',
                      style: AppTextStyles.headlineSmall.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: AppConstants.paddingXS),
                    Text(
                      '${_getActiveFilterCount()} filter yang diterapkan',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  int _getActiveFilterCount() {
    int count = 0;
    if (_selectedCategory != 'All') count++;
    if (_selectedPriceRange != 'All') count++;
    if (_maxDistance != defaultDistance) count++;
    return count;
  }

  //TOMBOL DALAM FILTER
  Widget _buildFilterActions(StateSetter setModalState) {
    final hasFilter = _getActiveFilterCount() > 0;
    return Container(
      padding: const EdgeInsets.all(AppConstants.paddingL),
      decoration: const BoxDecoration(
        color: AppColors.white,
        boxShadow: [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 8,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            // TOMBOL HAPUS
            Expanded(
              child: OutlinedButton(
                onPressed: hasFilter
                    ? () {
                        setModalState(() {
                          _selectedCategory = 'All';
                          _selectedPriceRange = 'All';
                          _selectedFilters.clear();
                          _maxDistance = 50;
                        });

                        setState(() {
                          searchResults = _allServices;
                        });

                        Navigator.pop(context);
                      }
                    : null,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingM,
                  ),
                  side: const BorderSide(color: AppColors.primary, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const FaIcon(
                      FontAwesomeIcons.arrowRotateRight,
                      color: AppColors.primary,
                      size: 18,
                    ),
                    const SizedBox(width: AppConstants.paddingS),
                    Text(
                      'Hapus',
                      style: AppTextStyles.body2.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: AppConstants.paddingM),
            // TOMBOL APPLY
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: () {
                  _applyFilters();
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: hasFilter
                      ? AppColors.primary
                      : Colors.grey.shade300,
                  padding: const EdgeInsets.symmetric(
                    vertical: AppConstants.paddingM,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppConstants.radiusM),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FaIcon(
                      FontAwesomeIcons.check,
                      color: hasFilter ? Colors.white : Colors.black54,
                      size: 18,
                    ),
                    const SizedBox(width: AppConstants.paddingS),
                    Text(
                      hasFilter
                          ? "Terapkan Filter (${_getActiveFilterCount()})"
                          : "Tampilkan Semua",
                      style: AppTextStyles.body2.copyWith(
                        color: hasFilter ? Colors.white : Colors.black54,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ============================================================================================= //
  //
  //
  //
  //
  void _applyFilters() {
    _selectedFilters.clear();

    if (_selectedCategory != 'All') {
      final categoryName = _categories
          .firstWhere((c) => c.id == _selectedCategory)
          .name;

      _selectedFilters.add(categoryName);
    }

    if (_selectedPriceRange != 'All') {
      _selectedFilters.add(_selectedPriceRange);
    }

    if (_maxDistance != defaultDistance) {
      _selectedFilters.add("${_maxDistance.toInt()} km");
    }
    _performSearch(_searchController.text);
  }

  String getCategoryName(String categoryId) {
    final category = _categories.firstWhere(
      (c) => c.id == categoryId,
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}
