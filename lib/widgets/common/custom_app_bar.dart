// شريط التطبيق المخصص
import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import '../../theme/app_theme.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final Widget? leading;
  final bool showBackButton;
  final bool centerTitle;
  final double elevation;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final PreferredSizeWidget? bottom;
  final VoidCallback? onBackPressed;
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final bool showNotification;

  CustomAppBar({
    this.title,
    this.actions,
    this.leading,
    this.showBackButton = true,
    this.centerTitle = true,
    this.elevation = 0,
    this.backgroundColor,
    this.foregroundColor,
    this.bottom,
    this.onBackPressed,
    this.notificationCount = 0,
    this.onNotificationTap,
    this.showNotification = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontFamily: 'Changa',
                fontWeight: FontWeight.w600,
                color: foregroundColor ?? AppTheme.goldPrimary,
              ),
            )
          : null,
      centerTitle: centerTitle,
      elevation: elevation,
      backgroundColor: backgroundColor ??
          (isDark ? AppTheme.darkSurface : AppTheme.lightSurface),
      foregroundColor: foregroundColor ??
          (isDark ? AppTheme.darkText : AppTheme.lightText),
      leading: leading ??
          (showBackButton && Navigator.canPop(context)
              ? IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: foregroundColor ?? AppTheme.goldPrimary,
                  ),
                  onPressed: onBackPressed ?? () => Navigator.pop(context),
                )
              : null),
      actions: [
        ...?actions,
        if (showNotification)
          Padding(
            padding: EdgeInsets.only(left: 8, right: 8),
            child: IconButton(
              icon: badges.Badge(
                badgeContent: notificationCount > 0
                    ? Text(
                        notificationCount > 99 ? '99+' : '$notificationCount',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      )
                    : null,
                showBadge: notificationCount > 0,
                badgeStyle: badges.BadgeStyle(
                  badgeColor: AppTheme.error,
                  padding: EdgeInsets.all(4),
                ),
                child: Icon(
                  Icons.notifications_outlined,
                  color: foregroundColor ?? AppTheme.goldPrimary,
                ),
              ),
              onPressed: onNotificationTap,
            ),
          ),
      ],
      bottom: bottom,
    );
  }

  @override
  Size get preferredSize =>
      Size.fromHeight(kToolbarHeight + (bottom?.preferredSize.height ?? 0));
}

// شريط التطبيق الرئيسي مع شعار
class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final int notificationCount;
  final VoidCallback? onNotificationTap;
  final VoidCallback? onSearchTap;
  final VoidCallback? onMenuTap;

  HomeAppBar({
    this.notificationCount = 0,
    this.onNotificationTap,
    this.onSearchTap,
    this.onMenuTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AppBar(
      title: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                'F',
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'FLEX',
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.goldPrimary,
                  height: 1,
                ),
              ),
              Text(
                'YEMEN',
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: isDark ? AppTheme.darkTextSecondary : AppTheme.lightTextSecondary,
                  height: 1,
                ),
              ),
            ],
          ),
        ],
      ),
      centerTitle: false,
      elevation: 0,
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: AppTheme.goldPrimary,
        ),
        onPressed: onMenuTap,
      ),
      actions: [
        IconButton(
          icon: Icon(
            Icons.search,
            color: AppTheme.goldPrimary,
          ),
          onPressed: onSearchTap,
        ),
        Padding(
          padding: EdgeInsets.only(left: 8, right: 16),
          child: IconButton(
            icon: badges.Badge(
              badgeContent: notificationCount > 0
                  ? Text(
                      notificationCount > 99 ? '99+' : '$notificationCount',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    )
                  : null,
              showBadge: notificationCount > 0,
              badgeStyle: badges.BadgeStyle(
                badgeColor: AppTheme.error,
                padding: EdgeInsets.all(4),
              ),
              child: Icon(
                Icons.notifications_outlined,
                color: AppTheme.goldPrimary,
              ),
            ),
            onPressed: onNotificationTap,
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}

// شريط التطبيق الشفاف
class TransparentAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String? title;
  final List<Widget>? actions;
  final bool showBackButton;
  final VoidCallback? onBackPressed;

  TransparentAppBar({
    this.title,
    this.actions,
    this.showBackButton = true,
    this.onBackPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title != null
          ? Text(
              title!,
              style: TextStyle(
                fontFamily: 'Changa',
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            )
          : null,
      centerTitle: true,
      elevation: 0,
      backgroundColor: Colors.transparent,
      foregroundColor: Colors.white,
      leading: showBackButton && Navigator.canPop(context)
          ? IconButton(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.white,
                  size: 18,
                ),
              ),
              onPressed: onBackPressed ?? () => Navigator.pop(context),
            )
          : null,
      actions: actions?.map((action) {
        return Container(
          margin: EdgeInsets.only(right: 8),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.3),
            borderRadius: BorderRadius.circular(10),
          ),
          child: action,
        );
      }).toList(),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);
}
