// موفر المحفظة - إدارة حالة المحفظة والمعاملات
import 'package:flutter/foundation.dart';
import '../models/wallet_model.dart';
import '../models/transaction_model.dart';
import '../services/supabase_service.dart';
import '../services/payment_service.dart';

class WalletProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  final PaymentService _paymentService = PaymentService();

  WalletModel? _wallet;
  List<TransactionModel> _transactions = [];
  List<TransactionModel> _recentTransactions = [];
  bool _isLoading = false;
  String? _error;
  double _yerBalance = 0;
  double _sarBalance = 0;
  double _usdBalance = 0;

  // getters
  WalletModel? get wallet => _wallet;
  List<TransactionModel> get transactions => _transactions;
  List<TransactionModel> get recentTransactions => _recentTransactions;
  bool get isLoading => _isLoading;
  String? get error => _error;
  double get yerBalance => _yerBalance;
  double get sarBalance => _sarBalance;
  double get usdBalance => _usdBalance;

  // تهيئة الموفر
  Future<void> initialize(String userId) async {
    await loadWallet(userId);
    await loadTransactions();
  }

  // تحميل المحفظة
  Future<void> loadWallet(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      final walletData = await _supabaseService.getWallet(userId);
      if (walletData != null) {
        _wallet = WalletModel.fromJson(walletData);
        _yerBalance = _wallet!.yemeniRial;
        _sarBalance = _wallet!.saudiRiyal;
        _usdBalance = _wallet!.usDollar;
      } else {
        // إنشاء محفظة جديدة
        await _supabaseService.createWallet(userId);
        await loadWallet(userId);
        return;
      }
    } catch (e) {
      _setError('فشل تحميل المحفظة');
    } finally {
      _setLoading(false);
    }
  }

  // تحميل المعاملات
  Future<void> loadTransactions({int limit = 50}) async {
    _setLoading(true);
    _clearError();

    try {
      if (_wallet != null) {
        _transactions = await _supabaseService.getTransactions(
          _wallet!.id,
          limit: limit,
        );
        _recentTransactions = _transactions.take(5).toList();
      }
    } catch (e) {
      _setError('فشل تحميل المعاملات');
    } finally {
      _setLoading(false);
    }
  }

  // إيداع
  Future<bool> deposit({
    required double amount,
    required String currency,
    required String method,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await _paymentService.deposit(
        amount: amount,
        currency: currency,
        method: method,
      );

      if (result.success) {
        // تحديث الرصيد
        await _updateBalance(currency, amount);
        
        // إنشاء سجل المعاملة
        await _createTransaction(
          type: 'deposit',
          amount: amount,
          currency: currency,
          description: 'إيداع عبر $method',
          referenceNumber: result.transactionId,
        );

        await loadTransactions();
        return true;
      } else {
        _setError(result.errorMessage ?? 'فشل الإيداع');
        return false;
      }
    } catch (e) {
      _setError('فشل الإيداع');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // سحب
  Future<bool> withdraw({
    required double amount,
    required String currency,
    required String method,
    required String accountNumber,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // التحقق من الرصيد
      if (!_hasSufficientBalance(amount, currency)) {
        _setError('رصيد غير كافٍ');
        return false;
      }

      final result = await _paymentService.withdraw(
        amount: amount,
        currency: currency,
        method: method,
        accountNumber: accountNumber,
      );

      if (result.success) {
        // تحديث الرصيد
        await _updateBalance(currency, -amount);
        
        // إنشاء سجل المعاملة
        await _createTransaction(
          type: 'withdraw',
          amount: amount,
          currency: currency,
          description: 'سحب عبر $method',
          referenceNumber: result.transactionId,
        );

        await loadTransactions();
        return true;
      } else {
        _setError(result.errorMessage ?? 'فشل السحب');
        return false;
      }
    } catch (e) {
      _setError('فشل السحب');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // تحويل
  Future<bool> transfer({
    required double amount,
    required String currency,
    required String recipientId,
    String? recipientName,
    String? description,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // التحقق من الرصيد
      if (!_hasSufficientBalance(amount, currency)) {
        _setError('رصيد غير كافٍ');
        return false;
      }

      final result = await _paymentService.transfer(
        amount: amount,
        currency: currency,
        recipientId: recipientId,
        recipientName: recipientName,
        description: description,
      );

      if (result.success) {
        // تحديث الرصيد
        await _updateBalance(currency, -amount);
        
        // إنشاء سجل المعاملة
        await _createTransaction(
          type: 'transfer',
          amount: amount,
          currency: currency,
          description: 'تحويل إلى $recipientName',
          recipientId: recipientId,
          recipientName: recipientName,
          referenceNumber: result.transactionId,
        );

        await loadTransactions();
        return true;
      } else {
        _setError(result.errorMessage ?? 'فشل التحويل');
        return false;
      }
    } catch (e) {
      _setError('فشل التحويل');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // دفع فاتورة
  Future<bool> payBill({
    required double amount,
    required String billType,
    required String billNumber,
    required String currency,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // التحقق من الرصيد
      if (!_hasSufficientBalance(amount, currency)) {
        _setError('رصيد غير كافٍ');
        return false;
      }

      final result = await _paymentService.payBill(
        amount: amount,
        billType: billType,
        billNumber: billNumber,
        currency: currency,
      );

      if (result.success) {
        // تحديث الرصيد
        await _updateBalance(currency, -amount);
        
        // إنشاء سجل المعاملة
        await _createTransaction(
          type: 'payment',
          amount: amount,
          currency: currency,
          description: 'دفع فاتورة $billType - $billNumber',
          referenceNumber: result.transactionId,
        );

        await loadTransactions();
        return true;
      } else {
        _setError(result.errorMessage ?? 'فشل الدفع');
        return false;
      }
    } catch (e) {
      _setError('فشل دفع الفاتورة');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // شحن رصيد
  Future<bool> recharge({
    required double amount,
    required String phoneNumber,
    required String operator,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // التحقق من الرصيد
      if (!_hasSufficientBalance(amount, 'YER')) {
        _setError('رصيد غير كافٍ');
        return false;
      }

      final result = await _paymentService.recharge(
        amount: amount,
        phoneNumber: phoneNumber,
        operator: operator,
      );

      if (result.success) {
        // تحديث الرصيد
        await _updateBalance('YER', -amount);
        
        // إنشاء سجل المعاملة
        await _createTransaction(
          type: 'payment',
          amount: amount,
          currency: 'YER',
          description: 'شحن رصيد $operator - $phoneNumber',
          referenceNumber: result.transactionId,
        );

        await loadTransactions();
        return true;
      } else {
        _setError(result.errorMessage ?? 'فشل الشحن');
        return false;
      }
    } catch (e) {
      _setError('فشل شحن الرصيد');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // شراء بطاقة هدايا
  Future<bool> purchaseGiftCard({
    required double amount,
    required String cardType,
    required String currency,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // التحقق من الرصيد
      if (!_hasSufficientBalance(amount, currency)) {
        _setError('رصيد غير كافٍ');
        return false;
      }

      final result = await _paymentService.purchaseGiftCard(
        amount: amount,
        cardType: cardType,
        currency: currency,
      );

      if (result.success) {
        // تحديث الرصيد
        await _updateBalance(currency, -amount);
        
        // إنشاء سجل المعاملة
        await _createTransaction(
          type: 'payment',
          amount: amount,
          currency: currency,
          description: 'شراء بطاقة $cardType',
          referenceNumber: result.transactionId,
        );

        await loadTransactions();
        return true;
      } else {
        _setError(result.errorMessage ?? 'فشل الشراء');
        return false;
      }
    } catch (e) {
      _setError('فشل شراء البطاقة');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // التحقق من الرصيد الكافي
  bool _hasSufficientBalance(double amount, String currency) {
    switch (currency) {
      case 'YER':
        return _yerBalance >= amount;
      case 'SAR':
        return _sarBalance >= amount;
      case 'USD':
        return _usdBalance >= amount;
      default:
        return false;
    }
  }

  // تحديث الرصيد
  Future<void> _updateBalance(String currency, double amount) async {
    if (_wallet == null) return;

    await _supabaseService.updateBalance(_wallet!.id, currency, amount);

    switch (currency) {
      case 'YER':
        _yerBalance += amount;
        break;
      case 'SAR':
        _sarBalance += amount;
        break;
      case 'USD':
        _usdBalance += amount;
        break;
    }

    notifyListeners();
  }

  // إنشاء معاملة
  Future<void> _createTransaction({
    required String type,
    required double amount,
    required String currency,
    required String description,
    String? recipientId,
    String? recipientName,
    String? referenceNumber,
  }) async {
    if (_wallet == null) return;

    await _supabaseService.createTransaction({
      'wallet_id': _wallet!.id,
      'user_id': _wallet!.userId,
      'type': type,
      'amount': amount,
      'currency': currency,
      'description': description,
      'recipient_id': recipientId,
      'recipient_name': recipientName,
      'reference_number': referenceNumber,
      'status': 'completed',
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // تنسيق المبلغ
  String formatAmount(double amount, String currency) {
    return _paymentService.formatAmount(amount, currency);
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
}
