import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get notifications => _notifications;
  bool get isLoading => _isLoading;
  String? get error => _error;

  int get unreadCount => _notifications.where((n) => n['is_read'] == false).length;

  Future<void> loadNotifications(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _notifications = await SupabaseService.getNotifications(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> markAsRead(String notificationId) async {
    try {
      await SupabaseService.markNotificationAsRead(notificationId);
      final index = _notifications.indexWhere((n) => n['id'] == notificationId);
      if (index != -1) {
        _notifications[index]['is_read'] = true;
        notifyListeners();
      }
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
