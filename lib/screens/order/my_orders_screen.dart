// شاشة طلباتي
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';

class MyOrdersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _orders = [
    {
      'id': '#1234',
      'title': 'آيفون 14 برو ماكس',
      'price': 350000,
      'status': 'delivered',
      'statusText': 'تم التوصيل',
      'date': '2024-01-15',
      'image': null,
    },
    {
      'id': '#1235',
      'title': 'لابتوب Dell XPS 15',
      'price': 280000,
      'status': 'shipped',
      'statusText': 'تم الشحن',
      'date': '2024-01-14',
      'image': null,
    },
    {
      'id': '#1236',
      'title': 'سماعات AirPods Pro',
      'price': 45000,
      'status': 'processing',
      'statusText': 'قيد المعالجة',
      'date': '2024-01-13',
      'image': null,
    },
    {
      'id': '#1237',
      'title': 'ساعة Apple Watch',
      'price': 75000,
      'status': 'pending',
      'statusText': 'قيد الانتظار',
      'date': '2024-01-12',
      'image': null,
    },
  ];

  Color _getStatusColor(String status) {
    switch (status) {
      case 'delivered':
        return Colors.green;
      case 'shipped':
        return Colors.blue;
      case 'processing':
        return Colors.orange;
      case 'pending':
        return Colors.grey;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        appBar: CustomAppBar(
          title: 'طلباتي',
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppTheme.goldPrimary,
            unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
            indicatorColor: AppTheme.goldPrimary,
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'قيد الانتظار'),
              Tab(text: 'قيد التنفيذ'),
              Tab(text: 'مكتملة'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersList(_orders),
            _buildOrdersList(_orders.where((o) => o['status'] == 'pending').toList()),
            _buildOrdersList(_orders.where((o) => ['processing', 'shipped'].contains(o['status'])).toList()),
            _buildOrdersList(_orders.where((o) => o['status'] == 'delivered').toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(List<Map<String, dynamic>> orders) {
    if (orders.isEmpty) {
      return EmptyOrders(
        onShop: () {
          Navigator.pop(context);
        },
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(order, index);
      },
    );
  }

  Widget _buildOrderCard(Map<String, dynamic> order, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          // Header
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  order['id'],
                  style: TextStyle(
                    fontFamily: 'Changa',
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.goldPrimary,
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: _getStatusColor(order['status']).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    order['statusText'],
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: _getStatusColor(order['status']),
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          Divider(height: 1),
          
          // Content
          Padding(
            padding: EdgeInsets.all(16),
            child: Row(
              children: [
                // Image
                Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkCard : Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.image,
                    color: isDark ? Colors.white24 : Colors.black12,
                  ),
                ),
                SizedBox(width: 16),
                
                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['title'],
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppTheme.lightText,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '${order['price'].toStringAsFixed(0)} ر.ي',
                        style: TextStyle(
                          fontFamily: 'Changa',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        order['date'],
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 12,
                          color: isDark ? Colors.white54 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Actions
          if (order['status'] == 'pending')
            Padding(
              padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {},
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppTheme.error,
                        side: BorderSide(color: AppTheme.error),
                      ),
                      child: Text('إلغاء'),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.goldPrimary,
                      ),
                      child: Text('تتبع'),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    ).animate()
     .fadeIn(delay: (index * 100).ms)
     .slideX(begin: 0.2, end: 0);
  }
}
