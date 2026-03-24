import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class NotificationProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _notifications = [];

  List<Map<String, dynamic>> get notifications => _notifications;

  Future<void> loadNotifications(String userId) async {
    _notifications = await SupabaseService.getNotifications(userId);
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    await SupabaseService.markNotificationAsRead(notificationId);
    // Update local list
    final index = _notifications.indexWhere((n) => n['id'] == notificationId);
    if (index != -1) {
      _notifications[index]['is_read'] = true;
      notifyListeners();
    }
  }
}

  int get unreadCount {
    return _notifications.where((n) => !n['is_read']).length;
  }
