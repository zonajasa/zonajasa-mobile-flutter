import 'package:flutter/material.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jasa_app/core/constants/app_constants.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';

class Notifikasiscreen extends StatefulWidget {
  const Notifikasiscreen({super.key});

  @override
  State<Notifikasiscreen> createState() => _NotifikasiscreenState();
}

class _NotifikasiscreenState extends State<Notifikasiscreen> {
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'type': 'order',
      'title': 'Order Delivered',
      'message': 'Your order #ORD-001 has been delivered successfully',
      'time': '2 hours ago',
      'isRead': false,
      'icon': HugeIcons.strokeRoundedPackageDelivered,
      'color': AppColors.success,
    },
    {
      'id': '2',
      'type': 'promotion',
      'title': 'Flash Sale Started!',
      'message': 'Up to 70% off on electronics. Limited time offer!',
      'time': '4 hours ago',
      'isRead': false,
      'icon': HugeIcons.strokeRoundedDiscount,
      'color': AppColors.secondary,
    },
    {
      'id': '3',
      'type': 'order',
      'title': 'Order Shipped',
      'message': 'Your order #ORD-002 is on its way. Track your package.',
      'time': '1 day ago',
      'isRead': true,
      'icon': HugeIcons.strokeRoundedTruck,
      'color': AppColors.info,
    },
    {
      'id': '4',
      'type': 'general',
      'title': 'Welcome to Como!',
      'message': 'Thank you for joining Como. Enjoy shopping with us!',
      'time': '2 days ago',
      'isRead': true,
      'icon': HugeIcons.strokeRoundedGift,
      'color': AppColors.primary,
    },
    {
      'id': '5',
      'type': 'promotion',
      'title': 'New Arrivals',
      'message': 'Check out the latest products in fashion category',
      'time': '3 days ago',
      'isRead': true,
      'icon': HugeIcons.strokeRoundedNewReleases,
      'color': AppColors.accent,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
    );
  }

  // ============================== UNTUK BAGIAN APP BAR NYA ================================== //
  AppBar _buildAppBar() {
    final unreadCount = _notifications.where((n) => !n['isRead']).length;

    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: Text('Notifications', style: AppTextStyles.titleLarges),
      actions: [
        if (unreadCount > 0)
          TextButton(
            onPressed: _markAllAsRead,
            child: Text(
              'Tandai semua dibaca',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.primary,
              ),
            ),
          ),
        PopupMenuButton<String>(
          onSelected: _handleMenuAction,
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'settings',
              child: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedSettings02,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  SizedBox(width: AppConstants.paddingS),
                  Text('Notification Settings'),
                ],
              ),
            ),
            const PopupMenuItem(
              value: 'clear',
              child: Row(
                children: [
                  HugeIcon(
                    icon: HugeIcons.strokeRoundedDelete02,
                    size: 16,
                    color: AppColors.error,
                  ),
                  SizedBox(width: AppConstants.paddingS),
                  Text('Hapus Semua'),
                ],
              ),
            ),
          ],
          child: Padding(
            padding: EdgeInsets.all(AppConstants.paddingS),
            child: HugeIcon(
              icon: HugeIcons.strokeRoundedMoreVertical,
              color: AppColors.textSecondary,
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  // ================================ KALAU BERHASIL DI BACA SEMUA ==============================//
  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['isRead'] = true;
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Semua pemberitahuan yang ditandai sebagai sudah dibaca'),
      ),
    );
  }

  //================================= HEANDLE MENU MORE VERTIKAL ================================//
  void _handleMenuAction(String action) {
    switch (action) {
      case 'settings':
        _showNotificationSettings();
        break;
      case 'clear':
        _showClearAllDialog();
        break;
    }
  }

  // ================================ PENGATURAN NOTIFIKASI =======================================//
  void _showNotificationSettings() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppConstants.radiusL),
        ),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(AppConstants.paddingL),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  'Pengaturan Pemberitahuan',
                  style: AppTextStyles.titleLarge,
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const HugeIcon(
                    icon: HugeIcons.strokeRoundedCancel01,
                    color: AppColors.textSecondary,
                    size: 24,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppConstants.paddingL),
            _buildSettingTile(
              'Order Updates',
              'Get notified about order status changes',
              true,
            ),
            _buildSettingTile(
              'Promotions & Offers',
              'Receive notifications about sales and offers',
              true,
            ),
            _buildSettingTile(
              'New Products',
              'Get notified about new arrivals',
              false,
            ),
            _buildSettingTile(
              'Price Drops',
              'Receive alerts when prices drop on wishlisted items',
              true,
            ),
            const SizedBox(height: AppConstants.paddingL),
          ],
        ),
      ),
    );
  }

  // ================================== ISI DALAM PENGATURAN NOTIFIKASI =================================//
  Widget _buildSettingTile(String title, String subtitle, bool initialValue) {
    return SwitchListTile(
      title: Text(title, style: AppTextStyles.bodyMedium),
      subtitle: Text(
        subtitle,
        style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
      ),
      value: initialValue,
      onChanged: (value) {
        // Handle setting change
      },
      // ignore: deprecated_member_use
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }

  // ===================================== PENGATURAN HAPUS NOTIFIKASI ================================//
  void _showClearAllDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Hapus Semua Pemberitahuan',
          style: AppTextStyles.titleMedium,
        ),
        content: Text(
          'Apakah Anda yakin ingin menghapus semua notifikasi? Tindakan ini tidak dapat dibatalkan.',
          style: AppTextStyles.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Batal',
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _notifications.clear();
              });

              Navigator.pop(context);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Semua notifikasi dihapus')),
              );
            },
            child: Text(
              'Hapus Semua',
              style: AppTextStyles.labelMedium.copyWith(color: AppColors.error),
            ),
          ),
        ],
      ),
    );
  }

  //========================================
}
