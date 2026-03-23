// خدمة التخزين المحلي باستخدام Hive
import 'dart:convert';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../core/constants/app_constants.dart';

class LocalStorageService {
  static final LocalStorageService _instance = LocalStorageService._internal();
  factory LocalStorageService() => _instance;
  LocalStorageService._internal();

  bool _initialized = false;
  
  // الصناديق
  Box? _userBox;
  Box? _settingsBox;
  Box? _favoritesBox;
  Box? _cartBox;
  Box? _searchHistoryBox;
  Box? _cacheBox;

  // تهيئة Hive
  Future<void> initialize() async {
    if (_initialized) return;
    
    await Hive.initFlutter();
    
    // تسجيل المحولات
    Hive.registerAdapter(UserModelAdapter());
    Hive.registerAdapter(ProductModelAdapter());
    
    // فتح الصناديق
    _userBox = await Hive.openBox(AppConstants.hiveBoxUser);
    _settingsBox = await Hive.openBox(AppConstants.hiveBoxSettings);
    _favoritesBox = await Hive.openBox(AppConstants.hiveBoxFavorites);
    _cartBox = await Hive.openBox(AppConstants.hiveBoxCart);
    _searchHistoryBox = await Hive.openBox(AppConstants.hiveBoxSearchHistory);
    _cacheBox = await Hive.openBox(AppConstants.hiveBoxCache);
    
    _initialized = true;
  }

  // ==================== المستخدم ====================

  Future<void> saveUser(UserModel user) async {
    await _userBox?.put('current_user', user);
  }

  UserModel? getUser() {
    return _userBox?.get('current_user') as UserModel?;
  }

  Future<void> clearUser() async {
    await _userBox?.delete('current_user');
  }

  bool get isLoggedIn => getUser() != null;

  // ==================== الإعدادات ====================

  Future<void> setDarkMode(bool value) async {
    await _settingsBox?.put('dark_mode', value);
  }

  bool getDarkMode() {
    return _settingsBox?.get('dark_mode') ?? AppConstants.defaultDarkMode;
  }

  Future<void> setLanguage(String language) async {
    await _settingsBox?.put('language', language);
  }

  String getLanguage() {
    return _settingsBox?.get('language') ?? AppConstants.defaultLanguage;
  }

  Future<void> setNotificationsEnabled(bool value) async {
    await _settingsBox?.put('notifications_enabled', value);
  }

  bool getNotificationsEnabled() {
    return _settingsBox?.get('notifications_enabled') ?? 
        AppConstants.defaultNotifications;
  }

  Future<void> setBiometricEnabled(bool value) async {
    await _settingsBox?.put('biometric_enabled', value);
  }

  bool getBiometricEnabled() {
    return _settingsBox?.get('biometric_enabled') ?? 
        AppConstants.defaultBiometric;
  }

  // ==================== المفضلة ====================

  Future<void> addToFavorites(String productId) async {
    final favorites = getFavoriteIds();
    if (!favorites.contains(productId)) {
      favorites.add(productId);
      await _favoritesBox?.put('favorite_ids', favorites);
    }
  }

  Future<void> removeFromFavorites(String productId) async {
    final favorites = getFavoriteIds();
    favorites.remove(productId);
    await _favoritesBox?.put('favorite_ids', favorites);
  }

  List<String> getFavoriteIds() {
    return (_favoritesBox?.get('favorite_ids') as List<dynamic>?)
            ?.cast<String>() ??
        [];
  }

  bool isFavorite(String productId) {
    return getFavoriteIds().contains(productId);
  }

  Future<void> saveFavoriteProducts(List<ProductModel> products) async {
    await _favoritesBox?.put('favorite_products', products);
  }

  List<ProductModel> getFavoriteProducts() {
    return (_favoritesBox?.get('favorite_products') as List<dynamic>?)
            ?.cast<ProductModel>() ??
        [];
  }

  // ==================== سلة التسوق ====================

  Future<void> addToCart(CartItem item) async {
    final cart = getCartItems();
    final existingIndex = cart.indexWhere((i) => i.productId == item.productId);
    
    if (existingIndex >= 0) {
      cart[existingIndex] = CartItem(
        productId: item.productId,
        productName: item.productName,
        productImage: item.productImage,
        price: item.price,
        quantity: cart[existingIndex].quantity + item.quantity,
      );
    } else {
      cart.add(item);
    }
    
    await _cartBox?.put('cart_items', cart.map((e) => e.toJson()).toList());
  }

