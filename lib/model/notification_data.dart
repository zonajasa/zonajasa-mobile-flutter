import 'package:flutter/material.dart';

class NotificationModel {
  final String id;
  final String type; // order, promotion, general
  final String title;
  final String message;
  final String time;
  bool isRead;

  NotificationModel({
    required this.id,
    required this.type,
    required this.title,
    required this.message,
    required this.time,
    required this.isRead,
  });
}

/// 🔥 DATA DUMMY (sementara)
final List<NotificationModel> notifications = [
  NotificationModel(
    id: '1',
    type: 'order',
    title: 'Order Delivered',
    message: 'Your order #ORD-001 has been delivered successfully',
    time: '2 hours ago',
    isRead: false,
  ),
  NotificationModel(
    id: '2',
    type: 'promotion',
    title: 'Flash Sale Started!',
    message: 'Up to 70% off on electronics. Limited time offer!',
    time: '4 hours ago',
    isRead: false,
  ),
  NotificationModel(
    id: '3',
    type: 'order',
    title: 'Order Shipped',
    message: 'Your order #ORD-002 is on its way. Track your package.',
    time: '1 day ago',
    isRead: true,
  ),
  NotificationModel(
    id: '4',
    type: 'general',
    title: 'Welcome to Como!',
    message: 'Thank you for joining Como. Enjoy shopping with us!',
    time: '2 days ago',
    isRead: true,
  ),
  NotificationModel(
    id: '5',
    type: 'promotion',
    title: 'New Arrivals',
    message: 'Check out the latest products in fashion category',
    time: '3 days ago',
    isRead: true,
  ),
];

/// 🔥 HELPER GLOBAL (biar gampang dipakai di mana aja)
int getUnreadCount() {
  return notifications.where((n) => !n.isRead).length;
}
