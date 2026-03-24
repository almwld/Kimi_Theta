import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class WalletProvider extends ChangeNotifier {
  Map<String, dynamic>? _wallet;
  List<Map<String, dynamic>> _transactions = [];

  Map<String, dynamic>? get wallet => _wallet;
  List<Map<String, dynamic>> get transactions => _transactions;

  Future<void> loadWallet(String userId) async {
    _wallet = await SupabaseService.getWallet(userId);
    if (_wallet == null) {
      await SupabaseService.createWallet(userId);
      _wallet = await SupabaseService.getWallet(userId);
    }
    notifyListeners();
  }

  Future<void> loadTransactions(String userId, {int limit = 20}) async {
    _transactions = await SupabaseService.getTransactions(userId, limit: limit);
    notifyListeners();
  }

  Future<void> updateBalance(String walletId, String currency, double amount) async {
    await SupabaseService.updateBalance(walletId, currency, amount);
    await loadWallet(walletId); // Reload wallet after update
  }
}
