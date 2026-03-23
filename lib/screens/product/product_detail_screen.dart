// شاشة تفاصيل المنتج
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';

class ProductDetailScreen extends StatefulWidget {
  final dynamic product;

  ProductDetailScreen({required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  int _currentImageIndex = 0;
  bool _isFavorite = false;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final product = widget.product;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      body: CustomScrollView(
        slivers: [
          // AppBar شفاف
          SliverAppBar(
            expandedHeight: 350,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: _buildImageSlider(),
            ),
            leading: Container(
              margin: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios, color: Colors.white),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            actions: [
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.white,
                  ),
                  onPressed: () {
                    setState(() {
                      _isFavorite = !_isFavorite;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.3),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: IconButton(
                  icon: Icon(Icons.share, color: Colors.white),
                  onPressed: () {},
                ),
              ),
            ],
          ),
          
          // المحتوى
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // العنوان والسعر
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Text(
                          product['title'] ?? 'عنوان المنتج',
                          style: TextStyle(
                            fontFamily: 'Changa',
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.lightText,
                          ),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Row(
                            children: [
                              Text(
                                '${(product['price'] as double).toStringAsFixed(0)}',
                                style: TextStyle(
                                  fontFamily: 'Changa',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.goldPrimary,
                                ),
                              ),
                              SizedBox(width: 4),
                              Text(
                                'ر.ي',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 14,
                                  color: AppTheme.goldPrimary,
                                ),
                              ),
                            ],
                          ),
                          if (product['oldPrice'] != null) ...[
                            Text(
                              '${(product['oldPrice'] as double).toStringAsFixed(0)} ر.ي',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 14,
                                color: isDark ? Colors.white38 : Colors.black38,
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                  
                  SizedBox(height: 16),
                  
                  // معلومات البائع
                  _buildSellerInfo(),
                  
                  SizedBox(height: 24),
                  
                  // الوصف
                  _buildSectionTitle('الوصف'),
                  SizedBox(height: 8),
                  Text(
                    product['description'] ?? 'لا يوجد وصف',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 14,
                      color: isDark ? Colors.white70 : Colors.black54,
                      height: 1.6,
                    ),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // التفاصيل
                  _buildSectionTitle('التفاصيل'),
                  SizedBox(height: 8),
                  _buildDetailsGrid(),
                  
                  SizedBox(height: 24),
                  
                  // التقييمات
                  _buildSectionTitle('التقييمات'),
                  SizedBox(height: 8),
                  _buildReviews(),
                  
                  SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildImageSlider() {
    final images = widget.product['images'] as List<dynamic>? ?? [];
    
    if (images.isEmpty) {
      return Container(
        color: Colors.grey.shade200,
        child: Center(
          child: Icon(
            Icons.image,
            size: 100,
            color: Colors.grey,
          ),
        ),
      );
    }

    return Stack(
      children: [
        CarouselSlider.builder(
          itemCount: images.length,
          options: CarouselOptions(
            height: 350,
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _currentImageIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            return Image.network(
              images[index],
              fit: BoxFit.cover,
              width: double.infinity,
            );
          },
        ),
        
        // مؤشر الصور
        Positioned(
          bottom: 16,
          left: 0,
          right: 0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: images.asMap().entries.map((entry) {
              return Container(
                width: _currentImageIndex == entry.key ? 24 : 8,
                height: 8,
                margin: EdgeInsets.symmetric(horizontal: 4),
                decoration: BoxDecoration(
                  gradient: _currentImageIndex == entry.key
                      ? AppTheme.goldGradient
                      : null,
                  color: _currentImageIndex == entry.key
                      ? null
                      : Colors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(4),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildSellerInfo() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: AppTheme.goldPrimary.withOpacity(0.2),
            child: Text(
              (widget.product['sellerName'] ?? 'U').substring(0, 1),
              style: TextStyle(
                fontFamily: 'Changa',
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppTheme.goldPrimary,
              ),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product['sellerName'] ?? 'البائع',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppTheme.lightText,
                  ),
                ),
                SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.star, color: Colors.amber, size: 16),
                    SizedBox(width: 4),
                    Text(
                      '${(widget.product['sellerRating'] ?? 0).toStringAsFixed(1)}',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black54,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Row(
            children: [
              _buildActionButton(Icons.chat_bubble_outline, 'محادثة'),
              SizedBox(width: 8),
              _buildActionButton(Icons.phone, 'اتصال'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.white, size: 16),
          SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 12,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
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
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppTheme.lightText,
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsGrid() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final details = [
      {'label': 'الحالة', 'value': widget.product['condition'] == 'new' ? 'جديد' : 'مستعمل'},
      {'label': 'المدينة', 'value': widget.product['city'] ?? 'غير محدد'},
      {'label': 'الفئة', 'value': widget.product['category'] ?? 'غير محدد'},
      {'label': 'الضمان', 'value': widget.product['hasWarranty'] == true ? 'نعم' : 'لا'},
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: details.length,
      itemBuilder: (context, index) {
        final detail = details[index];
        return Container(
          padding: EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                detail['label']!,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
              Text(
                detail['value']!,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: isDark ? Colors.white : AppTheme.lightText,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildReviews() {
    return Column(
      children: List.generate(3, (index) {
        return Container(
          margin: EdgeInsets.only(bottom: 12),
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkSurface
                : Colors.white,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundColor: AppTheme.goldPrimary.withOpacity(0.2),
                    child: Text(
                      'U${index + 1}',
                      style: TextStyle(
                        fontFamily: 'Changa',
                        color: AppTheme.goldPrimary,
                      ),
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'مستخدم ${index + 1}',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < 4 ? Icons.star : Icons.star_border,
                              size: 14,
                              color: Colors.amber,
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '2024-01-${10 + index}',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'منتج رائع وجودة عالية، أنصح بالشراء من هذا البائع',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 14,
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildBottomBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(16),
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
        child: Row(
          children: [
            Expanded(
              child: GoldButton(
                text: 'تواصل مع البائع',
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
