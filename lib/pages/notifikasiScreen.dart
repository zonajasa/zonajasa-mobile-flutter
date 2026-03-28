import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:jasa_app/model/app_colors.dart';
import 'package:jasa_app/model/app_text_styles.dart';
import '../../core/constants/app_constants.dart';

class Notifikasiscreen extends StatefulWidget {
  const Notifikasiscreen({super.key});

  @override
  State<Notifikasiscreen> createState() => _NotifikasiscreenState();
}

class _NotifikasiscreenState extends State<Notifikasiscreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

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
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  // ignore: prefer_final_fields, unused_field
  Map<String, bool> _settings = {
    'order': true,
    'promo': true,
    'new': false,
    'price': true,
  };
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: Column(
        children: [
          _buildTabBar(),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildNotificationsList(_notifications),
                _buildNotificationsList(
                  _notifications.where((n) => n['type'] == 'Pesanan').toList(),
                ),
                _buildNotificationsList(
                  _notifications.where((n) => n['type'] == 'Promosi').toList(),
                ),
                _buildNotificationsList(
                  _notifications.where((n) => n['type'] == 'general').toList(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.white,
      elevation: 0,
      title: Text('Notifications', style: AppTextStyles.titleLarge),
    );
  }

  // =========================== MENU TAB BAR ====================================================//
  Widget _buildTabBar() {
    return Container(
      color: AppColors.white,
      child: TabBar(
        controller: _tabController,
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.textSecondary,
        labelStyle: AppTextStyles.labelMedium,
        unselectedLabelStyle: AppTextStyles.labelMedium,
        indicatorColor: AppColors.primary,
        indicatorWeight: 2,
        tabs: [
          Tab(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Semua'),
                const SizedBox(width: AppConstants.paddingXS),
                if (_notifications.where((n) => !n['isRead']).isNotEmpty)
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: AppColors.error,
                      shape: BoxShape.circle,
                    ),
                    child: Text(
                      '${_notifications.where((n) => !n['isRead']).length}',
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.white,
                        fontSize: 10,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const Tab(text: 'Pesanan'),
          const Tab(text: 'Promosi'),
          const Tab(text: 'General'),
        ],
      ),
    );
  }

  Widget _buildNotificationsList(List<Map<String, dynamic>> notifications) {
    if (notifications.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(AppConstants.paddingM),
      itemCount: notifications.length,
      itemBuilder: (context, index) {
        final notification = notifications[index];
        return _buildNotificationCard(notification);
      },
    );
  }

  // ====================== NOTIFIKASI KALAU TIDAK ADA/ KOSONG ===========================================//
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppConstants.paddingXL),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FaIcon(
              FontAwesomeIcons.bell,
              size: 80,
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppConstants.paddingL),
            Text(
              'Tidak ada pemberitahuan',
              style: AppTextStyles.titleLarge.copyWith(
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: AppConstants.paddingM),
            Text(
              'Kamu sudah mengikuti semua perkembangannya! Silakan cek kembali nanti untuk pembaruan.',
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // ==================================== DATA NOTIFIKASI ===========================================//
  Widget _buildNotificationCard(Map<String, dynamic> notification) {
    return Dismissible(
      key: Key(notification['id']),
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: AppConstants.paddingL),
        margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
        decoration: BoxDecoration(
          color: AppColors.error,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
        ),
        child: const HugeIcon(
          icon: HugeIcons.strokeRoundedDelete02,
          color: AppColors.white,
          size: 24,
        ),
      ),
      onDismissed: (direction) {
        _deleteNotification(notification['id']);
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: AppConstants.paddingM),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          border: notification['isRead']
              ? null
              // ignore: deprecated_member_use
              : Border.all(color: AppColors.primary.withOpacity(0.3), width: 1),
          boxShadow: const [
            BoxShadow(
              color: AppColors.shadow,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: InkWell(
          onTap: () => _markAsRead(notification['id']),
          borderRadius: BorderRadius.circular(AppConstants.radiusM),
          child: Padding(
            padding: const EdgeInsets.all(AppConstants.paddingM),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(AppConstants.paddingS),
                  decoration: BoxDecoration(
                    color: notification['color'].withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.radiusS),
                  ),
                  child: HugeIcon(
                    icon: notification['icon'],
                    color: notification['color'],
                    size: 20,
                  ),
                ),
                const SizedBox(width: AppConstants.paddingM),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: AppTextStyles.titleSmall.copyWith(
                                fontWeight: notification['isRead']
                                    ? FontWeight.normal
                                    : FontWeight.w600,
                              ),
                            ),
                          ),
                          if (!notification['isRead'])
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                color: AppColors.primary,
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.paddingXS),
                      Text(
                        notification['message'],
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.textSecondary,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: AppConstants.paddingS),
                      Row(
                        children: [
                          HugeIcon(
                            icon: HugeIcons.strokeRoundedClock01,
                            color: AppColors.textSecondary,
                            size: 14,
                          ),
                          const SizedBox(width: AppConstants.paddingXS),
                          Text(
                            notification['time'],
                            style: AppTextStyles.bodySmall.copyWith(
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  //=================================== VOID PESAN NOTIFIKASI =======================================//

  void _markAsRead(String notificationId) {
    setState(() {
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['isRead'] = true;
      }
    });
  }

  void _deleteNotification(String notificationId) {
    setState(() {
      _notifications.removeWhere((n) => n['id'] == notificationId);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Pemberitahuan telah dihapus')),
    );
  }
}
