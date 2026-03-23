// موفر الثيم - إدارة المظهر الداكن/الفاتح
import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorageService _localStorage = LocalStorageService();

  bool _isDarkMode = false;
  bool _isSystemTheme = true;

  // getters
  bool get isDarkMode => _isDarkMode;
  bool get isSystemTheme => _isSystemTheme;
  ThemeMode get themeMode {
    if (_isSystemTheme) {
      return ThemeMode.system;
    }
    return _isDarkMode ? ThemeMode.dark : ThemeMode.light;
  }

  // تهيئة الموفر
  Future<void> initialize() async {
    _isDarkMode = _localStorage.getDarkMode();
    _isSystemTheme = _localStorage.getLanguage() == 'system';
    notifyListeners();
  }

  // تبديل الثيم
  Future<void> toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    _isSystemTheme = false;
    await _localStorage.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  // تعيين الثيم الداكن
  Future<void> setDarkMode(bool value) async {
    _isDarkMode = value;
    _isSystemTheme = false;
    await _localStorage.setDarkMode(value);
    notifyListeners();
  }

  // استخدام ثيم النظام
  Future<void> useSystemTheme() async {
    _isSystemTheme = true;
    notifyListeners();
  }

  // الحصول على الثيم المناسب للسياق
  bool isDark(BuildContext context) {
    if (_isSystemTheme) {
      return MediaQuery.of(context).platformBrightness == Brightness.dark;
    }
    return _isDarkMode;
  }
}
