// خدمة الدفع والمعاملات المالية
import 'package:flutter/foundation.dart';

class PaymentService {
  static final PaymentService _instance = PaymentService._internal();
  factory PaymentService() => _instance;
  PaymentService._internal();

  // محاكاة عملية الدفع
  Future<PaymentResult> processPayment({
    required double amount,
    required String currency,
    required String paymentMethod,
    required String description,
    Map<String, dynamic>? metadata,
  }) async {
    try {
      // محاكاة تأخير الشبكة
      await Future.delayed(Duration(seconds: 2));

      // محاكاة نجاح الدفع (90% نجاح)
      final isSuccess = DateTime.now().millisecond % 10 != 0;

      if (isSuccess) {
        return PaymentResult.success(
          transactionId: 'TXN${DateTime.now().millisecondsSinceEpoch}',
          amount: amount,
          currency: currency,
          timestamp: DateTime.now(),
        );
      } else {
        return PaymentResult.failure(
          errorMessage: 'فشلت عملية الدفع، يرجى المحاولة مرة أخرى',
        );
      }
    } catch (e) {
      debugPrint('Payment error: $e');
      return PaymentResult.failure(
        errorMessage: 'حدث خطأ أثناء معالجة الدفع',
      );
    }
  }

  // محاكاة الإيداع
  Future<PaymentResult> deposit({
    required double amount,
    required String currency,
    required String method,
    String? referenceNumber,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    return PaymentResult.success(
      transactionId: 'DEP${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      currency: currency,
      timestamp: DateTime.now(),
    );
  }

  // محاكاة السحب
  Future<PaymentResult> withdraw({
    required double amount,
    required String currency,
    required String method,
    required String accountNumber,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    return PaymentResult.success(
      transactionId: 'WDR${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      currency: currency,
      timestamp: DateTime.now(),
    );
  }

  // محاكاة التحويل
  Future<PaymentResult> transfer({
    required double amount,
    required String currency,
    required String recipientId,
    String? recipientName,
    String? description,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    return PaymentResult.success(
      transactionId: 'TRF${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      currency: currency,
      timestamp: DateTime.now(),
    );
  }

  // محاكاة دفع الفاتورة
  Future<PaymentResult> payBill({
    required double amount,
    required String billType,
    required String billNumber,
    required String currency,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    return PaymentResult.success(
      transactionId: 'BILL${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      currency: currency,
      timestamp: DateTime.now(),
    );
  }

  // محاكاة شحن الرصيد
  Future<PaymentResult> recharge({
    required double amount,
    required String phoneNumber,
    required String operator,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    return PaymentResult.success(
      transactionId: 'RCH${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      currency: 'YER',
      timestamp: DateTime.now(),
    );
  }

  // محاكاة شراء بطاقة هدايا
  Future<PaymentResult> purchaseGiftCard({
    required double amount,
    required String cardType,
    required String currency,
  }) async {
    await Future.delayed(Duration(seconds: 1));

    return PaymentResult.success(
      transactionId: 'GFT${DateTime.now().millisecondsSinceEpoch}',
      amount: amount,
      currency: currency,
      timestamp: DateTime.now(),
      metadata: {
        'card_code': 'XXXX-XXXX-XXXX-${DateTime.now().millisecond.toString().padLeft(4, '0')}',
      },
    );
  }

  // التحقق من حالة المعاملة
  Future<TransactionStatus> checkTransactionStatus(String transactionId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return TransactionStatus.completed;
  }

  // الحصول على سجل المعاملات
  Future<List<TransactionHistory>> getTransactionHistory({
    required String userId,
    int limit = 50,
  }) async {
    // بيانات وهمية للعرض
    return List.generate(
      10,
      (index) => TransactionHistory(
        id: 'TXN$index',
        type: index % 2 == 0 ? 'deposit' : 'payment',
        amount: (index + 1) * 1000.0,
        currency: 'YER',
        status: 'completed',
        description: 'معاملة وهمية ${index + 1}',
        timestamp: DateTime.now().subtract(Duration(days: index)),
      ),
    );
  }

  // تنسيق المبلغ
  String formatAmount(double amount, String currency) {
    String symbol;
    switch (currency) {
      case 'YER':
        symbol = 'ر.ي';
        break;
      case 'SAR':
        symbol = 'ر.س';
        break;
      case 'USD':
        symbol = '\$';
        break;
      default:
        symbol = currency;
    }

    final formatted = amount.toStringAsFixed(2);
    return '$formatted $symbol';
  }

  // التحقق من صحة رقم الهاتف
  bool isValidPhoneNumber(String phone) {
    // التحقق من أرقام اليمن
    final yemeniRegex = RegExp(r'^((\+967|00967|0)?[137]\d{8})$');
    return yemeniRegex.hasMatch(phone);
  }

  // تنسيق رقم الهاتف
  String formatPhoneNumber(String phone) {
    if (phone.startsWith('+967')) {
      return phone;
    } else if (phone.startsWith('00967')) {
      return '+967${phone.substring(5)}';
    } else if (phone.startsWith('0')) {
      return '+967${phone.substring(1)}';
    }
    return '+967$phone';
  }
}

// نتيجة الدفع
class PaymentResult {
  final bool success;
  final String? transactionId;
  final double? amount;
  final String? currency;
  final DateTime? timestamp;
  final String? errorMessage;
  final Map<String, dynamic>? metadata;

  PaymentResult._({
    required this.success,
    this.transactionId,
    this.amount,
    this.currency,
    this.timestamp,
    this.errorMessage,
    this.metadata,
  });

  factory PaymentResult.success({
    required String transactionId,
    required double amount,
    required String currency,
    required DateTime timestamp,
    Map<String, dynamic>? metadata,
  }) {
    return PaymentResult._(
      success: true,
      transactionId: transactionId,
      amount: amount,
      currency: currency,
      timestamp: timestamp,
      metadata: metadata,
    );
  }

  factory PaymentResult.failure({
    required String errorMessage,
  }) {
    return PaymentResult._(
      success: false,
      errorMessage: errorMessage,
    );
  }
}

// حالة المعاملة
enum TransactionStatus {
  pending,
  processing,
  completed,
  failed,
  cancelled,
  refunded,
}

// سجل المعاملة
class TransactionHistory {
  final String id;
  final String type;
  final double amount;
  final String currency;
  final String status;
  final String description;
  final DateTime timestamp;

  TransactionHistory({
    required this.id,
    required this.type,
    required this.amount,
    required this.currency,
    required this.status,
    required this.description,
    required this.timestamp,
  });

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
      default:
        return 'معاملة';
    }
  }
}

// أنواع الفواتير
class BillType {
  static const String electricity = 'electricity';
  static const String water = 'water';
  static const String internet = 'internet';
  static const String phone = 'phone';
  static const String gas = 'gas';
  static const String tv = 'tv';
  static const String tax = 'tax';
  static const String fine = 'fine';

  static String getName(String type) {
    switch (type) {
      case electricity:
        return 'كهرباء';
      case water:
        return 'مياه';
      case internet:
        return 'إنترنت';
      case phone:
        return 'هاتف';
      case gas:
        return 'غاز';
      case tv:
        return 'تلفزيون';
      case tax:
        return 'ضرائب';
      case fine:
        return 'مخالفات';
      default:
        return 'فاتورة';
    }
  }
}

// شركات الاتصالات
class TelecomOperator {
  static const String sabafon = 'sabafon';
  static const String yemenMobile = 'yemen_mobile';
  static const String you = 'you';
  static const String y = 'y';

  static String getName(String operator) {
    switch (operator) {
      case sabafon:
        return 'صبافون';
      case yemenMobile:
        return 'يمن موبايل';
      case you:
        return 'YOU';
      case y:
        return 'Y';
      default:
        return 'مشغل';
    }
  }
}
