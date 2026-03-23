// حالات فارغة
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:lottie/lottie.dart';
import '../../theme/app_theme.dart';
import 'custom_button.dart';

// حالة فارغة عامة
class EmptyState extends StatelessWidget {
  final String? title;
  final String? message;
  final String? lottieAsset;
  final IconData? icon;
  final String? actionText;
  final VoidCallback? onAction;
  final bool showLottie;

  EmptyState({
    this.title,
    this.message,
    this.lottieAsset,
    this.icon,
    this.actionText,
    this.onAction,
    this.showLottie = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (showLottie && lottieAsset != null) ...[
              Lottie.asset(
                lottieAsset!,
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
            ] else if (icon != null) ...[
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppTheme.goldPrimary.withOpacity(0.2),
                      AppTheme.goldLight.withOpacity(0.1),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 60,
                  color: AppTheme.goldPrimary,
                ),
              ),
            ],
            SizedBox(height: 24),
            if (title != null) ...[
              Text(
                title!,
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.lightText,
                ),
                textAlign: TextAlign.center,
              ).animate()
               .fadeIn(duration: 400.ms)
               .slideY(begin: 0.2, end: 0),
            ],
            if (message != null) ...[
              SizedBox(height: 12),
              Text(
                message!,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 15,
                  color: isDark ? Colors.white60 : Colors.black54,
                ),
                textAlign: TextAlign.center,
              ).animate()
               .fadeIn(duration: 400.ms, delay: 100.ms)
               .slideY(begin: 0.2, end: 0),
            ],
            if (actionText != null && onAction != null) ...[
              SizedBox(height: 32),
              GoldButton(
                text: actionText!,
                onPressed: onAction,
              ).animate()
               .fadeIn(duration: 400.ms, delay: 200.ms)
               .slideY(begin: 0.2, end: 0),
            ],
          ],
        ),
      ),
    );
  }
}

// حالة عدم وجود منتجات
class EmptyProducts extends StatelessWidget {
  final VoidCallback? onRefresh;

  EmptyProducts({this.onRefresh});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.inventory_2_outlined,
      title: 'لا توجد منتجات',
      message: 'لم يتم العثور على أي منتجات في الوقت الحالي',
      actionText: 'تحديث',
      onAction: onRefresh,
    );
  }
}

// حالة عدم وجود نتائج بحث
class EmptySearch extends StatelessWidget {
  final String query;
  final VoidCallback? onClear;

  EmptySearch({this.query = '', this.onClear});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.search_off,
      title: 'لا توجد نتائج',
      message: query.isNotEmpty
          ? 'لم يتم العثور على نتائج لـ "$query"'
          : 'جرب البحث بكلمات مختلفة',
      actionText: 'مسح البحث',
      onAction: onClear,
    );
  }
}

// حالة عدم وجود مفضلة
class EmptyFavorites extends StatelessWidget {
  final VoidCallback? onBrowse;

  EmptyFavorites({this.onBrowse});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.favorite_border,
      title: 'لا توجد مفضلات',
      message: 'أضف منتجات إلى المفضلة للوصول إليها بسهولة',
      actionText: 'تصفح المنتجات',
      onAction: onBrowse,
    );
  }
}

// حالة عدم وجود طلبات
class EmptyOrders extends StatelessWidget {
  final VoidCallback? onShop;

  EmptyOrders({this.onShop});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.shopping_bag_outlined,
      title: 'لا توجد طلبات',
      message: 'لم تقم بأي طلبات بعد، ابدأ التسوق الآن',
      actionText: 'تصفح المتجر',
      onAction: onShop,
    );
  }
}

// حالة عدم وجود محادثات
class EmptyChats extends StatelessWidget {
  final VoidCallback? onStartChat;

  EmptyChats({this.onStartChat});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.chat_bubble_outline,
      title: 'لا توجد محادثات',
      message: 'ابدأ محادثة مع البائعين للاستفسار عن المنتجات',
      actionText: 'بدء محادثة',
      onAction: onStartChat,
    );
  }
}

// حالة عدم وجود إشعارات
class EmptyNotifications extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.notifications_none,
      title: 'لا توجد إشعارات',
      message: 'سيتم إعلامك عند وجود تحديثات جديدة',
    );
  }
}

// حالة عدم وجود معاملات
class EmptyTransactions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.receipt_long_outlined,
      title: 'لا توجد معاملات',
      message: 'ستظهر معاملاتك هنا عند إجراء أي عملية',
    );
  }
}

// حالة عدم وجود نتائج في الفلتر
class EmptyFilter extends StatelessWidget {
  final VoidCallback? onClearFilter;

  EmptyFilter({this.onClearFilter});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.filter_list_off,
      title: 'لا توجد نتائج',
      message: 'جرب تعديل معايير الفلتر للحصول على نتائج',
      actionText: 'مسح الفلتر',
      onAction: onClearFilter,
    );
  }
}

// حالة عدم وجود اتصال بالإنترنت
class NoInternet extends StatelessWidget {
  final VoidCallback? onRetry;

  NoInternet({this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.wifi_off,
      title: 'لا يوجد اتصال',
      message: 'يرجى التحقق من اتصالك بالإنترنت والمحاولة مرة أخرى',
      actionText: 'إعادة المحاولة',
      onAction: onRetry,
    );
  }
}

// حالة خطأ
class ErrorState extends StatelessWidget {
  final String? message;
  final VoidCallback? onRetry;

  ErrorState({this.message, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.error_outline,
      title: 'حدث خطأ',
      message: message ?? 'حدث خطأ غير متوقع، يرجى المحاولة مرة أخرى',
      actionText: 'إعادة المحاولة',
      onAction: onRetry,
    );
  }
}

// حالة الوصول المحدود
class GuestRestriction extends StatelessWidget {
  final VoidCallback? onLogin;

  GuestRestriction({this.onLogin});

  @override
  Widget build(BuildContext context) {
    return EmptyState(
      icon: Icons.lock_outline,
      title: 'تسجيل الدخول مطلوب',
      message: 'يجب تسجيل الدخول للوصول إلى هذه الميزة',
      actionText: 'تسجيل الدخول',
      onAction: onLogin,
    );
  }
}
