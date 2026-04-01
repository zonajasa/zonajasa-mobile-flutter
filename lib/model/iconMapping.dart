import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';

Object getIconByType(String type) {
  switch (type) {
    case 'order':
      return HugeIcons.strokeRoundedPackageDelivered;
    case 'promotion':
      return HugeIcons.strokeRoundedDiscount;
    case 'general':
      return HugeIcons.strokeRoundedNotification;
    default:
      return Icons.notifications;
  }
}