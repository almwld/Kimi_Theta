// موفر المنتجات - إدارة حالة المنتجات
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';
import '../services/supabase_service.dart';
import '../services/local_storage_service.dart';

class ProductProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  final LocalStorageService _localStorage = LocalStorageService();

  List<ProductModel> _products = [];
  List<ProductModel> _featuredProducts = [];
  List<ProductModel> _auctionProducts = [];
  List<ProductModel> _userProducts = [];
  List<ProductModel> _favoriteProducts = [];
  List<String> _favoriteIds = [];
  ProductModel? _selectedProduct;
  bool _isLoading = false;
  bool _isLoadingMore = false;
  String? _error;
  int _currentPage = 0;
  bool _hasMore = true;
  String? _currentCategory;
  String? _searchQuery;

  // getters
  List<ProductModel> get products => _products;
  List<ProductModel> get featuredProducts => _featuredProducts;
  List<ProductModel> get auctionProducts => _auctionProducts;
  List<ProductModel> get userProducts => _userProducts;
  List<ProductModel> get favoriteProducts => _favoriteProducts;
  List<String> get favoriteIds => _favoriteIds;
  ProductModel? get selectedProduct => _selectedProduct;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  String? get error => _error;
  bool get hasMore => _hasMore;

  // تهيئة الموفر
  Future<void> initialize() async {
    _favoriteIds = _localStorage.getFavoriteIds();
    await loadProducts();
    await loadFeaturedProducts();
    await loadAuctionProducts();
  }

  // تحميل المنتجات
  Future<void> loadProducts({
    bool refresh = false,
    String? category,
    String? search,
  }) async {
    if (refresh) {
      _currentPage = 0;
      _hasMore = true;
      _products = [];
    }

    if (!_hasMore || _isLoadingMore) return;

    if (_currentPage == 0) {
      _setLoading(true);
    } else {
      _isLoadingMore = true;
      notifyListeners();
    }

    _clearError();

    try {
      final newProducts = await _supabaseService.getProducts(
        page: _currentPage,
        category: category ?? _currentCategory,
        search: search ?? _searchQuery,
      );

      if (newProducts.isEmpty) {
        _hasMore = false;
      } else {
        if (_currentPage == 0) {
          _products = newProducts;
        } else {
          _products.addAll(newProducts);
        }
        _currentPage++;
      }
    } catch (e) {
      _setError('فشل تحميل المنتجات');
    } finally {
      _setLoading(false);
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  // تحميل المزيد من المنتجات
  Future<void> loadMore() async {
    await loadProducts();
  }

  // تحميل المنتجات المميزة
  Future<void> loadFeaturedProducts() async {
    try {
      final products = await _supabaseService.getProducts(
        limit: 10,
      );
      _featuredProducts = products.take(6).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading featured products: $e');
    }
  }

  // تحميل منتجات المزاد
  Future<void> loadAuctionProducts() async {
    try {
      // محاكاة منتجات المزاد
      _auctionProducts = [];
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading auction products: $e');
    }
  }

  // الحصول على منتج واحد
  Future<ProductModel?> getProduct(String productId) async {
    _setLoading(true);
    _clearError();

    try {
      final product = await _supabaseService.getProduct(productId);
      _selectedProduct = product;
      notifyListeners();
      return product;
    } catch (e) {
      _setError('فشل تحميل المنتج');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // إضافة منتج
  Future<bool> addProduct(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      final product = await _supabaseService.addProduct(data);
      if (product != null) {
        _products.insert(0, product);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('فشل إضافة المنتج');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // تحديث منتج
  Future<bool> updateProduct(
    String productId,
    Map<String, dynamic> data,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      await _supabaseService.updateProduct(productId, data);
      
      // تحديث القائمة المحلية
      final index = _products.indexWhere((p) => p.id == productId);
      if (index >= 0) {
        _products[index] = _products[index];
        notifyListeners();
      }
      
      return true;
    } catch (e) {
      _setError('فشل تحديث المنتج');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // حذف منتج
  Future<bool> deleteProduct(String productId) async {
    _setLoading(true);
    _clearError();

    try {
      await _supabaseService.deleteProduct(productId);
      _products.removeWhere((p) => p.id == productId);
      notifyListeners();
      return true;
    } catch (e) {
      _setError('فشل حذف المنتج');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // البحث عن منتجات
  Future<void> searchProducts(String query) async {
    _searchQuery = query;
    await loadProducts(refresh: true, search: query);
  }

  // تصفية حسب الفئة
  Future<void> filterByCategory(String? category) async {
    _currentCategory = category;
    await loadProducts(refresh: true, category: category);
  }

  // إضافة إلى المفضلة
  Future<void> addToFavorites(String productId) async {
    try {
      await _supabaseService.addToFavorites('current_user_id', productId);
      await _localStorage.addToFavorites(productId);
      _favoriteIds.add(productId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
    }
  }

  // إزالة من المفضلة
  Future<void> removeFromFavorites(String productId) async {
    try {
      await _supabaseService.removeFromFavorites('current_user_id', productId);
      await _localStorage.removeFromFavorites(productId);
      _favoriteIds.remove(productId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
    }
  }

  // تبديل المفضلة
  Future<void> toggleFavorite(String productId) async {
    if (_favoriteIds.contains(productId)) {
      await removeFromFavorites(productId);
    } else {
      await addToFavorites(productId);
    }
  }

  // التحقق من المفضلة
  bool isFavorite(String productId) {
    return _favoriteIds.contains(productId);
  }

  // تحميل المفضلة
  Future<void> loadFavorites(String userId) async {
    try {
      _favoriteIds = await _supabaseService.getFavorites(userId);
      await _localStorage.saveFavoriteProducts(
        _products.where((p) => _favoriteIds.contains(p.id)).toList(),
      );
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  // مساعدات
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _error = message;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void clearSelectedProduct() {
    _selectedProduct = null;
    notifyListeners();
  }
}
