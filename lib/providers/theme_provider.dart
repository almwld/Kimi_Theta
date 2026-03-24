import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  final LocalStorageService _localStorage = LocalStorageService();
  bool _isDarkMode = false;
  bool _isSystemTheme = true;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadSettings();
  }

  void _loadSettings() async {
    _isDarkMode = _localStorage.getDarkMode();
    _isSystemTheme = _localStorage.getLanguage() == 'system'; // بسيط
    notifyListeners();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await _localStorage.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  void setDarkMode(bool value) async {
    _isDarkMode = value;
    await _localStorage.setDarkMode(value);
    notifyListeners();
  }
}
