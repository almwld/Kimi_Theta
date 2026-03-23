// شاشة الإشعارات
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';

class NotificationsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _notifications = [
    {
      'title': 'طلب جديد',
      'body': 'لديك طلب جديد من أحمد محمد',
      'time': 'منذ 5 دقائق',
      'type': 'order',
      'isRead': false,
    },
    {
      'title': 'رسالة جديدة',
      'body': 'محمد علي: هل المنتج متوفر؟',
      'time': 'منذ 30 دقيقة',
      'type': 'message',
      'isRead': false,
    },
    {
      'title': 'تم الشحن',
      'body': 'تم شحن طلبك رقم #1234',
      'time': 'منذ ساعة',
      'type': 'shipping',
      'isRead': true,
    },
    {
      'title': 'عرض خاص',
      'body': 'خصم 20% على جميع المنتجات',
      'time': 'منذ يوم',
      'type': 'promotion',
      'isRead': true,
    },
    {
      'title': 'تقييم جديد',
      'body': 'قام أحمد بتقييم منتجك بـ 5 نجوم',
      'time': 'منذ يومين',
      'type': 'review',
      'isRead': true,
    },
  ];

  IconData _getIcon(String type) {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'message':
        return Icons.message;
      case 'shipping':
        return Icons.local_shipping;
      case 'promotion':
        return Icons.local_offer;
      case 'review':
        return Icons.star;
      default:
        return Icons.notifications;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'message':
        return Colors.green;
      case 'shipping':
        return Colors.purple;
      case 'promotion':
        return Colors.orange;
      case 'review':
        return Colors.amber;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: CustomAppBar(
        title: 'الإشعارات',
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'تحديد الكل',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: AppTheme.goldPrimary,
              ),
            ),
          ),
        ],
      ),
      body: _notifications.isEmpty
          ? EmptyNotifications()
          : ListView.builder(
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationTile(
                  context,
                  notification,
                  index,
                );
              },
            ),
    );
  }

  Widget _buildNotificationTile(
    BuildContext context,
    Map<String, dynamic> notification,
    int index,
  ) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isRead = notification['isRead'] as bool;

    return Dismissible(
      key: Key('notification_$index'),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 20),
        child: Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) {},
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        decoration: BoxDecoration(
          color: isRead
              ? (isDark ? AppTheme.darkSurface : Colors.white)
              : AppTheme.goldPrimary.withOpacity(0.05),
          borderRadius: BorderRadius.circular(12),
          border: isRead
              ? null
              : Border.all(
                  color: AppTheme.goldPrimary.withOpacity(0.3),
                ),
        ),
        child: ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconColor(notification['type']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIcon(notification['type']),
              color: _getIconColor(notification['type']),
            ),
          ),
          title: Text(
            notification['title'],
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
              fontWeight: isRead ? FontWeight.normal : FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.lightText,
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                notification['body'],
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
              ),
              SizedBox(height: 4),
              Text(
                notification['time'],
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 11,
                  color: isDark ? Colors.white40 : Colors.black38,
                ),
              ),
            ],
          ),
          onTap: () {},
        ),
      ),
    ).animate()
     .fadeIn(delay: (index * 100).ms)
     .slideX(begin: 0.2, end: 0);
  }
}
