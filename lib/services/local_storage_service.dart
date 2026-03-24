import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String _userBox = 'userBox';
  static const String _settingsBox = 'settingsBox';
  static const String _favoritesBox = 'favoritesBox';
  static const String _cartBox = 'cartBox';

  static late Box _userBoxInstance;
  static late Box _settingsBoxInstance;
  static late Box _favoritesBoxInstance;
  static late Box _cartBoxInstance;

  static Future<void> init() async {
    await Hive.initFlutter();
    _userBoxInstance = await Hive.openBox(_userBox);
    _settingsBoxInstance = await Hive.openBox(_settingsBox);
    _favoritesBoxInstance = await Hive.openBox(_favoritesBox);
    _cartBoxInstance = await Hive.openBox(_cartBox);
  }

  // ===== المستخدم =====
  static Future<void> saveUser(Map<String, dynamic> user) async {
    await _userBoxInstance.put('current_user', user);
  }

  static Map<String, dynamic>? getUser() {
    return _userBoxInstance.get('current_user');
  }

  static Future<void> clearUser() async {
    await _userBoxInstance.delete('current_user');
  }

  // ===== الإعدادات =====
  static Future<void> setDarkMode(bool isDark) async {
    await _settingsBoxInstance.put('dark_mode', isDark);
  }

  static bool getDarkMode() {
    return _settingsBoxInstance.get('dark_mode') ?? false;
  }

  static Future<void> setLanguage(String lang) async {
    await _settingsBoxInstance.put('language', lang);
  }

  static String getLanguage() {
    return _settingsBoxInstance.get('language') ?? 'ar';
  }

  // ===== المفضلة =====
  static Future<void> addFavorite(String productId) async {
    List<String> favs = getFavorites();
    if (!favs.contains(productId)) {
      favs.add(productId);
      await _favoritesBoxInstance.put('favorites', favs);
    }
  }

  static Future<void> removeFavorite(String productId) async {
    List<String> favs = getFavorites();
    favs.remove(productId);
    await _favoritesBoxInstance.put('favorites', favs);
  }

  static List<String> getFavorites() {
    return _favoritesBoxInstance.get('favorites', defaultValue: <String>[]);
  }

  static bool isFavorite(String productId) {
    return getFavorites().contains(productId);
  }

  // ===== سلة التسوق =====
  static Future<void> saveCartItems(List<Map<String, dynamic>> items) async {
    await _cartBoxInstance.put('cart', items);
  }

  static List<Map<String, dynamic>> getCartItems() {
    return _cartBoxInstance.get('cart', defaultValue: <Map<String, dynamic>>[]);
  }

  static Future<void> addToCart(Map<String, dynamic> item) async {
    List<Map<String, dynamic>> cart = getCartItems();
    cart.add(item);
    await saveCartItems(cart);
  }

  static Future<void> removeFromCart(String productId) async {
    List<Map<String, dynamic>> cart = getCartItems();
    cart.removeWhere((item) => item['productId'] == productId);
    await saveCartItems(cart);
  }

  static Future<void> clearCart() async {
    await _cartBoxInstance.delete('cart');
  }
}
