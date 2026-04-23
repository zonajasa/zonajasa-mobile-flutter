import 'dart:io';

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:jasa_app/core/widget/stepperIndikator.dart';
import 'package:jasa_app/pages/pemilik_jasa/Step2Form.dart';
import 'package:jasa_app/pages/pemilik_jasa/Step3Screen.dart';
import 'package:jasa_app/pages/pemilik_jasa/map_picker_screen.dart';
import 'package:jasa_app/services/user_service.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class ProfilDatajasa extends StatefulWidget {
  final int userId;
  final String namaLengkap;
  const ProfilDatajasa({
    super.key,
    required this.userId,
    required this.namaLengkap,
  });

  @override
  State<ProfilDatajasa> createState() => _ProfilDatajasaState();
}

class _ProfilDatajasaState extends State<ProfilDatajasa> {
  final GlobalKey<Step2FormState> step2Key = GlobalKey();
  final ScrollController _scrollController = ScrollController();
  final TextEditingController lokasiController = TextEditingController();
  final namaController = TextEditingController();
  final deskripsiController = TextEditingController();

  List<String> selectedCategoryIds = [];
  List<String> selectedDays = [];
  Map<String, List<LayananItem>> layananPerCategory = {};
  List<File> selectedImages = [];

  String jamBuka = "";
  String jamTutup = "";

  double scrollOffset = 0;
  int currentStep = 1;

  String namaUsaha = "";
  String deskripsi = "";
  String lokasi = "";
  double latitude = 0.0;
  double longitude = 0.0;

  bool isNamaError = false;
  bool isDeskripsiError = false;
  bool isLokasiError = false;
  bool validateStep1() {
    bool isValid = true;

    if (namaUsaha.isEmpty) {
      isNamaError = true;
      isValid = false;
    }

    if (deskripsi.isEmpty) {
      isDeskripsiError = true;
      isValid = false;
    }

    // ignore: unnecessary_null_comparison
    if (lokasi.isEmpty || latitude == 0.0 || longitude == 0.0) {
      isLokasiError = true;
      isValid = false;
    }

    if (mounted) {
      setState(() {});
    }
    return isValid;
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(() {
      if (!mounted) return;
      setState(() {
        scrollOffset = _scrollController.offset;
      });
    });
    namaController.text = namaUsaha;
    deskripsiController.text = deskripsi;
    lokasiController.text = lokasi;
  }

  @override
  void dispose() {
    _scrollController.dispose();
    namaController.dispose();
    deskripsiController.dispose();
    lokasiController.dispose();
    super.dispose();
  }

