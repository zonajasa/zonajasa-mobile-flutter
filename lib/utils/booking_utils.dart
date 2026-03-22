import 'package:flutter/material.dart';

String getStatusText(String status) {
  switch (status) {
    case "pending":
      return "Menunggu Konfirmasi";
    case "process":
      return "Sedang Diproses";
    case "on_the_way":
      return "Teknisi Menuju Lokasi";
    case "working":
      return "Sedang Dikerjakan";
    case "done":
      return "Layanan Telah Selesai";
    default:
      return "-";
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case "pending":
      return Colors.grey;
    case "process":
      return Colors.blue;
    case "on_the_way":
      return Colors.orange;
    case "working":
      return Colors.deepOrange;
    case "done":
      return Colors.green;
    default:
      return Colors.black;
  }
}
