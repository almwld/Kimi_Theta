import 'package:hive_flutter/hive_flutter.dart';

class LocalStorageService {
  static late Box _box;

  static Future<void> init() async {
    await Hive.initFlutter();
    _box = await Hive.openBox('flex_cache');
  }

  // User
  void saveUser(Map<String, dynamic> user) => _box.put('user', user);
  Map<String, dynamic>? getUser() => _box.get('user');
  void clearUser() => _box.delete('user');

  // Cart
  void addToCart(dynamic item) {
    List cart = _box.get('cart', defaultValue: []);
    cart.add(item.toJson());
    _box.put('cart', cart);
  }

  List<dynamic> getCartItems() {
    final cart = _box.get('cart', defaultValue: []);
    // Assuming CartItem has fromJson; we'll handle in OrderProvider.
    return cart;
  }

  void saveCartItems(List<dynamic> items) {
    _box.put('cart', items.map((e) => e.toJson()).toList());
  }

  void clearCart() => _box.delete('cart');

  // Theme
  void saveThemeMode(String mode) => _box.put('theme_mode', mode);
  String? getThemeMode() => _box.get('theme_mode');
}
