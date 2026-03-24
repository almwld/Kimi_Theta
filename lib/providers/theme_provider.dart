import 'package:flutter/material.dart';
import '../services/local_storage_service.dart';

class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  ThemeProvider() {
    _loadSettings();
  }

  void _loadSettings() {
    _isDarkMode = LocalStorageService.getDarkMode();
  }

  void toggleTheme() async {
    _isDarkMode = !_isDarkMode;
    await LocalStorageService.setDarkMode(_isDarkMode);
    notifyListeners();
  }

  void setDarkMode(bool value) async {
    _isDarkMode = value;
    await LocalStorageService.setDarkMode(value);
    notifyListeners();
  }
}
