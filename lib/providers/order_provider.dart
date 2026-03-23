// موفر الطلبات - إدارة حالة الطلبات والسلة
import 'package:flutter/foundation.dart';
import '../models/order_model.dart';
import '../services/supabase_service.dart';
import '../services/local_storage_service.dart';

class OrderProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  final LocalStorageService _localStorage = LocalStorageService();

  List<OrderModel> _orders = [];
  List<OrderModel> _pendingOrders = [];
  OrderModel? _currentOrder;
  List<CartItem> _cartItems = [];
  bool _isLoading = false;
  String? _error;
  double _cartTotal = 0;

  // getters
  List<OrderModel> get orders => _orders;
  List<OrderModel> get pendingOrders => _pendingOrders;
  OrderModel? get currentOrder => _currentOrder;
  List<CartItem> get cartItems => _cartItems;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get cartTotal => _cartTotal;
  int get cartItemCount => _cartItems.fold(0, (sum, item) => sum + item.quantity);
  bool get isCartEmpty => _cartItems.isEmpty;

  // تهيئة الموفر
  Future<void> initialize() async {
    _cartItems = _localStorage.getCartItems();
    _calculateCartTotal();
  }

  // ==================== سلة التسوق ====================

  // إضافة إلى السلة
  Future<void> addToCart(CartItem item) async {
    final existingIndex = _cartItems.indexWhere((i) => i.productId == item.productId);

    if (existingIndex >= 0) {
      _cartItems[existingIndex] = CartItem(
        productId: item.productId,
        productName: item.productName,
        productImage: item.productImage,
        price: item.price,
        quantity: _cartItems[existingIndex].quantity + item.quantity,
      );
    } else {
      _cartItems.add(item);
    }

    await _localStorage.addToCart(item);
    _calculateCartTotal();
    notifyListeners();
  }

  // إزالة من السلة
  Future<void> removeFromCart(String productId) async {
    _cartItems.removeWhere((i) => i.productId == productId);
    await _localStorage.removeFromCart(productId);
    _calculateCartTotal();
    notifyListeners();
  }

  // تحديث الكمية
  Future<void> updateQuantity(String productId, int quantity) async {
    final index = _cartItems.indexWhere((i) => i.productId == productId);

    if (index >= 0) {
      if (quantity <= 0) {
        await removeFromCart(productId);
      } else {
        _cartItems[index] = CartItem(
          productId: _cartItems[index].productId,
          productName: _cartItems[index].productName,
          productImage: _cartItems[index].productImage,
          price: _cartItems[index].price,
          quantity: quantity,
        );
        await _localStorage.updateCartItemQuantity(productId, quantity);
        _calculateCartTotal();
        notifyListeners();
      }
    }
  }

  // زيادة الكمية
  Future<void> incrementQuantity(String productId) async {
    final item = _cartItems.firstWhere((i) => i.productId == productId);
    await updateQuantity(productId, item.quantity + 1);
  }

  // تقليل الكمية
  Future<void> decrementQuantity(String productId) async {
    final item = _cartItems.firstWhere((i) => i.productId == productId);
    await updateQuantity(productId, item.quantity - 1);
  }

  // مسح السلة
  Future<void> clearCart() async {
    _cartItems = [];
    _cartTotal = 0;
    await _localStorage.clearCart();
    notifyListeners();
  }

  // حساب المجموع
  void _calculateCartTotal() {
    _cartTotal = _cartItems.fold(0, (sum, item) => sum + item.total);
  }

  // ==================== الطلبات ====================

  // تحميل طلبات المستخدم
  Future<void> loadOrders(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _orders = await _supabaseService.getUserOrders(userId);
      _pendingOrders = _orders
          .where((o) => o.status == 'pending' || o.status == 'processing')
          .toList();
      notifyListeners();
    } catch (e) {
      _setError('فشل تحميل الطلبات');
    } finally {
      _setLoading(false);
    }
  }

  // إنشاء طلب
  Future<bool> createOrder({
    required String userId,
    required String sellerId,
    required String shippingAddress,
    required String paymentMethod,
    String? phone,
    String? notes,
    double shippingCost = 0,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      if (_cartItems.isEmpty) {
        _setError('السلة فارغة');
        return false;
      }

      final orderItems = _cartItems
          .map((item) => OrderItem(
                productId: item.productId,
                productName: item.productName,
                productImage: item.productImage,
                price: item.price,
                quantity: item.quantity,
              ))
          .toList();

      final order = await _supabaseService.createOrder({
        'user_id': userId,
        'seller_id': sellerId,
        'items': orderItems.map((e) => e.toJson()).toList(),
        'total_amount': _cartTotal,
        'shipping_cost': shippingCost,
        'status': 'pending',
        'payment_method': paymentMethod,
        'shipping_address': shippingAddress,
        'phone': phone,
        'notes': notes,
        'created_at': DateTime.now().toIso8601String(),
      });

      if (order != null) {
        _currentOrder = order;
        _orders.insert(0, order);
        await clearCart();
        notifyListeners();
        return true;
      }

      return false;
    } catch (e) {
      _setError('فشل إنشاء الطلب');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // إلغاء طلب
  Future<bool> cancelOrder(String orderId) async {
    _setLoading(true);
    _clearError();

    try {
      await _supabaseService.updateOrderStatus(orderId, 'cancelled');

      // تحديث القائمة المحلية
      final index = _orders.indexWhere((o) => o.id == orderId);
      if (index >= 0) {
        _orders[index] = OrderModel(
          id: _orders[index].id,
          userId: _orders[index].userId,
          sellerId: _orders[index].sellerId,
          items: _orders[index].items,
          totalAmount: _orders[index].totalAmount,
          shippingCost: _orders[index].shippingCost,
          status: 'cancelled',
          paymentMethod: _orders[index].paymentMethod,
          shippingAddress: _orders[index].shippingAddress,
          phone: _orders[index].phone,
          notes: _orders[index].notes,
          createdAt: _orders[index].createdAt,
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }

      return true;
    } catch (e) {
      _setError('فشل إلغاء الطلب');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // الحصول على تفاصيل الطلب
  OrderModel? getOrderById(String orderId) {
    return _orders.firstWhere(
      (o) => o.id == orderId,
      orElse: () => null as OrderModel,
    );
  }

  // تصفية الطلبات حسب الحالة
  List<OrderModel> getOrdersByStatus(String status) {
    return _orders.where((o) => o.status == status).toList();
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

  void clearCurrentOrder() {
    _currentOrder = null;
    notifyListeners();
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
