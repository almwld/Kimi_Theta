// موفر الإشعارات - إدارة حالة الإشعارات
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/notification_model.dart';
import '../services/supabase_service.dart';
import '../services/notification_service.dart';

class NotificationProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  final NotificationService _notificationService = NotificationService();

  List<NotificationModel> _notifications = [];
  List<NotificationModel> _unreadNotifications = [];
  bool _isLoading = false;
  String? _error;
  int _unreadCount = 0;
  RealtimeChannel? _notificationsChannel;

  // getters
  List<NotificationModel> get notifications => _notifications;
  List<NotificationModel> get unreadNotifications => _unreadNotifications;
  bool get isLoading => _isLoading;
  String? get error => _error;
  int get unreadCount => _unreadCount;
  bool get hasUnread => _unreadCount > 0;

  // تهيئة الموفر
  Future<void> initialize(String userId) async {
    await loadNotifications(userId);
    _listenToNotifications(userId);
  }

  // تحميل الإشعارات
  Future<void> loadNotifications(
    String userId, {
    int limit = 30,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      _notifications = await _supabaseService.getNotifications(
        userId,
        limit: limit,
      );
      _updateUnreadCount();
      notifyListeners();
    } catch (e) {
      _setError('فشل تحميل الإشعارات');
    } finally {
      _setLoading(false);
    }
  }

  // تحديث الإشعارات
  Future<void> refreshNotifications(String userId) async {
    await loadNotifications(userId);
  }

  // تحديد إشعار كمقروء
  Future<void> markAsRead(String notificationId) async {
    try {
      await _supabaseService.markNotificationAsRead(notificationId);

      // تحديث القائمة المحلية
      final index = _notifications.indexWhere((n) => n.id == notificationId);
      if (index >= 0) {
        _notifications[index] = NotificationModel(
          id: _notifications[index].id,
          userId: _notifications[index].userId,
          title: _notifications[index].title,
          body: _notifications[index].body,
          type: _notifications[index].type,
          imageUrl: _notifications[index].imageUrl,
          targetId: _notifications[index].targetId,
          targetType: _notifications[index].targetType,
          isRead: true,
          createdAt: _notifications[index].createdAt,
          readAt: DateTime.now(),
        );
        _updateUnreadCount();
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
    }
  }

  // تحديد جميع الإشعارات كمقروءة
  Future<void> markAllAsRead() async {
    try {
      final unreadList = _notifications.where((n) => !n.isRead).toList();
      
      for (final notification in unreadList) {
        await _supabaseService.markNotificationAsRead(notification.id);
      }

      // تحديث القائمة المحلية
      _notifications = _notifications.map((n) {
        if (!n.isRead) {
          return NotificationModel(
            id: n.id,
            userId: n.userId,
            title: n.title,
            body: n.body,
            type: n.type,
            imageUrl: n.imageUrl,
            targetId: n.targetId,
            targetType: n.targetType,
            isRead: true,
            createdAt: n.createdAt,
            readAt: DateTime.now(),
          );
        }
        return n;
      }).toList();

      _updateUnreadCount();
      notifyListeners();
    } catch (e) {
      debugPrint('Error marking all notifications as read: $e');
    }
  }

  // حذف إشعار
  Future<void> deleteNotification(String notificationId) async {
    try {
      _notifications.removeWhere((n) => n.id == notificationId);
      _updateUnreadCount();
      notifyListeners();
    } catch (e) {
      debugPrint('Error deleting notification: $e');
    }
  }

  // مسح جميع الإشعارات
  Future<void> clearAll() async {
    _notifications = [];
    _unreadCount = 0;
    notifyListeners();
  }

  // الاستماع للإشعارات الجديدة
  void _listenToNotifications(String userId) {
    _notificationsChannel?.unsubscribe();

    _notificationsChannel = _supabaseService.listenToNotifications(
      userId,
      (notification) {
        // إضافة الإشعار الجديد إلى القائمة
        _notifications.insert(0, notification);
        _updateUnreadCount();

        // عرض إشعار محلي
        _notificationService.showLocalNotification(
          id: notification.id.hashCode,
          title: notification.title,
          body: notification.body,
          payload: notification.toJson().toString(),
        );

        notifyListeners();
      },
    );
  }

  // تحديث عدد الإشعارات غير المقروءة
  void _updateUnreadCount() {
    _unreadNotifications = _notifications.where((n) => !n.isRead).toList();
    _unreadCount = _unreadNotifications.length;
  }

  // تصفية الإشعارات حسب النوع
  List<NotificationModel> getNotificationsByType(String type) {
    return _notifications.where((n) => n.type == type).toList();
  }

  // الحصول على آخر إشعار
  NotificationModel? get latestNotification {
    return _notifications.isNotEmpty ? _notifications.first : null;
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

  @override
  void dispose() {
    _notificationsChannel?.unsubscribe();
    super.dispose();
  }
}
