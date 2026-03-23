import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/notification_model.dart';

class NotificationProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<NotificationModel> _notifications = [];

  List<NotificationModel> get notifications => _notifications;

  Future<void> fetchNotifications(String userId) async {
    _notifications = await _supabaseService.getNotifications(userId);
    notifyListeners();
  }

  Future<void> markAsRead(String notificationId) async {
    await _supabaseService.markNotificationAsRead(notificationId);
    final index = _notifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _notifications[index] = NotificationModel(
        id: _notifications[index].id,
        userId: _notifications[index].userId,
        title: _notifications[index].title,
        body: _notifications[index].body,
        type: _notifications[index].type,
        targetId: _notifications[index].targetId,
        isRead: true,
        createdAt: _notifications[index].createdAt,
        imageUrl: _notifications[index].imageUrl,
        targetType: _notifications[index].targetType,
      );
      notifyListeners();
    }
  }

  void listenToNotifications(String userId) {
    _supabaseService.listenToNotifications(userId).listen((notifications) {
      _notifications = notifications;
      notifyListeners();
    });
  }
}
