// ويدجات التحميل
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shimmer/shimmer.dart';
import '../../theme/app_theme.dart';

// مؤشر التحميل الذهبي
class GoldLoading extends StatelessWidget {
  final double size;

  GoldLoading({this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitWave(
        color: AppTheme.goldPrimary,
        size: size,
      ),
    );
  }
}

// مؤشر التحميل الدائري
class CircularLoading extends StatelessWidget {
  final double size;
  final Color? color;
  final double strokeWidth;

  CircularLoading({
    this.size = 40,
    this.color,
    this.strokeWidth = 3,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          strokeWidth: strokeWidth,
          valueColor: AlwaysStoppedAnimation<Color>(
            color ?? AppTheme.goldPrimary,
          ),
        ),
      ),
    );
  }
}

// مؤشر التحميل المزدوج
class DoubleBounceLoading extends StatelessWidget {
  final double size;

  DoubleBounceLoading({this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitDoubleBounce(
        color: AppTheme.goldPrimary,
        size: size,
      ),
    );
  }
}

// مؤشر التحميل المتقطع
class PulseLoading extends StatelessWidget {
  final double size;

  PulseLoading({this.size = 50});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitPulse(
        color: AppTheme.goldPrimary,
        size: size,
      ),
    );
  }
}

// شاشة التحميل الكاملة
class LoadingScreen extends StatelessWidget {
  final String? message;

  LoadingScreen({this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SpinKitWave(
              color: AppTheme.goldPrimary,
              size: 60,
            ),
            if (message != null) ...[
              SizedBox(height: 24),
              Text(
                message!,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 16,
                  color: isDark ? Colors.white70 : Colors.black54,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// تأثير الشيمر
class ShimmerLoading extends StatelessWidget {
  final Widget child;

  ShimmerLoading({required this.child});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Shimmer.fromColors(
      baseColor: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
      highlightColor: isDark ? Colors.grey.shade700 : Colors.grey.shade100,
      child: child,
    );
  }
}

// بطاقة الشيمر
class ShimmerCard extends StatelessWidget {
  final double height;
  final double? width;
  final double borderRadius;

  ShimmerCard({
    this.height = 100,
    this.width,
    this.borderRadius = 12,
  });

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        height: height,
        width: width ?? double.infinity,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }
}

// دائرة الشيمر
class ShimmerCircle extends StatelessWidget {
  final double size;

  ShimmerCircle({this.size = 50});

  @override
  Widget build(BuildContext context) {
    return ShimmerLoading(
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
        ),
      ),
    );
  }
}

// قائمة الشيمر
class ShimmerList extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  ShimmerList({
    this.itemCount = 5,
    this.itemHeight = 80,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return Padding(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
          child: ShimmerCard(height: itemHeight),
        );
      },
    );
  }
}

// شبكة الشيمر
class ShimmerGrid extends StatelessWidget {
  final int itemCount;
  final int crossAxisCount;
  final double childAspectRatio;

  ShimmerGrid({
    this.itemCount = 6,
    this.crossAxisCount = 2,
    this.childAspectRatio = 0.75,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        childAspectRatio: childAspectRatio,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: itemCount,
      itemBuilder: (context, index) {
        return ShimmerCard();
      },
    );
  }
}

// مؤشر تحميل الصفحة
class PageLoadingIndicator extends StatelessWidget {
  final String? message;

  PageLoadingIndicator({this.message});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isDark ? AppTheme.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: AppTheme.lightShadow,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SpinKitWave(
                  color: AppTheme.goldPrimary,
                  size: 40,
                ),
                if (message != null) ...[
                  SizedBox(height: 16),
                  Text(
                    message!,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// مؤشر تحميل الأسفل
class BottomLoadingIndicator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(16),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.goldPrimary),
          ),
        ),
      ),
    );
  }
}

// مؤشر تحميل السحب للتحديث
class RefreshIndicatorGold extends StatelessWidget {
  final Widget child;
  final Future<void> Function() onRefresh;

  RefreshIndicatorGold({
    required this.child,
    required this.onRefresh,
  });

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: AppTheme.goldPrimary,
      backgroundColor: Theme.of(context).cardColor,
      strokeWidth: 3,
      displacement: 40,
      child: child,
    );
  }
}
