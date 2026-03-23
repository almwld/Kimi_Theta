// نموذج الطلب
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'order_model.g.dart';

@HiveType(typeId: 4)
class OrderModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final String sellerId;
  
  @HiveField(3)
  final List<OrderItem> items;
  
  @HiveField(4)
  final double totalAmount;
  
  @HiveField(5)
  final double shippingCost;
  
  @HiveField(6)
  final String status;
  
  @HiveField(7)
  final String paymentMethod;
  
  @HiveField(8)
  final String? paymentStatus;
  
  @HiveField(9)
  final String shippingAddress;
  
  @HiveField(10)
  final String? phone;
  
  @HiveField(11)
  final String? notes;
  
  @HiveField(12)
  final DateTime createdAt;
  
  @HiveField(13)
  final DateTime? updatedAt;
  
  @HiveField(14)
  final DateTime? deliveredAt;
  
  @HiveField(15)
  final String? trackingNumber;

  OrderModel({
    required this.id,
    required this.userId,
    required this.sellerId,
    required this.items,
    required this.totalAmount,
    this.shippingCost = 0,
    required this.status,
    required this.paymentMethod,
    this.paymentStatus,
    required this.shippingAddress,
    this.phone,
    this.notes,
    required this.createdAt,
    this.updatedAt,
    this.deliveredAt,
    this.trackingNumber,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      sellerId: json['seller_id'] ?? '',
      items: (json['items'] as List?)
          ?.map((e) => OrderItem.fromJson(e))
          .toList() ?? [],
      totalAmount: (json['total_amount'] ?? 0.0).toDouble(),
      shippingCost: (json['shipping_cost'] ?? 0.0).toDouble(),
      status: json['status'] ?? 'pending',
      paymentMethod: json['payment_method'] ?? '',
      paymentStatus: json['payment_status'],
      shippingAddress: json['shipping_address'] ?? '',
      phone: json['phone'],
      notes: json['notes'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : null,
      deliveredAt: json['delivered_at'] != null 
          ? DateTime.parse(json['delivered_at']) 
          : null,
      trackingNumber: json['tracking_number'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'seller_id': sellerId,
      'items': items.map((e) => e.toJson()).toList(),
      'total_amount': totalAmount,
      'shipping_cost': shippingCost,
      'status': status,
      'payment_method': paymentMethod,
      'payment_status': paymentStatus,
      'shipping_address': shippingAddress,
      'phone': phone,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'delivered_at': deliveredAt?.toIso8601String(),
      'tracking_number': trackingNumber,
    };
  }

  String get statusText {
    switch (status) {
      case 'pending':
        return 'قيد الانتظار';
      case 'confirmed':
        return 'تم التأكيد';
      case 'processing':
        return 'قيد المعالجة';
      case 'shipped':
        return 'تم الشحن';
      case 'delivered':
        return 'تم التوصيل';
      case 'cancelled':
        return 'ملغي';
      case 'refunded':
        return 'مسترجع';
      default:
        return 'غير معروف';
    }
  }

  Color get statusColor {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'processing':
        return Colors.purple;
      case 'shipped':
        return Colors.indigo;
      case 'delivered':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      case 'refunded':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }
}

@HiveType(typeId: 5)
class OrderItem {
  @HiveField(0)
  final String productId;
  
  @HiveField(1)
  final String productName;
  
  @HiveField(2)
  final String? productImage;
  
  @HiveField(3)
  final double price;
  
  @HiveField(4)
  final int quantity;
  
  @HiveField(5)
  final String? variant;

  OrderItem({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    this.variant,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      productImage: json['product_image'],
      price: (json['price'] ?? 0.0).toDouble(),
      quantity: json['quantity'] ?? 1,
      variant: json['variant'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'variant': variant,
    };
  }

  double get total => price * quantity;
}
