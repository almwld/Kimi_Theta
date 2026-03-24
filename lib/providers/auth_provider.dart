import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/local_storage_service.dart';
import '../services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  final LocalStorageService _localStorage = LocalStorageService();
  final SupabaseService _supabase = SupabaseService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  Future<void> init() async {
    final userMap = _localStorage.getUser();
    if (userMap != null) {
      _currentUser = UserModel.fromJson(userMap);
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabase.signIn(email, password);
      if (response.user != null) {
        final userData = await _supabase.getUser(response.user!.id);
        if (userData != null) {
          _currentUser = UserModel.fromJson(userData);
          await _localStorage.saveUser(userData);
          return true;
        }
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<bool> signUp(String email, String password, Map<String, dynamic> userData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _supabase.signUp(email, password, data: userData);
      if (response.user != null) {
        // إنشاء المحفظة
        await _supabase.createWallet(response.user!.id);
        // جلب بيانات المستخدم
        final user = await _supabase.getUser(response.user!.id);
        if (user != null) {
          _currentUser = UserModel.fromJson(user);
          await _localStorage.saveUser(user);
          return true;
        }
      }
      return false;
    } catch (e) {
      _error = e.toString();
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _supabase.signOut();
    _currentUser = null;
    await _localStorage.clearUser();
    notifyListeners();
  }

  Future<void> signInAsGuest() async {
    _currentUser = UserModel(
      id: 'guest',
      email: 'guest@flexyemen.com',
      name: 'ضيف',
    );
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_currentUser == null) return;
    try {
      await _supabase.updateUser(_currentUser!.id, data);
      final updated = await _supabase.getUser(_currentUser!.id);
      if (updated != null) {
        _currentUser = UserModel.fromJson(updated);
        await _localStorage.saveUser(updated);
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      await _supabase.resetPassword(email);
    } catch (e) {
      _error = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
