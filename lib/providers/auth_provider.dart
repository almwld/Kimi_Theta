import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final LocalStorageService _localStorage = LocalStorageService();
  Map<String, dynamic>? _currentUser;
  bool _isLoading = false;
  String? _error;

  Map<String, dynamic>? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _currentUser != null;

  AuthProvider() {
    _loadUser();
  }

  Future<void> _loadUser() async {
    _currentUser = _localStorage.getUser();
    if (_currentUser == null && SupabaseService.isAuthenticated) {
      final userData = await SupabaseService.getUser(SupabaseService.currentUser!.id);
      if (userData != null) {
        _currentUser = userData;
        await _localStorage.saveUser(userData);
      }
    }
    notifyListeners();
  }

  Future<bool> signIn(String email, String password) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await SupabaseService.signIn(email, password);
      final userData = await SupabaseService.getUser(response.user!.id);
      if (userData != null) {
        _currentUser = userData;
        await _localStorage.saveUser(userData);
        _error = null;
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _error = 'لم نتمكن من العثور على بيانات المستخدم';
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> signUp(String email, String password, Map<String, dynamic> userData) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await SupabaseService.signUp(email, password, data: userData);
      // After signup, we might need to create profile. For now, just return.
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

  Future<void> signOut() async {
    _isLoading = true;
    notifyListeners();

    await SupabaseService.signOut();
    _currentUser = null;
    await _localStorage.clearUser();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> resetPassword(String email) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      await SupabaseService.resetPassword(email);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_currentUser == null) return;
    _isLoading = true;
    notifyListeners();

    try {
      await SupabaseService.updateUser(_currentUser!['id'], data);
      final updated = await SupabaseService.getUser(_currentUser!['id']);
      if (updated != null) {
        _currentUser = updated;
        await _localStorage.saveUser(updated);
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  void signInAsGuest() {
    _currentUser = {
      'id': 'guest',
      'full_name': 'ضيف',
      'email': '',
    };
    notifyListeners();
  }
}
