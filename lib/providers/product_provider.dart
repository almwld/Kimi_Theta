import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _featuredProducts = [];
  Map<String, dynamic>? _selectedProduct;
  List<String> _favoriteIds = [];
  int _currentPage = 0;
  bool _hasMore = true;
  bool _isLoading = false;

  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get featuredProducts => _featuredProducts;
  Map<String, dynamic>? get selectedProduct => _selectedProduct;
  List<String> get favoriteIds => _favoriteIds;
  bool get hasMore => _hasMore;
  bool get isLoading => _isLoading;

  Future<void> loadProducts({bool refresh = false, String? category, String? city}) async {
    if (refresh) {
      _currentPage = 0;
      _products.clear();
      _hasMore = true;
    }
    if (!_hasMore || _isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await SupabaseService.getProducts(
        category: category,
        city: city,
        limit: 20,
        offset: _currentPage * 20,
      );
      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(newProducts);
        _currentPage++;
      }
    } catch (e) {
      print('Error loading products: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFeaturedProducts() async {
    _featuredProducts = await SupabaseService.getProducts(limit: 6);
    notifyListeners();
  }

  Future<void> loadProductDetails(String productId) async {
    _selectedProduct = await SupabaseService.getProduct(productId);
    notifyListeners();
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    final newProduct = await SupabaseService.addProduct(productData);
    _products.insert(0, newProduct);
    notifyListeners();
  }

  Future<void> toggleFavorite(String userId, String productId) async {
    final isFav = _favoriteIds.contains(productId);
    if (isFav) {
      await SupabaseService.removeFromFavorites(userId, productId);
      _favoriteIds.remove(productId);
    } else {
      await SupabaseService.addToFavorites(userId, productId);
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  Future<void> loadFavorites(String userId) async {
    _favoriteIds = await SupabaseService.getFavorites(userId);
    notifyListeners();
  }
}
