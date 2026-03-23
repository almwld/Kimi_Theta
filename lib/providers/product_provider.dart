import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/product_model.dart';

class ProductProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<ProductModel> _products = [];
  List<ProductModel> _featuredProducts = [];
  ProductModel? _selectedProduct;
  List<String> _favoriteIds = [];
  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoading = false;

  List<ProductModel> get products => _products;
  List<ProductModel> get featuredProducts => _featuredProducts;
  ProductModel? get selectedProduct => _selectedProduct;
  List<String> get favoriteIds => _favoriteIds;
  bool get isLoading => _isLoading;
  bool get hasMore => _hasMore;

  Future<void> fetchProducts({String? category, String? city, bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _products.clear();
      _hasMore = true;
    }
    if (!_hasMore) return;
    _isLoading = true;
    notifyListeners();

    final newProducts = await _supabaseService.getProducts(
      category: category,
      city: city,
      page: _currentPage,
      limit: 10,
    );

    if (newProducts.isEmpty) {
      _hasMore = false;
    } else {
      _products.addAll(newProducts);
      _currentPage++;
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchFeaturedProducts() async {
    _featuredProducts = await _supabaseService.getProducts(limit: 6);
    notifyListeners();
  }

  Future<void> fetchProductDetails(String productId) async {
    _selectedProduct = await _supabaseService.getProduct(productId);
    notifyListeners();
  }

  Future<void> addProduct(ProductModel product) async {
    final newProduct = await _supabaseService.addProduct(product.toJson());
    _products.insert(0, newProduct);
    notifyListeners();
  }

  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    await _supabaseService.updateProduct(productId, data);
    final index = _products.indexWhere((p) => p.id == productId);
    if (index != -1) {
      _products[index] = ProductModel.fromJson(data);
      notifyListeners();
    }
  }

  Future<void> deleteProduct(String productId) async {
    await _supabaseService.deleteProduct(productId);
    _products.removeWhere((p) => p.id == productId);
    notifyListeners();
  }

  Future<void> toggleFavorite(String userId, String productId) async {
    if (_favoriteIds.contains(productId)) {
      await _supabaseService.removeFromFavorites(userId, productId);
      _favoriteIds.remove(productId);
    } else {
      await _supabaseService.addToFavorites(userId, productId);
      _favoriteIds.add(productId);
    }
    notifyListeners();
  }

  Future<void> fetchFavorites(String userId) async {
    _favoriteIds = await _supabaseService.getFavorites(userId);
    notifyListeners();
  }
}
