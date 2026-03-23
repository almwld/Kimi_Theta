import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/wallet_model.dart';
import '../models/transaction_model.dart';

class WalletProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  WalletModel? _wallet;
  List<TransactionModel> _transactions = [];
  List<TransactionModel> _recentTransactions = [];

  WalletModel? get wallet => _wallet;
  List<TransactionModel> get transactions => _transactions;
  List<TransactionModel> get recentTransactions => _recentTransactions;

  Future<void> fetchWallet(String userId) async {
    _wallet = await _supabaseService.getWallet(userId);
    if (_wallet == null) {
      await _supabaseService.createWallet(userId);
      _wallet = await _supabaseService.getWallet(userId);
    }
    notifyListeners();
  }

  Future<void> fetchTransactions(String userId, {int limit = 20}) async {
    _transactions = await _supabaseService.getTransactions(userId, limit: limit);
    _recentTransactions = _transactions.take(5).toList();
    notifyListeners();
  }

  Future<void> updateBalance(String walletId, String currency, double amount) async {
    await _supabaseService.updateBalance(walletId, currency, amount);
    await fetchWallet(_wallet!.userId);
  }

  Future<void> createTransaction(Map<String, dynamic> data) async {
    await _supabaseService.createTransaction(data);
    await fetchTransactions(_wallet!.userId);
  }
}
