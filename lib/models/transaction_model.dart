// نموذج المعاملة
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'transaction_model.g.dart';

@HiveType(typeId: 9)
class TransactionModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String walletId;
  
  @HiveField(2)
  final String userId;
  
  @HiveField(3)
  final String type;
  
  @HiveField(4)
  final double amount;
  
  @HiveField(5)
  final String currency;
  
  @HiveField(6)
  final String? description;
  
  @HiveField(7)
  final String status;
  
  @HiveField(8)
  final String? recipientId;
  
  @HiveField(9)
  final String? recipientName;
  
  @HiveField(10)
  final String? referenceNumber;
  
  @HiveField(11)
  final DateTime createdAt;
  
  @HiveField(12)
  final String? metadata;

  TransactionModel({
    required this.id,
    required this.walletId,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    this.description,
    required this.status,
    this.recipientId,
    this.recipientName,
    this.referenceNumber,
    required this.createdAt,
    this.metadata,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] ?? '',
      walletId: json['wallet_id'] ?? '',
      userId: json['user_id'] ?? '',
      type: json['type'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? 'YER',
      description: json['description'],
      status: json['status'] ?? 'pending',
      recipientId: json['recipient_id'],
      recipientName: json['recipient_name'],
      referenceNumber: json['reference_number'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      metadata: json['metadata'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'wallet_id': walletId,
      'user_id': userId,
      'type': type,
      'amount': amount,
      'currency': currency,
      'description': description,
      'status': status,
      'recipient_id': recipientId,
      'recipient_name': recipientName,
      'reference_number': referenceNumber,
      'created_at': createdAt.toIso8601String(),
      'metadata': metadata,
    };
  }

  String get typeText {
    switch (type) {
      case 'deposit':
        return 'إيداع';
      case 'withdraw':
        return 'سحب';
      case 'transfer':
        return 'تحويل';
      case 'payment':
        return 'دفع';
      case 'refund':
        return 'استرجاع';
      case 'receive':
        return 'استلام';
      case 'fee':
        return 'رسوم';
      default:
        return 'معاملة';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case 'deposit':
        return Icons.arrow_downward;
      case 'withdraw':
        return Icons.arrow_upward;
      case 'transfer':
        return Icons.swap_horiz;
      case 'payment':
        return Icons.payment;
      case 'refund':
        return Icons.replay;
      case 'receive':
        return Icons.call_received;
      case 'fee':
        return Icons.account_balance_wallet;
      default:
        return Icons.receipt;
    }
  }

  Color get typeColor {
    switch (type) {
      case 'deposit':
      case 'receive':
      case 'refund':
        return Colors.green;
      case 'withdraw':
      case 'payment':
      case 'fee':
        return Colors.red;
      case 'transfer':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }

  bool get isIncoming {
    return type == 'deposit' || type == 'receive' || type == 'refund';
  }

  bool get isOutgoing {
    return type == 'withdraw' || type == 'payment' || type == 'fee';
  }

  String get formattedAmount {
    final symbol = _getCurrencySymbol(currency);
    final sign = isIncoming ? '+' : '-';
    return '$sign $amount $symbol';
  }

  String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'YER':
        return 'ر.ي';
      case 'SAR':
        return 'ر.س';
      case 'USD':
        return '\$';
      default:
        return currency;
    }
  }
}
