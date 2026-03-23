// شاشة المنتجات
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/cards/product_card.dart';
import 'product_detail_screen.dart';

class ProductsScreen extends StatefulWidget {
  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {
  String _selectedCategory = 'all';
  String _sortBy = 'newest';

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: CustomAppBar(
        title: 'المتجر',
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterBottomSheet();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // الفئات
          _buildCategoriesList(),
          
          // الترتيب
          _buildSortBar(),
          
          // الشبكة
          Expanded(
            child: _buildProductsGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesList() {
    final categories = [
      {'id': 'all', 'name': 'الكل'},
      ...AppConstants.categories,
    ];

    return Container(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          final isSelected = _selectedCategory == category['id'];

          return GestureDetector(
            onTap: () {
              setState(() {
                _selectedCategory = category['id'] as String;
              });
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 4),
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                gradient: isSelected ? AppTheme.goldGradient : null,
                color: isSelected ? null : (Theme.of(context).brightness == Brightness.dark
                    ? AppTheme.darkSurface
                    : Colors.white),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppTheme.goldPrimary : Colors.transparent,
                ),
              ),
              child: Center(
                child: Text(
                  category['name'] as String,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected
                        ? Colors.white
                        : (Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSortBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Text(
            'ترتيب حسب:',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 13,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ),
          SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('الأحدث', 'newest'),
                  _buildSortChip('السعر', 'price'),
                  _buildSortChip('الشعبية', 'popular'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        setState(() {
          _sortBy = value;
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 8),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected
              ? AppTheme.goldPrimary.withOpacity(0.1)
              : (isDark ? AppTheme.darkSurface : Colors.white),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppTheme.goldPrimary : Colors.transparent,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 12,
            color: isSelected
                ? AppTheme.goldPrimary
                : (isDark ? Colors.white60 : Colors.black54),
          ),
        ),
      ),
    );
  }

  Widget _buildProductsGrid() {
    // إنشاء 50 منتج وهمي
    final products = List.generate(50, (index) {
      return _buildDummyProduct(index);
    });

    return GridView.builder(
      padding: EdgeInsets.all(12),
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
          onFavoriteTap: () {},
          isFavorite: index % 5 == 0,
        ).animate()
         .fadeIn(delay: (index % 10 * 50).ms)
         .slideY(begin: 0.1, end: 0);
      },
    );
  }

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

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: BoxDecoration(
            color: Theme.of(context).brightness == Brightness.dark
                ? AppTheme.darkSurface
                : Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              // Handle
              Container(
                margin: EdgeInsets.only(top: 12),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              
              // Title
              Padding(
                padding: EdgeInsets.all(16),
                child: Text(
                  'فلترة النتائج',
                  style: TextStyle(
                    fontFamily: 'Changa',
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              
              // Filters
              Expanded(
                child: ListView(
                  padding: EdgeInsets.all(16),
                  children: [
                    _buildFilterSection('السعر'),
                    _buildPriceRange(),
                    SizedBox(height: 24),
                    _buildFilterSection('الحالة'),
                    _buildConditionFilter(),
                    SizedBox(height: 24),
                    _buildFilterSection('الموقع'),
                    _buildLocationFilter(),
                  ],
                ),
              ),
              
              // Buttons
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text('إلغاء'),
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.pop(context),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppTheme.goldPrimary,
                        ),
                        child: Text('تطبيق'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildFilterSection(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'Changa',
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _buildPriceRange() {
    return RangeSlider(
      values: RangeValues(0, 100000),
      min: 0,
      max: 100000,
      divisions: 100,
      labels: RangeLabels('0', '100,000'),
      onChanged: (values) {},
    );
  }

  Widget _buildConditionFilter() {
    return Row(
      children: [
        Expanded(
          child: FilterChip(
            label: Text('جديد'),
            selected: true,
            onSelected: (_) {},
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: FilterChip(
            label: Text('مستعمل'),
            selected: false,
            onSelected: (_) {},
          ),
        ),
      ],
    );
  }

  Widget _buildLocationFilter() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: AppConstants.yemeniCities.take(6).map((city) {
        return FilterChip(
          label: Text(city),
          selected: false,
          onSelected: (_) {},
        );
      }).toList(),
    );
  }
}
