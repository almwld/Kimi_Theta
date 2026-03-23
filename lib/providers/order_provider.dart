import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/order_model.dart';

class OrderProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<OrderModel> _orders = [];
  OrderModel? _currentOrder;

  List<OrderModel> get orders => _orders;
  OrderModel? get currentOrder => _currentOrder;

  Future<void> fetchOrders(String userId) async {
    _orders = await _supabaseService.getUserOrders(userId);
    notifyListeners();
  }

  Future<void> createOrder(Map<String, dynamic> data) async {
    final order = await _supabaseService.createOrder(data);
    _orders.insert(0, order);
    notifyListeners();
  }

  Future<void> cancelOrder(String orderId) async {
    await _supabaseService.updateOrderStatus(orderId, 'cancelled');
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = OrderModel(
        id: _orders[index].id,
        userId: _orders[index].userId,
        total: _orders[index].total,
        status: 'cancelled',
        shippingAddress: _orders[index].shippingAddress,
        paymentMethod: _orders[index].paymentMethod,
        createdAt: _orders[index].createdAt,
      );
      notifyListeners();
    }
  }
}
