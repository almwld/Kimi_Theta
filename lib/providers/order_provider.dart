import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/local_storage_service.dart';

class CartItem {
  final String productId;
  final String productName;
  final double price;
  final int quantity;
  final String? imageUrl;

  CartItem({required this.productId, required this.productName, required this.price, required this.quantity, this.imageUrl});

  Map<String, dynamic> toJson() => {
    'productId': productId,
    'productName': productName,
    'price': price,
    'quantity': quantity,
    'imageUrl': imageUrl,
  };

  factory CartItem.fromJson(Map<String, dynamic> json) => CartItem(
    productId: json['productId'],
    productName: json['productName'],
    price: json['price'],
    quantity: json['quantity'],
    imageUrl: json['imageUrl'],
  );
}

class OrderProvider extends ChangeNotifier {
  final LocalStorageService _localStorage = LocalStorageService();
  List<CartItem> _cartItems = [];
  List<Map<String, dynamic>> _orders = [];
  Map<String, dynamic>? _currentOrder;
  bool _isLoading = false;
  String? _error;

  List<CartItem> get cartItems => _cartItems;
  List<Map<String, dynamic>> get orders => _orders;
  Map<String, dynamic>? get currentOrder => _currentOrder;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get cartTotal => _cartItems.fold(0, (sum, item) => sum + (item.price * item.quantity));

  OrderProvider() {
    _loadCart();
  }

  void _loadCart() {
    _cartItems = _localStorage.getCartItems();
    notifyListeners();
  }

  void addToCart(CartItem item) {
    _cartItems.add(item);
    _localStorage.addToCart(item);
    notifyListeners();
  }

  void removeFromCart(int index) {
    _cartItems.removeAt(index);
    _localStorage.saveCartItems(_cartItems);
    notifyListeners();
  }

  void clearCart() {
    _cartItems.clear();
    _localStorage.clearCart();
    notifyListeners();
  }

  Future<void> loadOrders(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _orders = await SupabaseService.getUserOrders(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> createOrder(Map<String, dynamic> orderData) async {
    _isLoading = true;
    notifyListeners();

    try {
      final order = await SupabaseService.createOrder(orderData);
      _currentOrder = order;
      _orders.insert(0, order);
      clearCart();
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    _isLoading = true;
    notifyListeners();

    try {
      await SupabaseService.updateOrderStatus(orderId, status);
      await loadOrders(SupabaseService.currentUser!.id);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }
}
