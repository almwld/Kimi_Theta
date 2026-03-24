import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class WalletProvider extends ChangeNotifier {
  Map<String, dynamic>? _wallet;
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get wallet => _wallet;
  List<Map<String, dynamic>> get transactions => _transactions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  double get yerBalance => _wallet != null ? (_wallet!['yer_balance'] ?? 0.0).toDouble() : 0.0;
  double get sarBalance => _wallet != null ? (_wallet!['sar_balance'] ?? 0.0).toDouble() : 0.0;
  double get usdBalance => _wallet != null ? (_wallet!['usd_balance'] ?? 0.0).toDouble() : 0.0;

  Future<void> loadWallet(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _wallet = await SupabaseService.getWallet(userId);
      if (_wallet == null) {
        await SupabaseService.createWallet(userId);
        _wallet = await SupabaseService.getWallet(userId);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadTransactions(String userId, {int limit = 20}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _transactions = await SupabaseService.getTransactions(userId, limit: limit);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> updateBalance(String currency, double amount) async {
    if (_wallet == null) return false;
    _isLoading = true;
    notifyListeners();

    try {
      await SupabaseService.updateBalance(_wallet!['id'], currency, amount);
      await loadWallet(_wallet!['user_id']);
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
}
