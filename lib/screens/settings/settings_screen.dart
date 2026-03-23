// شاشة الإعدادات
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/theme_provider.dart';
import '../../widgets/common/custom_app_bar.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeProvider = context.watch<ThemeProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: CustomAppBar(
        title: 'الإعدادات',
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // المظهر
            _buildSectionTitle('المظهر'),
            _buildSettingTile(
              icon: Icons.dark_mode_outlined,
              title: 'الوضع الداكن',
              subtitle: 'تفعيل الثيم الداكن',
              trailing: Switch(
                value: themeProvider.isDarkMode,
                onChanged: (value) {
                  themeProvider.setDarkMode(value);
                },
                activeColor: AppTheme.goldPrimary,
              ),
            ),
            
            // اللغة
            _buildSectionTitle('اللغة'),
            _buildSettingTile(
              icon: Icons.language,
              title: 'اللغة',
              subtitle: 'العربية',
              trailing: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: AppTheme.goldPrimary,
              ),
              onTap: () {
                // TODO: تغيير اللغة
              },
            ),
            
            // الإشعارات
            _buildSectionTitle('الإشعارات'),
            _buildSettingTile(
              icon: Icons.notifications_outlined,
              title: 'الإشعارات',
              subtitle: 'تفعيل الإشعارات',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppTheme.goldPrimary,
              ),
            ),
            _buildSettingTile(
              icon: Icons.volume_up_outlined,
              title: 'صوت الإشعارات',
              subtitle: 'تشغيل صوت عند وصول إشعار',
              trailing: Switch(
                value: true,
                onChanged: (value) {},
                activeColor: AppTheme.goldPrimary,
              ),
            ),
            
            // الأمان
            _buildSectionTitle('الأمان'),
            _buildSettingTile(
              icon: Icons.fingerprint,
              title: 'البصمة',
              subtitle: 'تسجيل الدخول بالبصمة',
              trailing: Switch(
                value: false,
                onChanged: (value) {},
                activeColor: AppTheme.goldPrimary,
              ),
            ),
            _buildSettingTile(
              icon: Icons.lock_outline,
              title: 'تغيير كلمة المرور',
              subtitle: 'تحديث كلمة المرور',
              trailing: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: AppTheme.goldPrimary,
              ),
              onTap: () {},
            ),
            
            // الدعم
            _buildSectionTitle('الدعم'),
            _buildSettingTile(
              icon: Icons.help_outline,
              title: 'المساعدة',
              subtitle: 'الأسئلة الشائعة',
              trailing: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: AppTheme.goldPrimary,
              ),
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.privacy_tip_outlined,
              title: 'سياسة الخصوصية',
              subtitle: 'قراءة سياسة الخصوصية',
              trailing: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: AppTheme.goldPrimary,
              ),
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.description_outlined,
              title: 'شروط الاستخدام',
              subtitle: 'قراءة شروط الاستخدام',
              trailing: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: AppTheme.goldPrimary,
              ),
              onTap: () {},
            ),
            
            // عن التطبيق
            _buildSectionTitle('عن التطبيق'),
            _buildSettingTile(
              icon: Icons.info_outline,
              title: 'الإصدار',
              subtitle: '1.0.0',
            ),
            _buildSettingTile(
              icon: Icons.star_outline,
              title: 'تقييم التطبيق',
              subtitle: 'قيمنا على المتجر',
              trailing: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: AppTheme.goldPrimary,
              ),
              onTap: () {},
            ),
            _buildSettingTile(
              icon: Icons.share_outlined,
              title: 'مشاركة التطبيق',
              subtitle: 'شارك مع أصدقائك',
              trailing: Icon(
                Icons.arrow_back_ios,
                size: 16,
                color: AppTheme.goldPrimary,
              ),
              onTap: () {},
            ),
            
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(right: 16, left: 16, top: 24, bottom: 8),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 16,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Changa',
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: AppTheme.goldPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ListTile(
      leading: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: AppTheme.goldPrimary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(
          icon,
          color: AppTheme.goldPrimary,
          size: 22,
        ),
      ),
      title: Text(
        title,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 15,
          fontWeight: FontWeight.w600,
          color: isDark ? Colors.white : AppTheme.lightText,
        ),
      ),
      subtitle: Text(
        subtitle,
        style: TextStyle(
          fontFamily: 'Tajawal',
          fontSize: 12,
          color: isDark ? Colors.white60 : Colors.black54,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
    );
  }
}
