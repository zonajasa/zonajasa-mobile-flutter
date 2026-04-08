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

class Step2Form extends StatefulWidget {
  const Step2Form({super.key});

  @override
  State<Step2Form> createState() => _Step2FormState();
}

class _Step2FormState extends State<Step2Form> {
  final TextEditingController kategoriController = TextEditingController();
  List<String> selectedCategoryIds = [];
  List<String> selectedDays = [];

  final List<String> days = [
    "Senin",
    "Selasa",
    "Rabu",
    "Kamis",
    "Jumat",
    "Sabtu",
    "Minggu",
  ];

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

  final TextEditingController minHargaController = TextEditingController();
  final TextEditingController maxHargaController = TextEditingController();

  List<File> selectedImages = [];
  final ImagePicker picker = ImagePicker();
  Future<void> pickImages() async {
    final List<XFile> images = await picker.pickMultiImage();

    if (images.isNotEmpty) {
      setState(() {
        selectedImages.addAll(images.map((e) => File(e.path)));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Data Jasa",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          height: 56,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey.shade400),
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

        const SizedBox(height: 15),

        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: demoCategories.map((category) {
            final isSelected = selectedCategoryIds.contains(category.id);

            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    selectedCategoryIds.remove(category.id);
                  } else {
                    selectedCategoryIds.add(category.id);
                  }

                  kategoriController.text = demoCategories
                      .where((cat) => selectedCategoryIds.contains(cat.id))
                      .map((cat) => cat.name)
                      .join(", ");
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
        // =========================================================================//
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
                    color: isSelected ? Colors.blue : Colors.grey.shade400,
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
        const SizedBox(height: 15),
        // ========================================================================//
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
              onTap: () {
                setState(() {
                  isJamBukaSelected = !isJamBukaSelected;
                });
              },
            ),
            _buildJamChip(
              label: "Jam Tutup",
              isSelected: isJamTutupSelected,
              onTap: () {
                setState(() {
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
              ),
              suffixIcon: const Icon(Icons.access_time),
            ),
          ),
        const SizedBox(height: 15),
        // =========================================================================//
        const Text(
          "Tarif Mulai Dari",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        Row(
          children: [
            /// MIN
            Expanded(
              child: TextField(
                controller: minHargaController,
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyInputFormatter()],
                decoration: InputDecoration(
                  hintText: "Tarif Min",
                  prefixText: "Rp ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text("-"),
            ),

            /// MAX
            Expanded(
              child: TextField(
                controller: maxHargaController,
                keyboardType: TextInputType.number,
                inputFormatters: [CurrencyInputFormatter()],
                decoration: InputDecoration(
                  hintText: "Tarif Max",
                  prefixText: "Rp ",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 15),
        // ===============================================================================//
        const Text(
          "Tambah Galeri",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 15),

        GestureDetector(
          onTap: pickImages,
          child: Container(
            width: double.infinity,
            height: 120,
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
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
        // ============================================================================//
      ],
    );
  }

  Widget _buildJamChip({
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
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
            color: isSelected ? Colors.blue : Colors.grey.shade400,
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
