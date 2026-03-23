// شاشة المفضلة
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/empty_state.dart';
import '../../widgets/cards/product_card.dart';
import 'product_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _favorites = [
    {
      'id': '1',
      'title': 'آيفون 14 برو ماكس',
      'price': 350000.0,
      'oldPrice': 400000.0,
      'city': 'صنعاء',
      'rating': 4.8,
      'images': [],
    },
    {
      'id': '2',
      'title': 'لابتوب Dell XPS 15',
      'price': 280000.0,
      'city': 'عدن',
      'rating': 4.5,
      'images': [],
    },
    {
      'id': '3',
      'title': 'سيارة تويوتا كامري 2020',
      'price': 4500000.0,
      'city': 'تعز',
      'rating': 4.9,
      'images': [],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: CustomAppBar(
        title: 'المفضلة',
        actions: [
          if (_favorites.isNotEmpty)
            TextButton(
              onPressed: () {},
              child: Text(
                'مسح الكل',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  color: AppTheme.error,
                ),
              ),
            ),
        ],
      ),
      body: _favorites.isEmpty
          ? EmptyFavorites(
              onBrowse: () {
                Navigator.pop(context);
              },
            )
          : GridView.builder(
              padding: EdgeInsets.all(12),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.65,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: _favorites.length,
              itemBuilder: (context, index) {
                final product = _favorites[index];
                return ProductCard(
                  product: product,
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          product: product,
                        ),
                      ),
                    );
                  },
                  onFavoriteTap: () {},
                  isFavorite: true,
                ).animate()
                 .fadeIn(delay: (index * 100).ms)
                 .slideY(begin: 0.1, end: 0);
              },
            ),
    );
  }
}