  void showCancelDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text("Batalkan Pengisian?"),
          content: const Text(
            "Jika keluar sekarang, Anda akan dibatalkan sebagai pemilik jasa.",
          ),
          actions: [
            TextButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xff0e86e4),
              ),
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text(
                "Lanjutkan",
                style: TextStyle(color: Colors.white),
              ),
            ),

            ElevatedButton(
              onPressed: () async {
                Navigator.pop(dialogContext);

                showLoadingDialog();

                final results = await Future.wait([
                  UserService.cancelProvider(widget.userId, widget.namaLengkap),
                  Future.delayed(const Duration(seconds: 2)),
                ]);

                final success = results[0] as bool;

                if (!mounted) return;

                Navigator.of(context, rootNavigator: true).pop();
                if (success) {
                  Navigator.pop(context, true);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Gagal membatalkan")),
                  );
                }
              },
              child: const Text(
                "Ya, Batalkan",
                style: TextStyle(color: Colors.red),
              ),
            ),
          ],
        );
      },
    );
  }

  void showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (loadingContext) {
        return Center(
          child: LoadingAnimationWidget.halfTriangleDot(
            color: Colors.white,
            size: 100,
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      // ignore: deprecated_member_use
      onPopInvoked: (didPop) {
        if (didPop) return;

        showCancelDialog();
      },
      child: Scaffold(
        body: Stack(
          children: [
            SingleChildScrollView(
              controller: _scrollController,
              child: Container(
                color: Color(0xffeeeefa),
                child: Column(
                  children: [
                    SizedBox(height: MediaQuery.of(context).size.height * 0.12),

                    Container(
                      width: double.infinity,
                      constraints: BoxConstraints(
                        minHeight: MediaQuery.of(context).size.height,
                      ),
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          StepIndicator(currentStep: currentStep, totalStep: 3),
                          const SizedBox(height: 25),

                          buildStepContent(),

                          const SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Builder(
                builder: (context) {
                  bool isScrolled = scrollOffset > 10;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    height: kToolbarHeight + MediaQuery.of(context).padding.top,

                    padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top,
                      left: 16,
                      right: 16,
                    ),

                    decoration: BoxDecoration(
                      color: isScrolled ? Colors.white : Colors.transparent,
                      boxShadow: isScrolled
                          ? [
                              BoxShadow(
                                // ignore: deprecated_member_use
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 8,
                              ),
                            ]
                          : [],
                    ),

                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () {
                            showCancelDialog();
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: isScrolled
                                  ? Colors.grey.shade200
                                  : Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.arrow_back_ios_new,
                              size: 18,
                              color: isScrolled ? Colors.black : Colors.black,
                            ),
                          ),
                        ),

                        const SizedBox(width: 12),

                        Text(
                          "Buka Jasa",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isScrolled ? Colors.black : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            //end
          ],
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
            padding: const EdgeInsets.all(15),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  // ignore: deprecated_member_use
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                ),
              ],
            ),
            child: buildNavigationButton(),
          ),
        ),
      ),
    );
  }

  Widget buildStepContent() {
    return IndexedStack(
      index: currentStep - 1,
      children: [
        /// STEP 1
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Data Jasa",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 15),

            /// NAMA JASA
            TextField(
              controller: namaController,
              onChanged: (value) {
                setState(() {
                  namaUsaha = value;
                  isNamaError = false;
                });
              },
              decoration: InputDecoration(
                hintText: "Nama usaha",
                helperText: "Contoh: CV. Budi Mandiri atau Laundry Express",
                errorText: isNamaError ? "Nama usaha wajib diisi" : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                suffixIcon: Padding(
                  padding: const EdgeInsets.all(12),
                  child: FaIcon(FontAwesomeIcons.penToSquare, size: 22),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// DESKRIPSI
            TextField(
              controller: deskripsiController,
              maxLines: 4,
              onChanged: (value) {
                setState(() {
                  deskripsi = value;
                  isDeskripsiError = false;
                });
              },
              decoration: InputDecoration(
                hintText: "Ceritakan tentang usaha Anda",
                errorText: isDeskripsiError ? "Deskripsi wajib diisi" : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 15),

            /// LOKASI
            GestureDetector(
              onTap: () async {
                final result = await Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => MapPickerScreen()),
                );

                if (!mounted) return;

                if (result != null) {
                  // ignore: avoid_print
                  print(result);
                  setState(() {
                    lokasiController.text = result["address"];
                    lokasi = result["address"];
                    latitude = (result["lat"] as num).toDouble();
                    longitude = (result["lng"] as num).toDouble();
                    isLokasiError = false;
                  });
                }
              },
              child: AbsorbPointer(
                child: TextField(
                  controller: lokasiController,
                  decoration: InputDecoration(
                    hintText: "Pilih lokasi usaha",
                    helperText: "Tap untuk pilih lokasi dari peta",
                    errorText: isLokasiError ? "Lokasi wajib dipilih" : null,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    suffixIcon: const Icon(
                      Icons.location_on,
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),

        /// STEP 2
        Step2Form(
          key: step2Key,
          selectedCategoryIds: selectedCategoryIds,
          selectedDays: selectedDays,
          layananPerCategory: layananPerCategory,
          selectedImages: selectedImages,
          jamBuka: jamBuka,
          jamTutup: jamTutup,
          onChanged: (data) {
            setState(() {
              selectedCategoryIds = List<String>.from(
                data["selectedCategoryIds"],
              );
              selectedDays = List<String>.from(data["selectedDays"]);
              layananPerCategory = Map<String, List<LayananItem>>.from(
                data["layanan"],
              );
              selectedImages = List<File>.from(data["images"]);
              jamBuka = data["openTime"];
              jamTutup = data["closeTime"];
            });
          },
        ),

        /// STEP 3
        Step3Screen(
          namaUsaha: namaUsaha,
          deskripsi: deskripsi,
          lokasi: lokasi,
          latitude: latitude,
          longitude: longitude,
        ),
      ],
    );
  }

  Widget buildNavigationButton() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: const Color(0xff1a1a6e),
              side: const BorderSide(color: Color(0xff1a1a6e)),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: currentStep == 1
                ? null
                : () {
                    setState(() => currentStep--);
                  },
            child: const Text("Kembali"),
          ),
        ),

        const SizedBox(width: 15),

        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xff1a1a6e),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onPressed: () {
              if (currentStep == 1) {
                final isValid = validateStep1();
                if (!isValid) return;
              }

              if (currentStep == 2) {
                final isValid = step2Key.currentState?.validate() ?? false;
                if (!isValid) return;
              }

              if (currentStep < 3) {
                setState(() => currentStep++);
              } else {
                // submit nanti di sini
              }
            },
            child: Text(currentStep == 3 ? "Selesai" : "Lanjut"),
          ),
        ),
      ],
    );
  }
}
