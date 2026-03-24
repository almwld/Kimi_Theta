import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static const String _userBox = 'user_box';
  static const String _settingsBox = 'settings_box';
  static const String _cartBox = 'cart_box';

  static late Box _userBoxInstance;
  static late Box _settingsBoxInstance;
  static late Box _cartBoxInstance;

  LocalStorageService._();

  static final LocalStorageService _instance = LocalStorageService._();
  factory LocalStorageService() => _instance;

  static Future<void> init() async {
    await Hive.initFlutter();
    _userBoxInstance = await Hive.openBox(_userBox);
    _settingsBoxInstance = await Hive.openBox(_settingsBox);
    _cartBoxInstance = await Hive.openBox(_cartBox);
  }

  // User
  void saveUser(Map<String, dynamic> user) {
    _userBoxInstance.put('user', user);
  }

  Map<String, dynamic>? getUser() {
    return _userBoxInstance.get('user');
  }

  void clearUser() {
    _userBoxInstance.delete('user');
  }

  // Settings
  bool getDarkMode() {
    return _settingsBoxInstance.get('darkMode', defaultValue: false);
  }

  void setDarkMode(bool value) {
    _settingsBoxInstance.put('darkMode', value);
  }

  String getLanguage() {
    return _settingsBoxInstance.get('language', defaultValue: 'ar');
  }

  void setLanguage(String value) {
    _settingsBoxInstance.put('language', value);
  }

  // Cart
  List<dynamic> getCartItems() {
    return _cartBoxInstance.get('items', defaultValue: []);
  }

  void addToCart(dynamic item) {
    final items = getCartItems();
    items.add(item);
    _cartBoxInstance.put('items', items);
  }

  void removeFromCart(int index) {
    final items = getCartItems();
    items.removeAt(index);
    _cartBoxInstance.put('items', items);
  }

  void clearCart() {
    _cartBoxInstance.delete('items');
  }
}
