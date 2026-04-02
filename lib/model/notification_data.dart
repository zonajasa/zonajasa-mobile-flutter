import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

class NotificationModel {
  final String id;
  final String type; // order, promotion, general
  final String status; // detail kondisi
  final String title;
  final String message;
  final String time;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.status,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });

  /// ================= ICON =================
  Object get icon {
    switch (type) {
      case 'order':
        switch (status) {
          case 'delivered':
            return HugeIcons.strokeRoundedPackageDelivered;
          case 'on_the_way':
            return HugeIcons.strokeRoundedTruck;
          default:
            return HugeIcons.strokeRoundedPackage;
        }

      case 'promotion':
        switch (status) {
          case 'flash_sale':
            return HugeIcons.strokeRoundedDiscount;
          case 'new_arrival':
            return HugeIcons.strokeRoundedNewReleases;
          default:
            return HugeIcons.strokeRoundedDiscount;
        }

      case 'general':
        return HugeIcons.strokeRoundedGift;

      default:
        return Icons.notifications;
    }
  }

  /// ================= COLOR =================
  Color get color {
    switch (type) {
      case 'order':
        switch (status) {
          case 'delivered':
            return Colors.green;
          case 'on_the_way':
            return Colors.orange;
          default:
            return Colors.blue;
        }

      case 'promotion':
        return Colors.purple;

      case 'general':
        return Colors.blue;

      default:
        return Colors.grey;
    }
  }
}

/// ================= DATA DUMMY =================
final List<NotificationModel> notifications = [
  NotificationModel(
    id: '1',
    type: 'order',
    status: 'delivered',
    title: 'Order Delivered',
    message: 'Pesanan kamu sudah selesai',
    time: '2 jam lalu',
    isRead: false,
  ),
  NotificationModel(
    id: '2',
    type: 'promotion',
    status: 'flash_sale',
    title: 'Flash Sale!',
    message: 'Diskon sampai 70%',
    time: '4 jam lalu',
    isRead: false,
  ),
  NotificationModel(
    id: '3',
    type: 'order',
    status: 'on_the_way',
    title: 'Teknisi menuju lokasi',
    message: 'Pesanan sedang di perjalanan',
    time: '1 hari lalu',
    isRead: true,
  ),
  NotificationModel(
    id: '4',
    type: 'general',
    status: 'welcome',
    title: 'Selamat datang',
    message: 'Terima kasih sudah bergabung',
    time: '2 hari lalu',
    isRead: true,
  ),
  NotificationModel(
    id: '5',
    type: 'promotion',
    status: 'new_arrival',
    title: 'Produk Baru',
    message: 'Cek produk terbaru sekarang',
    time: '3 hari lalu',
    isRead: true,
  ),
];

/// ================= HELPER =================
int getUnreadCount() {
  return notifications.where((n) => !n.isRead).length;
}

ValueNotifier<int> unreadCountNotifier =
    ValueNotifier(notifications.where((n) => !n.isRead).length);