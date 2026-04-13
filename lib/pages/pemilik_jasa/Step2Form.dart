import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:jasa_app/model/category.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    String newText = newValue.text.replaceAll(RegExp(r'[^0-9]'), '');

    if (newText.isEmpty) {
      return const TextEditingValue(text: '');
    }

    final number = int.parse(newText);
    final newFormatted = _formatter.format(number);

    return TextEditingValue(
      text: newFormatted,
      selection: TextSelection.collapsed(offset: newFormatted.length),
    );
  }
}

class LayananItem {
  TextEditingController nameController = TextEditingController();
  TextEditingController priceController = TextEditingController();
}

class Step2Form extends StatefulWidget {
  const Step2Form({super.key});

  @override
  State<Step2Form> createState() => Step2FormState();
}

class Step2FormState extends State<Step2Form> {
  final TextEditingController kategoriController = TextEditingController();
  List<String> selectedCategoryIds = [];
  List<String> selectedDays = [];
  Map<String, List<LayananItem>> layananPerCategory = {};

  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: '',
    decimalDigits: 0,
  );

  final List<String> days = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

  //validasi
  bool isCategoryError = false;
  bool isDayError = false;
  bool isTimeError = false;
  bool isImageError = false;
  //end

  bool isJamBukaSelected = false;
  bool isJamTutupSelected = false;

  final TextEditingController jamBukaController = TextEditingController();
  final TextEditingController jamTutupController = TextEditingController();
  Future<void> pickTime(TextEditingController controller) async {
    TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (picked != null) {
      // ignore: use_build_context_synchronously
      controller.text = picked.format(context);
    }
  }

  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();
  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        int remaining = 3 - selectedImages.length;

        if (remaining <= 0) return;

        selectedImages.addAll(images.take(remaining).map((e) => File(e.path)));
      });
    }
  }

  int getMinPrice() {
    List<int> prices = [];

    for (var list in layananPerCategory.values) {
      for (var item in list) {
        final text = item.priceController.text.replaceAll('.', '');
        if (text.isNotEmpty) {
          prices.add(int.parse(text));
        }
      }
    }

    if (prices.isEmpty) return 0;

    prices.sort();
    return prices.first;
  }

  int getMaxPrice() {
    List<int> prices = [];

    for (var list in layananPerCategory.values) {
      for (var item in list) {
        final text = item.priceController.text.replaceAll('.', '');
        if (text.isNotEmpty) {
          prices.add(int.parse(text));
        }
      }
    }

    if (prices.isEmpty) return 0;

    prices.sort();
    return prices.last;
  }

  bool validate() {
    bool isValid = true;

    if (selectedCategoryIds.isEmpty) {
      isCategoryError = true;
      isValid = false;
    }

    if (selectedDays.isEmpty) {
      isDayError = true;
      isValid = false;
    }

    if (!isJamBukaSelected ||
        !isJamTutupSelected ||
        jamBukaController.text.isEmpty ||
        jamTutupController.text.isEmpty) {
      isTimeError = true;
      isValid = false;
    }

    if (selectedImages.length < 3) {
      isImageError = true;
      isValid = false;
    }

    setState(() {});

    return isValid;
  }

  @override
  void dispose() {
    jamBukaController.dispose();
    jamTutupController.dispose();

    for (var list in layananPerCategory.values) {
      for (var item in list) {
        item.nameController.dispose();
        item.priceController.dispose();
      }
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ============================= KATEGORI JASA ======================================//
        const Text(
          "Kategori Jasa",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(
              color: isCategoryError ? Colors.red : Colors.grey.shade400,
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: selectedCategoryIds.isEmpty
                    ? const Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "pilih kategori jasa",
                          style: TextStyle(color: Colors.grey),
                        ),
                      )
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: selectedCategoryIds.map((id) {
                            final category = demoCategories.firstWhere(
                              (c) => c.id == id,
                            );

                            return Padding(
                              padding: const EdgeInsets.only(right: 6),
                              child: Chip(
                                label: Text(category.name),
                                // ignore: deprecated_member_use
                                backgroundColor: Colors.blue.withOpacity(0.1),
                                labelStyle: const TextStyle(color: Colors.blue),
                                deleteIcon: const Icon(Icons.close, size: 18),
                                onDeleted: () {
                                  setState(() {
                                    selectedCategoryIds.remove(id);
                                  });
                                },
                              ),
                            );
                          }).toList(),
                        ),
                      ),
              ),
              const Padding(
                padding: EdgeInsets.all(12),
                child: FaIcon(FontAwesomeIcons.penToSquare, size: 20),
              ),
            ],
          ),
        ),

        if (isCategoryError)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              "Minimal pilih 1 kategori",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 15),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: demoCategories.map((category) {
            final isSelected = selectedCategoryIds.contains(category.id);

            return GestureDetector(
              onTap: () {
                setState(() {
                  isCategoryError = false;
                  if (isSelected) {
                    selectedCategoryIds.remove(category.id);

                    final removed = layananPerCategory[category.id];
                    if (removed != null) {
                      for (var item in removed) {
                        item.nameController.dispose();
                        item.priceController.dispose();
                      }
                    }

                    layananPerCategory.remove(category.id);
                  } else {
                    selectedCategoryIds.add(category.id);
                    layananPerCategory[category.id] = [LayananItem()];
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      // ignore: deprecated_member_use
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? Colors.blue : Colors.grey.shade400,
                  ),
                ),
                child: Text(
                  category.name,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 15),
        //
        //
        //
        //
        //
        // ================================== LAYANAN JASA ==================================//
        const Text(
          "Layanan Jasa",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        selectedCategoryIds.isEmpty
            ? Container(
                width: double.infinity,
                padding: const EdgeInsets.all(5),

                child: const Text(
                  "Pilih kategori terlebih dahulu untuk menambahkan layanan",
                  style: TextStyle(color: Colors.grey),
                ),
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: selectedCategoryIds.map((catId) {
                  final category = demoCategories.firstWhere(
                    (c) => c.id == catId,
                  );
                  final layananList = layananPerCategory[catId]!;

                  return Container(
                    margin: const EdgeInsets.only(bottom: 15),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.shade300),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text(
                              "Kategori Jasa : ",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                // ignore: deprecated_member_use
                                color: Colors.blue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.blue),
                              ),
                              child: Text(
                                category.name,
                                style: const TextStyle(
                                  color: Colors.blue,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        ...layananList.asMap().entries.map((entry) {
                          int index = entry.key;
                          LayananItem item = entry.value;

                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  child: TextField(
                                    controller: item.nameController,
                                    decoration: InputDecoration(
                                      hintText: "Misal: Service AC",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                      ),
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 10),

                                SizedBox(
                                  width: 120,
                                  child: TextField(
                                    controller: item.priceController,
                                    keyboardType: TextInputType.number,
                                    inputFormatters: [CurrencyInputFormatter()],
                                    onChanged: (_) {
                                      setState(() {});
                                    },
                                    decoration: InputDecoration(
                                      hintText: "Harga",
                                      hintStyle: TextStyle(
                                        color: Colors.grey.shade500,
                                      ),
                                      prefixText: "Rp ",
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),

                                const SizedBox(width: 5),

                                if (layananList.length > 1)
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        layananList.removeAt(index);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.remove_circle,
                                      color: Colors.red,
                                    ),
                                  ),
                              ],
                            ),
                          );
                        }),

                        GestureDetector(
                          onTap: () {
                            setState(() {
                              layananList.add(LayananItem());
                            });
                          },
                          child: const Row(
                            children: [
                              Icon(Icons.add, color: Colors.blue),
                              SizedBox(width: 5),
                              Text(
                                "Tambah layanan",
                                style: TextStyle(color: Colors.blue),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
              ),
        const SizedBox(height: 15),
        //
        //
        //
        //
        //
        //
        //
        // ============================== HARI OPERASIONAL ================================//
        const Text(
          "Hari Operasional",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: days.map((day) {
            final isSelected = selectedDays.contains(day);

            return GestureDetector(
              onTap: () {
                setState(() {
                  isDayError = false;
                  if (isSelected) {
                    selectedDays.remove(day);
                  } else {
                    selectedDays.add(day);
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 18,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: isSelected
                      // ignore: deprecated_member_use
                      ? Colors.blue.withOpacity(0.1)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isDayError
                        ? Colors.red
                        : isSelected
                        ? Colors.blue
                        : Colors.grey.shade400,
                  ),
                ),
                child: Text(
                  day,
                  style: TextStyle(
                    color: isSelected ? Colors.blue : Colors.black,
                    fontWeight: isSelected
                        ? FontWeight.bold
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        if (isDayError)
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Text(
              "Pilih minimal 1 hari operasional",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 15),
        //
        //
        //
        //
        //
        // ==================================== JAM OPERASIONAL ============================//
        const Text(
          "Jam Operasional",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: [
            _buildJamChip(
              label: "Jam Buka",
              isSelected: isJamBukaSelected,
              isError: isTimeError && !isJamBukaSelected,
              onTap: () {
                setState(() {
                  isTimeError = false;
                  isJamBukaSelected = !isJamBukaSelected;
                });
              },
            ),
            _buildJamChip(
              label: "Jam Tutup",
              isSelected: isJamTutupSelected,
              isError: isTimeError && !isJamTutupSelected,
              onTap: () {
                setState(() {
                  isTimeError = false;
                  isJamTutupSelected = !isJamTutupSelected;
                });
              },
            ),
          ],
        ),
        const SizedBox(height: 15),

        if (isJamBukaSelected)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: TextField(
              controller: jamBukaController,
              readOnly: true,
              onTap: () => pickTime(jamBukaController),
              decoration: InputDecoration(
                hintText: "Pilih Jam Buka",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isTimeError ? Colors.red : Colors.grey,
                  ),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(
                    color: isTimeError ? Colors.red : Colors.grey,
                  ),
                ),
                suffixIcon: const Icon(Icons.access_time),
              ),
            ),
          ),
        if (isJamTutupSelected)
          TextField(
            controller: jamTutupController,
            readOnly: true,
            onTap: () => pickTime(jamTutupController),
            decoration: InputDecoration(
              hintText: "Pilih Jam Tutup",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isTimeError ? Colors.red : Colors.grey,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
                borderSide: BorderSide(
                  color: isTimeError ? Colors.red : Colors.grey,
                ),
              ),
              suffixIcon: const Icon(Icons.access_time),
            ),
          ),
        if (isTimeError)
          Padding(
            padding: const EdgeInsets.only(top: 6, left: 4),
            child: Text(
              !isJamBukaSelected && !isJamTutupSelected
                  ? "Pilih jam buka dan jam tutup"
                  : (isJamBukaSelected ^ isJamTutupSelected)
                  ? "Lengkapi jam operasional (buka & tutup)"
                  : "Isi jam buka dan jam tutup",
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        const SizedBox(height: 15),
        //
        //
        //
        //
        //
        //
        //
        //
        // =============================== TARIF LAYANAN ======================================//
        const Text(
          "Tarif Mulai Dari",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.grey.shade100,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.shade300),
          ),
          child: Text(
            getMinPrice() == 0 && getMaxPrice() == 0
                ? "Harga akan muncul otomatis"
                : getMinPrice() == getMaxPrice()
                ? "Rp ${formatter.format(getMinPrice())}"
                : "Rp ${formatter.format(getMinPrice())} - Rp ${formatter.format(getMaxPrice())}",
            style: TextStyle(
              fontSize: 14,
              color: getMinPrice() == 0 ? Colors.grey : Colors.black,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        const SizedBox(height: 15),
        //
        //
        //
        //
        //
        //
        //
        // ============================ GALERRY FOTO =================================//
        const Text(
          "Tambah Galeri",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        GestureDetector(
          onTap: () {
            if (selectedImages.length >= 3) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Maksimal 3 gambar")),
              );
              return;
            }
            setState(() {
              isImageError = false;
            });
            pickImages();
          },
          child: Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(
                color: isImageError ? Colors.red : Colors.grey.shade400,
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: selectedImages.isEmpty
                ? const Center(
                    child: Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 40,
                      color: Colors.grey,
                    ),
                  )
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: selectedImages.length,
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(right: 10),
                            width: 100,
                            height: 100,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: DecorationImage(
                                image: FileImage(selectedImages[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),

                          Positioned(
                            top: 5,
                            right: 15,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  selectedImages.removeAt(index);
                                  if (selectedImages.length < 3) {
                                    isImageError = true;
                                  } else {
                                    isImageError = false;
                                  }
                                });
                              },
                              child: Container(
                                decoration: const BoxDecoration(
                                  color: Colors.black54,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.close,
                                  size: 18,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
          ),
        ),
        if (isImageError)
          const Padding(
            padding: EdgeInsets.only(top: 6, left: 4),
            child: Text(
              "Wajib memasukkan 3 gambar",
              style: TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
        // ====================================== END =====================================//
      ],
    );
  }

  Widget _buildJamChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required bool isError,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 10),
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: isSelected ? Colors.blue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isError
                ? Colors.red
                : isSelected
                ? Colors.blue
                : Colors.grey.shade400,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.blue : Colors.black,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
