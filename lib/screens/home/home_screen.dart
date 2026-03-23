// الشاشة الرئيسية
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/product_provider.dart';
import '../../providers/notification_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_widget.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/cards/product_card.dart';
import '../notifications/notifications_screen.dart';
import '../product/product_detail_screen.dart';
import '../search/search_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentBannerIndex = 0;

  // بيانات وهمية للسلايدر
  final List<Map<String, dynamic>> _banners = [
    {
      'title': 'عروض خاصة',
      'subtitle': 'خصومات تصل إلى 50%',
      'color': [Color(0xFFD4AF37), Color(0xFFF4D03F)],
    },
    {
      'title': 'إلكترونيات',
      'subtitle': 'أحدث الأجهزة بأفضل الأسعار',
      'color': [Color(0xFF3498DB), Color(0xFF5DADE2)],
    },
    {
      'title': 'عقارات',
      'subtitle': 'اكتشف أفضل العقارات',
      'color': [Color(0xFF27AE60), Color(0xFF58D68D)],
    },
    {
      'title': 'أزياء',
      'subtitle': 'تشكيلة جديدة لموسم 2024',
      'color': [Color(0xFFE74C3C), Color(0xFFEC7063)],
    },
    {
      'title': 'سيارات',
      'subtitle': 'سيارات جديدة ومستعملة',
      'color': [Color(0xFF9B59B6), Color(0xFFAF7AC5)],
    },
  ];

  // بيانات وهمية للخدمات السريعة
  final List<Map<String, dynamic>> _quickServices = [
    {'icon': Icons.construction, 'name': 'معلمات', 'color': Colors.orange},
    {'icon': Icons.apartment, 'name': 'عقارات', 'color': Colors.blue},
    {'icon': Icons.flight, 'name': 'سفر', 'color': Colors.green},
    {'icon': Icons.local_shipping, 'name': 'شحن', 'color': Colors.purple},
    {'icon': Icons.sports_esports, 'name': 'ألعاب', 'color': Colors.red},
    {'icon': Icons.restaurant, 'name': 'مطاعم', 'color': Colors.teal},
    {'icon': Icons.local_offer, 'name': 'عروض', 'color': Colors.pink},
    {'icon': Icons.more_horiz, 'name': 'المزيد', 'color': Colors.grey},
  ];

  // بيانات وهمية للعقارات
  final List<Map<String, dynamic>> _realEstate = [
    {'icon': Icons.apartment, 'name': 'شقق', 'color': Colors.blue},
    {'icon': Icons.villa, 'name': 'فلل', 'color': Colors.green},
    {'icon': Icons.landscape, 'name': 'أراضي', 'color': Colors.brown},
    {'icon': Icons.store, 'name': 'محلات', 'color': Colors.orange},
    {'icon': Icons.business, 'name': 'مكاتب', 'color': Colors.purple},
    {'icon': Icons.warehouse, 'name': 'مستودعات', 'color': Colors.grey},
    {'icon': Icons.trending_up, 'name': 'استثمار', 'color': Colors.red},
  ];

  // بيانات وهمية للإلكترونيات
  final List<Map<String, dynamic>> _electronics = [
    {'icon': Icons.smartphone, 'name': 'هواتف', 'color': Colors.blue},
    {'icon': Icons.laptop, 'name': 'لابتوبات', 'color': Colors.grey},
    {'icon': Icons.router, 'name': 'ستارلينك', 'color': Colors.cyan},
    {'icon': Icons.camera_alt, 'name': 'كاميرات', 'color': Colors.purple},
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProductProvider>().loadProducts();
    });
  }

  Future<void> _refresh() async {
    await context.read<ProductProvider>().loadProducts(refresh: true);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final productProvider = context.watch<ProductProvider>();
    final notificationProvider = context.watch<NotificationProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: HomeAppBar(
        notificationCount: notificationProvider.unreadCount,
        onNotificationTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotificationsScreen()),
          );
        },
        onSearchTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        },
      ),
      body: RefreshIndicatorGold(
        onRefresh: _refresh,
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // السلايدر
              _buildBannerSlider(),
              
              SizedBox(height: 24),
              
              // خدمات سريعة
              _buildSectionTitle('مزيد من ما تريد'),
              SizedBox(height: 12),
              _buildQuickServices(),
              
              SizedBox(height: 24),
              
              // مزاد الجنابي
              _buildSectionTitle('مزاد الجنابي الأسبوعي'),
              SizedBox(height: 12),
              _buildAuctionSection(),
              
              SizedBox(height: 24),
              
              // العقارات والاستثمارات
              _buildSectionTitle('العقارات والاستثمارات'),
              SizedBox(height: 12),
              _buildRealEstateSection(),
              
              SizedBox(height: 24),
              
              // عالم الإلكترونيات
              _buildSectionTitle('عالم الإلكترونيات والتقنية'),
              SizedBox(height: 12),
              _buildElectronicsSection(),
              
              SizedBox(height: 24),
              
              // المنتجات المقترحة
              _buildSectionTitle('منتجات مقترحة لك'),
              SizedBox(height: 12),
              _buildProductsGrid(productProvider),
              
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBannerSlider() {
    return Column(
      children: [
        CarouselSlider.builder(
          itemCount: _banners.length,
          options: CarouselOptions(
            height: 180,
            autoPlay: true,
            autoPlayInterval: Duration(seconds: 4),
            enlargeCenterPage: true,
            viewportFraction: 0.9,
            onPageChanged: (index, reason) {
              setState(() {
                _currentBannerIndex = index;
              });
            },
          ),
          itemBuilder: (context, index, realIndex) {
            final banner = _banners[index];
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: banner['color'] as List<Color>,
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: (banner['color'] as List<Color>)[0].withOpacity(0.3),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // الدوائر الزخرفية
                  Positioned(
                    right: -30,
                    top: -30,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  Positioned(
                    left: -20,
                    bottom: -20,
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.1),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // المحتوى
                  Padding(
                    padding: EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          banner['title'],
                          style: TextStyle(
                            fontFamily: 'Changa',
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          banner['subtitle'],
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 16),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'اكتشف الآن',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: (banner['color'] as List<Color>)[0],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ).animate()
             .fadeIn(duration: 500.ms)
             .slideX(begin: 0.2, end: 0);
          },
        ),
        SizedBox(height: 16),
        // مؤشرات السلايدر
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _banners.asMap().entries.map((entry) {
            return Container(
              width: _currentBannerIndex == entry.key ? 24 : 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: _currentBannerIndex == entry.key
                    ? AppTheme.goldGradient
                    : null,
                color: _currentBannerIndex == entry.key
                    ? null
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildSectionTitle(String title) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 24,
            decoration: BoxDecoration(
              gradient: AppTheme.goldGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontFamily: 'Changa',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.lightText,
            ),
          ),
          Spacer(),
          TextButton(
            onPressed: () {},
            child: Row(
              children: [
                Text(
                  'المزيد',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13,
                    color: AppTheme.goldPrimary,
                  ),
                ),
                Icon(
                  Icons.arrow_back_ios,
                  size: 12,
                  color: AppTheme.goldPrimary,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickServices() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: _quickServices.length,
        itemBuilder: (context, index) {
          final service = _quickServices[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 70,
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          (service['color'] as Color).withOpacity(0.2),
                          (service['color'] as Color).withOpacity(0.1),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      service['icon'] as IconData,
                      color: service['color'] as Color,
                      size: 28,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    service['name'] as String,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ).animate()
           .fadeIn(delay: (index * 100).ms)
           .scale(begin: Offset(0.8, 0.8), end: Offset(1, 1));
        },
      ),
    );
  }

  Widget _buildAuctionSection() {
    return Container(
      height: 180,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: 4,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 160,
              margin: EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                gradient: AppTheme.goldGradient,
                borderRadius: BorderRadius.circular(16),
                boxShadow: AppTheme.goldShadow,
              ),
              child: Stack(
                children: [
                  // صورة المنتج
                  ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      color: Colors.white.withOpacity(0.2),
                      child: Center(
                        child: Icon(
                          Icons.image,
                          size: 60,
                          color: Colors.white.withOpacity(0.5),
                        ),
                      ),
                    ),
                  ),
                  // المؤقت
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '02:45:30',
                        style: TextStyle(
                          fontFamily: 'Changa',
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  // السعر
                  Positioned(
                    bottom: 8,
                    left: 8,
                    right: 8,
                    child: Container(
                      padding: EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${(index + 1) * 50000} ر.ي',
                            style: TextStyle(
                              fontFamily: 'Changa',
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Icon(
                            Icons.favorite_border,
                            color: Colors.white,
                            size: 20,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildRealEstateSection() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: _realEstate.length,
        itemBuilder: (context, index) {
          final item = _realEstate[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 80,
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (item['color'] as Color).withOpacity(0.3),
                      ),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    item['name'] as String,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildElectronicsSection() {
    return Container(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: _electronics.length,
        itemBuilder: (context, index) {
          final item = _electronics[index];
          return GestureDetector(
            onTap: () {},
            child: Container(
              width: 80,
              margin: EdgeInsets.symmetric(horizontal: 4),
              child: Column(
                children: [
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: (item['color'] as Color).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: (item['color'] as Color).withOpacity(0.3),
                      ),
                    ),
                    child: Icon(
                      item['icon'] as IconData,
                      color: item['color'] as Color,
                      size: 32,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    item['name'] as String,
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 12,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? Colors.white70
                          : Colors.black54,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid(ProductProvider productProvider) {
    if (productProvider.isLoading && productProvider.products.isEmpty) {
      return ShimmerGrid(
        itemCount: 6,
        crossAxisCount: 2,
        childAspectRatio: 0.65,
      );
    }

    if (productProvider.products.isEmpty) {
      return EmptyProducts(onRefresh: _refresh);
    }

    // إنشاء 130+ منتج وهمي
    final products = List.generate(130, (index) {
      return _buildDummyProduct(index);
    });

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 12),
      child: GridView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 0.65,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return ProductCard(
            product: product,
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailScreen(product: product),
                ),
              );
            },
            onFavoriteTap: () {
              context.read<ProductProvider>().toggleFavorite(product.id);
            },
            isFavorite: context.read<ProductProvider>().isFavorite(product.id),
          ).animate()
           .fadeIn(delay: (index % 10 * 50).ms)
           .slideY(begin: 0.1, end: 0);
        },
      ),
    );
  }

  // إنشاء منتج وهمي
  dynamic _buildDummyProduct(int index) {
    final categories = ['إلكترونيات', 'أزياء', 'منزل', 'رياضة', 'كتب', 'جمال'];
    final conditions = ['جديد', 'مستعمل'];
    final cities = AppConstants.yemeniCities;

    return {
      'id': 'product_$index',
      'title': 'منتج ${index + 1} - ${categories[index % categories.length]}',
      'description': 'وصف المنتج ${index + 1} - منتج عالي الجودة بسعر مميز',
      'price': ((index + 1) * 1000 + (index * 500)).toDouble(),
      'oldPrice': index % 3 == 0 ? ((index + 1) * 1000 + (index * 500) * 1.2).toDouble() : null,
      'images': [],
      'category': categories[index % categories.length],
      'subCategory': 'فرعي',
      'condition': conditions[index % conditions.length],
      'city': cities[index % cities.length],
      'sellerId': 'seller_$index',
      'sellerName': 'بائع ${index + 1}',
      'sellerAvatar': null,
      'sellerRating': 3.5 + (index % 5) * 0.3,
      'createdAt': DateTime.now().subtract(Duration(days: index % 30)),
      'isFeatured': index < 10,
      'isAuction': index % 10 == 0,
      'viewsCount': (index + 1) * 10,
      'favoritesCount': index * 2,
      'rating': 3.5 + (index % 5) * 0.3,
      'reviewsCount': index % 20,
      'hasWarranty': index % 5 == 0,
      'hasShipping': index % 3 == 0,
      'isNegotiable': index % 7 == 0,
    };
  }
}
