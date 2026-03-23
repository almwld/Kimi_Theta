// الشريط السفلي الرئيسي - التنقل بين الشاشات
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/notification_provider.dart';
import 'home_screen.dart';
import '../product/products_screen.dart';
import '../product/add_product_screen.dart';
import '../chat/chat_screen.dart';
import '../wallet/wallet_screen.dart';
import '../profile/profile_screen.dart';

class MainNavigation extends StatefulWidget {
  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    HomeScreen(),
    ProductsScreen(),
    SizedBox(), // مكان فارغ للزر العائم
    ChatScreen(),
    WalletScreen(),
    ProfileScreen(),
  ];

  final List<String> _titles = [
    'الرئيسية',
    'المتجر',
    '',
    'الدردشة',
    'المحفظة',
    'حسابي',
  ];

  final List<IconData> _icons = [
    Icons.home_outlined,
    Icons.storefront_outlined,
    Icons.add,
    Icons.chat_bubble_outline,
    Icons.account_balance_wallet_outlined,
    Icons.person_outline,
  ];

  final List<IconData> _selectedIcons = [
    Icons.home,
    Icons.storefront,
    Icons.add,
    Icons.chat_bubble,
    Icons.account_balance_wallet,
    Icons.person,
  ];

  void _onItemTapped(int index) {
    if (index == 2) {
      // الزر العائم - إضافة منتج
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => AddProductScreen()),
      );
      return;
    }

    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final notificationProvider = context.watch<NotificationProvider>();

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex > 2 ? _currentIndex - 1 : _currentIndex,
        children: [
          HomeScreen(),
          ProductsScreen(),
          ChatScreen(),
          WalletScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // الرئيسية
                _buildNavItem(0),
                
                // المتجر
                _buildNavItem(1),
                
                // الزر العائم
                _buildFloatingButton(),
                
                // الدردشة
                _buildNavItem(3, badge: notificationProvider.unreadCount),
                
                // المحفظة
                _buildNavItem(4),
                
                // حسابي
                _buildNavItem(5),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, {int badge = 0}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isSelected = _currentIndex == index;
    
    // تعديل الفهرس للشاشات بعد الزر العائم
    int adjustedIndex = index > 2 ? index - 1 : index;
    int currentAdjusted = _currentIndex > 2 ? _currentIndex - 1 : _currentIndex;
    final isActuallySelected = currentAdjusted == adjustedIndex;

    return GestureDetector(
      onTap: () => _onItemTapped(index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          gradient: isActuallySelected ? AppTheme.goldGradient : null,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Stack(
              children: [
                Icon(
                  isActuallySelected ? _selectedIcons[index] : _icons[index],
                  color: isActuallySelected
                      ? Colors.white
                      : (isDark ? Colors.white60 : Colors.black54),
                  size: 24,
                ),
                if (badge > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 14,
                      height: 14,
                      decoration: BoxDecoration(
                        color: AppTheme.error,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isActuallySelected
                              ? AppTheme.goldPrimary
                              : (isDark ? AppTheme.darkSurface : Colors.white),
                          width: 2,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(height: 4),
            Text(
              _titles[index],
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 11,
                fontWeight: isActuallySelected ? FontWeight.w600 : FontWeight.normal,
                color: isActuallySelected
                    ? Colors.white
                    : (isDark ? Colors.white60 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFloatingButton() {
    return GestureDetector(
      onTap: () => _onItemTapped(2),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          gradient: AppTheme.goldGradient,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: AppTheme.goldPrimary.withOpacity(0.4),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Icon(
          Icons.add,
          color: Colors.white,
          size: 32,
        ),
      ).animate()
       .scale(duration: 200.ms)
       .then()
       .shake(duration: 500.ms, hz: 2),
    );
  }
}