  Future<void> removeFromCart(String productId) async {
    final cart = getCartItems();
    cart.removeWhere((i) => i.productId == productId);
    await _cartBox?.put('cart_items', cart.map((e) => e.toJson()).toList());
  }

  Future<void> updateCartItemQuantity(String productId, int quantity) async {
    final cart = getCartItems();
    final index = cart.indexWhere((i) => i.productId == productId);
    
    if (index >= 0) {
      if (quantity <= 0) {
        cart.removeAt(index);
      } else {
        cart[index] = CartItem(
          productId: cart[index].productId,
          productName: cart[index].productName,
          productImage: cart[index].productImage,
          price: cart[index].price,
          quantity: quantity,
        );
      }
      await _cartBox?.put('cart_items', cart.map((e) => e.toJson()).toList());
    }
  }

  List<CartItem> getCartItems() {
    final items = _cartBox?.get('cart_items') as List<dynamic>?;
    return items?.map((e) => CartItem.fromJson(e as Map<String, dynamic>)).toList() ?? [];
  }

  Future<void> clearCart() async {
    await _cartBox?.delete('cart_items');
  }

  int getCartItemCount() {
    return getCartItems().fold(0, (sum, item) => sum + item.quantity);
  }

  double getCartTotal() {
    return getCartItems().fold(0, (sum, item) => sum + item.total);
  }

  // ==================== سجل البحث ====================

  Future<void> addSearchQuery(String query) async {
    if (query.trim().isEmpty) return;
    
    final history = getSearchHistory();
    history.remove(query);
    history.insert(0, query);
    
    // الاحتفاظ بآخر 20 بحث فقط
    if (history.length > 20) {
      history.removeRange(20, history.length);
    }
    
    await _searchHistoryBox?.put('search_history', history);
  }

  Future<void> removeSearchQuery(String query) async {
    final history = getSearchHistory();
    history.remove(query);
    await _searchHistoryBox?.put('search_history', history);
  }

  Future<void> clearSearchHistory() async {
    await _searchHistoryBox?.delete('search_history');
  }

  List<String> getSearchHistory() {
    return (_searchHistoryBox?.get('search_history') as List<dynamic>?)
            ?.cast<String>() ??
        [];
  }

  // ==================== التخزين المؤقت ====================

  Future<void> cacheData(String key, dynamic data, {Duration? expiry}) async {
    final cacheEntry = {
      'data': data,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'expiry': expiry?.inMilliseconds,
    };
    await _cacheBox?.put(key, cacheEntry);
  }

  dynamic getCachedData(String key) {
    final cacheEntry = _cacheBox?.get(key) as Map<dynamic, dynamic>?;
    if (cacheEntry == null) return null;
    
    final timestamp = cacheEntry['timestamp'] as int;
    final expiry = cacheEntry['expiry'] as int?;
    
    if (expiry != null) {
      final age = DateTime.now().millisecondsSinceEpoch - timestamp;
      if (age > expiry) {
        _cacheBox?.delete(key);
        return null;
      }
    }
    
    return cacheEntry['data'];
  }

  Future<void> clearCache() async {
    await _cacheBox?.clear();
  }

  // ==================== مسح جميع البيانات ====================

  Future<void> clearAll() async {
    await _userBox?.clear();
    await _settingsBox?.clear();
    await _favoritesBox?.clear();
    await _cartBox?.clear();
    await _searchHistoryBox?.clear();
    await _cacheBox?.clear();
  }
}

// نموذج عنصر السلة
class CartItem {
  final String productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;

  CartItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
  });

  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      productImage: json['product_image'],
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
    };
  }

  double get total => price * quantity;
}

// محولات Hive
class UserModelAdapter extends TypeAdapter<UserModel> {
  @override
  final int typeId = 1;

  @override
  UserModel read(BinaryReader reader) {
    return UserModel.fromJson(jsonDecode(reader.readString()));
  }

  @override
  void write(BinaryWriter writer, UserModel obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}

class ProductModelAdapter extends TypeAdapter<ProductModel> {
  @override
  final int typeId = 2;

  @override
  ProductModel read(BinaryReader reader) {
    return ProductModel.fromJson(jsonDecode(reader.readString()));
  }

  @override
  void write(BinaryWriter writer, ProductModel obj) {
    writer.writeString(jsonEncode(obj.toJson()));
  }
}
