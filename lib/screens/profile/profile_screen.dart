// شاشة الملف الشخصي
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../settings/settings_screen.dart';
import '../order/my_orders_screen.dart';
import '../product/favorites_screen.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.currentUser;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: CustomAppBar(
        title: 'حسابي',
        actions: [
          IconButton(
            icon: Icon(Icons.settings_outlined),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SettingsScreen()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // صورة الغلاف والصورة الشخصية
            _buildProfileHeader(context, user),
            
            SizedBox(height: 20),
            
            // الإحصائيات
            _buildStatsRow(),
            
            SizedBox(height: 24),
            
            // القائمة
            _buildMenuList(context),
            
            SizedBox(height: 24),
            
            // زر تسجيل الخروج
            if (authProvider.isAuthenticated)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: OutlinedButton.icon(
                  onPressed: () => _showLogoutDialog(context),
                  icon: Icon(Icons.logout, color: AppTheme.error),
                  label: Text(
                    'تسجيل الخروج',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      color: AppTheme.error,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50),
                    side: BorderSide(color: AppTheme.error),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context, dynamic user) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        // صورة الغلاف
        Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
          ),
          child: Stack(
            children: [
              // الدوائر الزخرفية
              Positioned(
                right: -50,
                top: -50,
                child: Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ),
        
        // الصورة الشخصية
        Positioned(
          top: 120,
          right: 0,
          left: 0,
          child: Center(
            child: Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: isDark ? AppTheme.darkSurface : Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isDark ? AppTheme.darkSurface : Colors.white,
                      width: 4,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: ClipOval(
                    child: user?.avatarUrl != null
                        ? Image.network(
                            user.avatarUrl,
                            fit: BoxFit.cover,
                          )
                        : Center(
                            child: Text(
                              user?.fullName?.substring(0, 1) ?? 'U',
                              style: TextStyle(
                                fontFamily: 'Changa',
                                fontSize: 48,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.goldPrimary,
                              ),
                            ),
                          ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  user?.fullName ?? 'المستخدم',
                  style: TextStyle(
                    fontFamily: 'Changa',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.lightText,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ),
                if (user?.city != null) ...[
                  SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.location_on,
                        size: 14,
                        color: AppTheme.goldPrimary,
                      ),
                      SizedBox(width: 4),
                      Text(
                        user.city,
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 13,
                          color: isDark ? Colors.white60 : Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
        
        // زر تعديل
        Positioned(
          top: 200,
          right: MediaQuery.of(context).size.width / 2 - 60,
          child: GestureDetector(
            onTap: () {
              // TODO: تعديل الصورة
            },
            child: Container(
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.camera_alt,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildStatsRow() {
    final stats = [
      {'value': '12', 'label': 'إعلانات'},
      {'value': '48', 'label': 'متابعين'},
      {'value': '24', 'label': 'متابَعون'},
    ];

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      padding: EdgeInsets.symmetric(vertical: 20),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: stats.map((stat) {
          return Column(
            children: [
              Text(
                stat['value']!,
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                stat['label']!,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 13,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          );
        }).toList(),
      ),
    ).animate()
     .fadeIn(duration: 500.ms)
     .slideY(begin: 0.2, end: 0);
  }

  Widget _buildMenuList(BuildContext context) {
    final menuItems = [
      {
        'icon': Icons.inventory_2_outlined,
        'title': 'إعلاناتي',
        'subtitle': 'إدارة منتجاتك المعروضة',
        'onTap': () {},
      },
      {
        'icon': Icons.favorite_border,
        'title': 'المفضلة',
        'subtitle': 'المنتجات المحفوظة',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FavoritesScreen()),
          );
        },
      },
      {
        'icon': Icons.shopping_bag_outlined,
        'title': 'طلباتي',
        'subtitle': 'متابعة حالة الطلبات',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MyOrdersScreen()),
          );
        },
      },
      {
        'icon': Icons.person_outline,
        'title': 'معلومات الحساب',
        'subtitle': 'تعديل بياناتك الشخصية',
        'onTap': () {},
      },
      {
        'icon': Icons.settings_outlined,
        'title': 'الإعدادات',
        'subtitle': 'تخصيص التطبيق',
        'onTap': () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SettingsScreen()),
          );
        },
      },
      {
        'icon': Icons.help_outline,
        'title': 'المساعدة والدعم',
        'subtitle': 'الأسئلة الشائعة والتواصل',
        'onTap': () {},
      },
    ];

    return Column(
      children: menuItems.asMap().entries.map((entry) {
        final index = entry.key;
        final item = entry.value;

        return ListTile(
          leading: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.goldPrimary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              item['icon'] as IconData,
              color: AppTheme.goldPrimary,
            ),
          ),
          title: Text(
            item['title'] as String,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            item['subtitle'] as String,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
            ),
          ),
          trailing: Icon(
            Icons.arrow_back_ios,
            size: 16,
            color: AppTheme.goldPrimary,
          ),
          onTap: item['onTap'] as VoidCallback?,
        ).animate()
         .fadeIn(delay: (index * 100).ms)
         .slideX(begin: 0.2, end: 0);
      }).toList(),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'تسجيل الخروج',
          style: TextStyle(
            fontFamily: 'Changa',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'هل أنت متأكد من رغبتك في تسجيل الخروج؟',
          style: TextStyle(
            fontFamily: 'Tajawal',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'إلغاء',
              style: TextStyle(
                fontFamily: 'Tajawal',
                color: Colors.grey,
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.read<AuthProvider>().signOut();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.error,
            ),
            child: Text(
              'تسجيل الخروج',
              style: TextStyle(
                fontFamily: 'Tajawal',
              ),
            ),
          ),
        ],
      ),
    );
  }
}
