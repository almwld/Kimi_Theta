import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/user_model.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  final LocalStorageService _localStorage = LocalStorageService();
  UserModel? _currentUser;
  bool _isLoading = false;

  UserModel? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    _isLoading = true;
    notifyListeners();

    final storedUser = _localStorage.getUser();
    if (storedUser != null) {
      _currentUser = storedUser;
    } else if (SupabaseService.isAuthenticated) {
      final userId = SupabaseService.currentUser!.id;
      final user = await _supabaseService.getUser(userId);
      if (user != null) {
        _currentUser = user;
        await _localStorage.saveUser(user);
      }
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> signIn(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _supabaseService.signIn(email, password);
      final user = await _supabaseService.getUser(response.user!.id);
      if (user != null) {
        _currentUser = user;
        await _localStorage.saveUser(user);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signUp(String email, String password, Map<String, dynamic> data) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _supabaseService.signUp(email, password, data: data);
      final user = await _supabaseService.getUser(response.user!.id);
      if (user != null) {
        _currentUser = user;
        await _localStorage.saveUser(user);
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    await _supabaseService.signOut();
    await _localStorage.clearUser();
    _currentUser = null;
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> data) async {
    if (_currentUser == null) return;
    await _supabaseService.updateUser(_currentUser!.id, data);
    final updatedUser = await _supabaseService.getUser(_currentUser!.id);
    if (updatedUser != null) {
      _currentUser = updatedUser;
      await _localStorage.saveUser(updatedUser);
      notifyListeners();
    }
  }

  Future<void> updateAvatar(String path) async {
    if (_currentUser == null) return;
    final url = await _supabaseService.uploadAvatar(_currentUser!.id, path);
    await updateProfile({'avatar_url': url});
  }

  Future<void> resetPassword(String email) async {
    await _supabaseService.resetPassword(email);
  }

  // Guest user
  void setGuestUser() {
    _currentUser = UserModel(
      id: 'guest',
      email: 'guest@example.com',
      fullName: 'ضيف',
    );
    notifyListeners();
  }
}
