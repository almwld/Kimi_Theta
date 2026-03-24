import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String _userBox = 'userBox';
  static const String _settingsBox = 'settingsBox';
  static const String _favoritesBox = 'favoritesBox';
  static const String _cartBox = 'cartBox';

  static LocalStorageService? _instance;
  late Box _userBoxInstance;
  late Box _settingsBoxInstance;
  late Box _favoritesBoxInstance;
  late Box _cartBoxInstance;

  LocalStorageService._internal();

  static Future<LocalStorageService> init() async {
    if (_instance == null) {
      await Hive.initFlutter();
      _instance = LocalStorageService._internal();
      _instance!._userBoxInstance = await Hive.openBox(_userBox);
      _instance!._settingsBoxInstance = await Hive.openBox(_settingsBox);
      _instance!._favoritesBoxInstance = await Hive.openBox(_favoritesBox);
      _instance!._cartBoxInstance = await Hive.openBox(_cartBox);
    }
    return _instance!;
  }

  static LocalStorageService get instance => _instance!;

  // ===== المستخدم =====
  Future<void> saveUser(Map<String, dynamic> user) async {
    await _userBoxInstance.put('current_user', user);
  }

  Map<String, dynamic>? getUser() {
    return _userBoxInstance.get('current_user');
  }

  Future<void> clearUser() async {
    await _userBoxInstance.delete('current_user');
  }

  // ===== الإعدادات =====
  Future<void> setDarkMode(bool isDark) async {
    await _settingsBoxInstance.put('dark_mode', isDark);
  }

  bool getDarkMode() {
    return _settingsBoxInstance.get('dark_mode') ?? false;
  }

  Future<void> setLanguage(String lang) async {
    await _settingsBoxInstance.put('language', lang);
  }

  String getLanguage() {
    return _settingsBoxInstance.get('language') ?? 'ar';
  }

  // ===== المفضلة =====
  Future<void> addFavorite(String productId) async {
    List<String> favs = getFavorites();
    if (!favs.contains(productId)) {
      favs.add(productId);
      await _favoritesBoxInstance.put('favorites', favs);
    }
  }

  Future<void> removeFavorite(String productId) async {
    List<String> favs = getFavorites();
    favs.remove(productId);
    await _favoritesBoxInstance.put('favorites', favs);
  }

  List<String> getFavorites() {
    return _favoritesBoxInstance.get('favorites', defaultValue: <String>[]);
  }

  bool isFavorite(String productId) {
    return getFavorites().contains(productId);
  }

  // ===== سلة التسوق =====
  Future<void> saveCartItems(List<Map<String, dynamic>> items) async {
    await _cartBoxInstance.put('cart', items);
  }

  List<Map<String, dynamic>> getCartItems() {
    return _cartBoxInstance.get('cart', defaultValue: <Map<String, dynamic>>[]);
  }

  Future<void> addToCart(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> cart = getCartItems();
    cart.add(item);
    await saveCartItems(cart);
  }

  Future<void> removeFromCart(String productId) async {
    List<Map<String, dynamic>> cart = getCartItems();
    cart.removeWhere((item) => item['productId'] == productId);
    await saveCartItems(cart);
  }

  Future<void> clearCart() async {
    await _cartBoxInstance.delete('cart');
  }
}
