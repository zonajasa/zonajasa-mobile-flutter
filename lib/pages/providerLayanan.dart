import 'package:flutter/material.dart';
import 'package:jasa_app/model/layanan_jasa.dart';
import 'package:jasa_app/model/service.dart';

class Providerlayanan extends StatelessWidget {
  final Service service;
  final String categoryId;
  
  const Providerlayanan({
    super.key,
    required this.service,
    required this.categoryId,
  });

  @override
  Widget build(BuildContext context) {
    final layanan = demoLayananJasa
        .where((l) => l.serviceId == service.id)
        .toList();
    return Container();
  }
}
