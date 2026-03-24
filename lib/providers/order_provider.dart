import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';
import '../services/supabase_service.dart';

class CartItem {
  final String productId;
  final String name;
  final double price;
  final int quantity;
  final String? imageUrl;

  CartItem({
    required this.productId,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.imageUrl,
  });

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'name': name,
    'price': price,
    'quantity': quantity,
    'imageUrl': imageUrl,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'],
    name: json['name'],
    price: (json['price'] as num).toDouble(),
    quantity: json['quantity'],
    imageUrl: json['imageUrl'],
  );
}

class OrderProvider extends ChangeNotifier {
  List<CartItem> _cartItems = [];
  List<Map<String, dynamic>> _orders = [];

  List<CartItem> get cartItems => _cartItems;
  List<Map<String, dynamic>> get orders => _orders;

  Future<void> init() async {
    final cartData = LocalStorageService.getCartItems();
    _cartItems = cartData.map((e) => CartItem.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> loadOrders(String userId) async {
    _orders = await SupabaseService.getUserOrders(userId);
    notifyListeners();
  }

  Future<void> addToCart(CartItem item) async {
    _cartItems.add(item);
    final jsonList = _cartItems.map((e) => e.toJson()).toList();
    await LocalStorageService.saveCartItems(jsonList);
    notifyListeners();
  }

  Future<void> removeFromCart(String productId) async {
    _cartItems.removeWhere((item) => item.productId == productId);
    final jsonList = _cartItems.map((e) => e.toJson()).toList();
    await LocalStorageService.saveCartItems(jsonList);
    notifyListeners();
  }

  Future<void> clearCart() async {
    _cartItems.clear();
    await LocalStorageService.saveCartItems([]);
    notifyListeners();
  }

  Future<void> createOrder(Map<String, dynamic> orderData) async {
    final order = await SupabaseService.createOrder(orderData);
    _orders.insert(0, order);
    await clearCart();
    notifyListeners();
  }
}
