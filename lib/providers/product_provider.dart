import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ProductProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _products = [];
  List<Map<String, dynamic>> _featuredProducts = [];
  Map<String, dynamic>? _selectedProduct;
  List<String> _favoriteIds = [];
  bool _isLoading = false;
  String? _error;
  int _currentPage = 0;
  bool _hasMore = true;

  List<Map<String, dynamic>> get products => _products;
  List<Map<String, dynamic>> get featuredProducts => _featuredProducts;
  Map<String, dynamic>? get selectedProduct => _selectedProduct;
  List<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasMore => _hasMore;

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 0;
      _products.clear();
      _hasMore = true;
    }
    if (!_hasMore) return;
    _isLoading = true;
    notifyListeners();

    try {
      final newProducts = await SupabaseService.getProducts(
        limit: 20,
        offset: _currentPage * 20,
      );
      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        _products.addAll(newProducts);
        _currentPage++;
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadFeatured() async {
    if (_featuredProducts.isNotEmpty) return;
    _isLoading = true;
    notifyListeners();

    try {
      _featuredProducts = await SupabaseService.getProducts(limit: 6);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadProduct(String productId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _selectedProduct = await SupabaseService.getProduct(productId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addProduct(Map<String, dynamic> productData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newProduct = await SupabaseService.addProduct(productData);
      _products.insert(0, newProduct);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleFavorite(String productId, String userId) async {
    try {
      if (_favoriteIds.contains(productId)) {
        await SupabaseService.removeFromFavorites(userId, productId);
        _favoriteIds.remove(productId);
      } else {
        await SupabaseService.addToFavorites(userId, productId);
        _favoriteIds.add(productId);
      }
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  Future<void> loadFavorites(String userId) async {
    try {
      _favoriteIds = await SupabaseService.getFavorites(userId);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
