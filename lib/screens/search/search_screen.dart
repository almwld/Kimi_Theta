// شاشة البحث
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/custom_app_bar.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = [
    'آيفون 14',
    'لابتوب',
    'سيارة تويوتا',
    'شقة للإيجار',
  ];
  final List<String> _popularSearches = [
    'هواتف',
    'سيارات',
    'عقارات',
    'أثاث',
    'إلكترونيات',
    'ملابس',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: CustomAppBar(
        title: 'بحث',
      ),
      body: Column(
        children: [
          // حقل البحث
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                textAlign: TextAlign.right,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'ابحث عن منتجات، خدمات...',
                  hintStyle: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 14,
                    color: isDark ? Colors.white40 : Colors.black38,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppTheme.goldPrimary,
                  ),
                  suffixIcon: _searchController.text.isNotEmpty
                      ? IconButton(
                          icon: Icon(
                            Icons.clear,
                            color: isDark ? Colors.white40 : Colors.black38,
                          ),
                          onPressed: () {
                            setState(() {
                              _searchController.clear();
                            });
                          },
                        )
                      : null,
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                onChanged: (value) {
                  setState(() {});
                },
              ),
            ),
          ),
          
          // المحتوى
          Expanded(
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // البحث الأخير
                  _buildSectionTitle('البحث الأخير'),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _recentSearches.map((search) {
                      return _buildSearchChip(search, true);
                    }).toList(),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // البحث الشائع
                  _buildSectionTitle('البحث الشائع'),
                  SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: _popularSearches.map((search) {
                      return _buildSearchChip(search, false);
                    }).toList(),
                  ),
                  
                  SizedBox(height: 24),
                  
                  // الفئات
                  _buildSectionTitle('تصفح حسب الفئة'),
                  SizedBox(height: 12),
                  GridView.count(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    crossAxisCount: 3,
                    childAspectRatio: 1,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _buildCategoryItem(Icons.phone_android, 'هواتف', Colors.blue),
                      _buildCategoryItem(Icons.laptop, 'لابتوبات', Colors.grey),
                      _buildCategoryItem(Icons.directions_car, 'سيارات', Colors.red),
                      _buildCategoryItem(Icons.apartment, 'عقارات', Colors.green),
                      _buildCategoryItem(Icons.chair, 'أثاث', Colors.brown),
                      _buildCategoryItem(Icons.checkroom, 'ملابس', Colors.purple),
                      _buildCategoryItem(Icons.sports, 'رياضة', Colors.orange),
                      _buildCategoryItem(Icons.book, 'كتب', Colors.teal),
                      _buildCategoryItem(Icons.more_horiz, 'المزيد', Colors.grey),
                    ],
                  ),
                ],
              ),
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppTheme.lightText,
          ),
        ),
        Spacer(),
        if (title == 'البحث الأخير')
          TextButton(
            onPressed: () {
              setState(() {
                _recentSearches.clear();
              });
            },
            child: Text(
              'مسح',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                color: AppTheme.error,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSearchChip(String label, bool isRecent) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        _searchController.text = label;
      },
      child: Chip(
        label: Text(
          label,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13,
            color: isDark ? Colors.white : AppTheme.lightText,
          ),
        ),
        backgroundColor: isDark ? AppTheme.darkSurface : Colors.white,
        deleteIcon: isRecent ? Icon(Icons.close, size: 16) : null,
        onDeleted: isRecent
            ? () {
                setState(() {
                  _recentSearches.remove(label);
                });
              }
            : null,
        side: BorderSide(
          color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
        ),
      ),
    ).animate()
     .fadeIn()
     .scale(begin: Offset(0.9, 0.9), end: Offset(1, 1));
  }

  Widget _buildCategoryItem(IconData icon, String label, Color color) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {},
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppTheme.darkSurface : Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                icon,
                color: color,
                size: 28,
              ),
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                color: isDark ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
