// موفر المصادقة - إدارة حالة تسجيل الدخول
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/supabase_service.dart';
import '../services/local_storage_service.dart';

class AuthProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  final LocalStorageService _localStorage = LocalStorageService();

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _error;
  bool _isAuthenticated = false;

  // getters
  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _isAuthenticated;
  bool get isGuest => !_isAuthenticated;

  // تهيئة الموفر
  Future<void> initialize() async {
    _setLoading(true);
    
    try {
      // التحقق من وجود مستخدم مخزن محلياً
      final storedUser = _localStorage.getUser();
      if (storedUser != null) {
        _currentUser = storedUser;
        _isAuthenticated = true;
      } else if (_supabaseService.isAuthenticated) {
        // التحقق من Supabase
        final userId = _supabaseService.currentUser!.id;
        final user = await _supabaseService.getUser(userId);
        if (user != null) {
          _currentUser = user;
          _isAuthenticated = true;
          await _localStorage.saveUser(user);
        }
      }
    } catch (e) {
      _setError('فشل في تهيئة المصادقة');
    } finally {
      _setLoading(false);
    }
  }

  // تسجيل الدخول بالبريد الإلكتروني
  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _supabaseService.signIn(
        email: email,
        password: password,
      );

      if (response.user != null) {
        final user = await _supabaseService.getUser(response.user!.id);
        if (user != null) {
          _currentUser = user;
          _isAuthenticated = true;
          await _localStorage.saveUser(user);
          notifyListeners();
          return true;
        }
      }
      _setError('بيانات الدخول غير صحيحة');
      return false;
    } catch (e) {
      _setError('فشل تسجيل الدخول، يرجى المحاولة مرة أخرى');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // تسجيل الدخول برقم الهاتف
  Future<bool> signInWithPhone(String phone) async {
    _setLoading(true);
    _clearError();

    try {
      await _supabaseService.signInWithPhone(phone: phone);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('فشل إرسال رمز التحقق');
      return false;
    }
  }

  // التحقق من رمز OTP
  Future<bool> verifyOTP({
    required String phone,
    required String code,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _supabaseService.verifyOTP(
        phone: phone,
        token: code,
      );

      if (response.user != null) {
        final user = await _supabaseService.getUser(response.user!.id);
        if (user != null) {
          _currentUser = user;
          _isAuthenticated = true;
          await _localStorage.saveUser(user);
          notifyListeners();
          return true;
        }
      }
      _setError('رمز التحقق غير صحيح');
      return false;
    } catch (e) {
      _setError('فشل التحقق من الرمز');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // إنشاء حساب جديد
  Future<bool> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String city,
    required String userType,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _supabaseService.signUp(
        email: email,
        password: password,
        userData: {
          'full_name': fullName,
          'phone': phone,
          'city': city,
          'user_type': userType,
        },
      );

      if (response.user != null) {
        // إنشاء محفظة للمستخدم
        await _supabaseService.createWallet(response.user!.id);
        
        _setLoading(false);
        return true;
      }
      _setError('فشل إنشاء الحساب');
      return false;
    } catch (e) {
      _setError('فشل إنشاء الحساب، يرجى المحاولة مرة أخرى');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    _setLoading(true);

    try {
      await _supabaseService.signOut();
      await _localStorage.clearUser();
      _currentUser = null;
      _isAuthenticated = false;
      notifyListeners();
    } catch (e) {
      _setError('فشل تسجيل الخروج');
    } finally {
      _setLoading(false);
    }
  }

  // إعادة تعيين كلمة المرور
  Future<bool> resetPassword(String email) async {
    _setLoading(true);
    _clearError();

    try {
      await _supabaseService.resetPassword(email);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('فشل إرسال رابط إعادة التعيين');
      return false;
    }
  }

  // تحديث كلمة المرور
  Future<bool> updatePassword(String newPassword) async {
    _setLoading(true);
    _clearError();

    try {
      await _supabaseService.updatePassword(newPassword);
      _setLoading(false);
      return true;
    } catch (e) {
      _setError('فشل تحديث كلمة المرور');
      return false;
    }
  }

  // تحديث بيانات المستخدم
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    _setLoading(true);
    _clearError();

    try {
      if (_currentUser != null) {
        await _supabaseService.updateUser(_currentUser!.id, data);
        
        // تحديث البيانات المحلية
        final updatedUser = await _supabaseService.getUser(_currentUser!.id);
        if (updatedUser != null) {
          _currentUser = updatedUser;
          await _localStorage.saveUser(updatedUser);
          notifyListeners();
        }
        _setLoading(false);
        return true;
      }
      return false;
    } catch (e) {
      _setError('فشل تحديث البيانات');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // رفع صورة الملف الشخصي
  Future<bool> uploadAvatar(dynamic file) async {
    _setLoading(true);
    _clearError();

    try {
      if (_currentUser != null && file != null) {
        final url = await _supabaseService.uploadAvatar(
          _currentUser!.id,
          file,
        );
        
        if (url != null) {
          _currentUser = _currentUser!.copyWith(avatarUrl: url);
          await _localStorage.saveUser(_currentUser!);
          notifyListeners();
          return true;
        }
      }
      return false;
    } catch (e) {
      _setError('فشل رفع الصورة');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  // الدخول كضيف
  void signInAsGuest() {
    _currentUser = UserModel(
      id: 'guest',
      fullName: 'ضيف',
      email: '',
      phone: '',
      city: '',
      userType: 'guest',
      createdAt: DateTime.now(),
    );
    _isAuthenticated = false;
    notifyListeners();
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
