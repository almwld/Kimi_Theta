// بطاقة المنتج
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class ProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  ProductCard({
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final price = product['price'] as double;
    final oldPrice = product['oldPrice'] as double?;
    final hasDiscount = oldPrice != null && oldPrice > price;
    final discountPercentage = hasDiscount
        ? ((oldPrice - price) / oldPrice * 100).round()
        : 0;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // صورة المنتج
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  // الصورة
                  ClipRRect(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(16),
                    ),
                    child: Container(
                      width: double.infinity,
                      color: isDark
                          ? AppTheme.darkCard
                          : Colors.grey.shade100,
                      child: product['images']?.isNotEmpty == true
                          ? Image.network(
                              product['images'][0],
                              fit: BoxFit.cover,
                            )
                          : Center(
                              child: Icon(
                                Icons.image,
                                size: 50,
                                color: isDark
                                    ? Colors.white24
                                    : Colors.black12,
                              ),
                            ),
                    ),
                  ),
                  
                  // خصم
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          gradient: AppTheme.goldGradient,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '-$discountPercentage%',
                          style: TextStyle(
                            fontFamily: 'Changa',
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  
                  // مزاد
                  if (product['isAuction'] == true)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              color: Colors.white,
                              size: 12,
                            ),
                            SizedBox(width: 4),
                            Text(
                              'مزاد',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  
                  // مفضلة
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: GestureDetector(
                      onTap: onFavoriteTap,
                      child: Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: isDark
                              ? AppTheme.darkCard
                              : Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        child: Icon(
                          isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: isFavorite
                              ? Colors.red
                              : (isDark
                                  ? Colors.white54
                                  : Colors.black38),
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            // معلومات المنتج
            Expanded(
              flex: 2,
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // اسم المنتج
                    Text(
                      product['title'] ?? '',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : AppTheme.lightText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    
                    Spacer(),
                    
                    // السعر
                    Row(
                      children: [
                        Text(
                          '${price.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontFamily: 'Changa',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.goldPrimary,
                          ),
                        ),
                        SizedBox(width: 4),
                        Text(
                          'ر.ي',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 11,
                            color: AppTheme.goldPrimary,
                          ),
                        ),
                      ],
                    ),
                    
                    if (hasDiscount) ...[
                      SizedBox(height: 2),
                      Text(
                        '${oldPrice!.toStringAsFixed(0)} ر.ي',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 11,
                          color: isDark
                              ? Colors.white38
                              : Colors.black38,
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                    
                    SizedBox(height: 8),
                    
                    // الموقع والتقييم
                    Row(
                      children: [
                        Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: isDark
                              ? Colors.white38
                              : Colors.black38,
                        ),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            product['city'] ?? '',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 11,
                              color: isDark
                                  ? Colors.white38
                                  : Colors.black38,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        
                        // التقييم
                        if ((product['rating'] ?? 0) > 0) ...[
                          Icon(
                            Icons.star,
                            size: 14,
                            color: Colors.amber,
                          ),
                          SizedBox(width: 2),
                          Text(
                            '${(product['rating'] as double).toStringAsFixed(1)}',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: isDark
                                  ? Colors.white70
                                  : Colors.black54,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// بطاقة المنتج الأفقية
class HorizontalProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback? onTap;
  final VoidCallback? onFavoriteTap;
  final bool isFavorite;

  HorizontalProductCard({
    required this.product,
    this.onTap,
    this.onFavoriteTap,
    this.isFavorite = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final price = product['price'] as double;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 200,
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // الصورة
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: Container(
                  width: double.infinity,
                  color: isDark
                      ? AppTheme.darkCard
                      : Colors.grey.shade100,
                  child: Center(
                    child: Icon(
                      Icons.image,
                      size: 40,
                      color: isDark
                          ? Colors.white24
                          : Colors.black12,
                    ),
                  ),
                ),
              ),
            ),
            
            // المعلومات
            Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['title'] ?? '',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isDark
                          ? Colors.white
                          : AppTheme.lightText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontFamily: 'Changa',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                      SizedBox(width: 4),
                      Text(
                        'ر.ي',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 10,
                          color: AppTheme.goldPrimary,
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
    );
  }
}

// بطاقة المنتج المدمجة
class CompactProductCard extends StatelessWidget {
  final dynamic product;
  final VoidCallback? onTap;

  CompactProductCard({
    required this.product,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final price = product['price'] as double;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            // الصورة
            ClipRRect(
              borderRadius: BorderRadius.horizontal(
                right: Radius.circular(12),
              ),
              child: Container(
                width: 80,
                height: 80,
                color: isDark
                    ? AppTheme.darkCard
                    : Colors.grey.shade100,
                child: Center(
                  child: Icon(
                    Icons.image,
                    size: 30,
                    color: isDark
                        ? Colors.white24
                        : Colors.black12,
                  ),
                ),
              ),
            ),
            
            // المعلومات
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title'] ?? '',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: isDark
                            ? Colors.white
                            : AppTheme.lightText,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          '${price.toStringAsFixed(0)} ر.ي',
                          style: TextStyle(
                            fontFamily: 'Changa',
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.goldPrimary,
                          ),
                        ),
                        Spacer(),
                        Icon(
                          Icons.arrow_back_ios,
                          size: 14,
                          color: AppTheme.goldPrimary,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
