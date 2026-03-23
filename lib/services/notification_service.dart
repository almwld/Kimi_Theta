// خدمة الإشعارات
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import '../models/notification_model.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _localNotifications = 
      FlutterLocalNotificationsPlugin();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  bool _initialized = false;
  Function(NotificationModel)? _onNotificationTap;

  // تهيئة الإشعارات
  Future<void> initialize({
    Function(NotificationModel)? onNotificationTap,
  }) async {
    if (_initialized) return;

    _onNotificationTap = onNotificationTap;

    // طلب صلاحيات الإشعارات
    await _requestPermissions();

    // تهيئة الإشعارات المحلية
    await _initializeLocalNotifications();

    // تهيئة FCM
    await _initializeFirebaseMessaging();

    _initialized = true;
  }

  // طلب صلاحيات الإشعارات
  Future<void> _requestPermissions() async {
    // صلاحيات FCM
    await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
      provisional: false,
    );

    // صلاحيات الإشعارات المحلية
    await _localNotifications
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
  }

  // تهيئة الإشعارات المحلية
  Future<void> _initializeLocalNotifications() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
    const iosSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: iosSettings,
    );

    await _localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: _onNotificationResponse,
    );
  }

  // تهيئة Firebase Messaging
  Future<void> _initializeFirebaseMessaging() async {
    // الحصول على رمز FCM
    final token = await getFCMToken();
    debugPrint('FCM Token: $token');

    // معالجة الإشعارات في المقدمة
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // معالجة فتح الإشعار عندما يكون التطبيق في الخلفية
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessage);

    // معالجة الإشعار عند فتح التطبيق من حالة مغلقة
    final initialMessage = await _firebaseMessaging.getInitialMessage();
    if (initialMessage != null) {
      _handleInitialMessage(initialMessage);
    }
  }

  // معالجة الإشعارات في المقدمة
  void _handleForegroundMessage(RemoteMessage message) {
    debugPrint('Received foreground message: ${message.notification?.title}');
    
    showLocalNotification(
      id: message.hashCode,
      title: message.notification?.title ?? 'Flex Yemen',
      body: message.notification?.body ?? '',
      payload: jsonEncode(message.data),
    );
  }

  // معالجة الإشعارات في الخلفية
  void _handleBackgroundMessage(RemoteMessage message) {
    debugPrint('Opened app from background message');
    _handleNotificationData(message.data);
  }

  // معالجة الإشعار الأولي
  void _handleInitialMessage(RemoteMessage message) {
    debugPrint('Opened app from terminated state');
    _handleNotificationData(message.data);
  }

  // معالجة بيانات الإشعار
  void _handleNotificationData(Map<String, dynamic> data) {
    final notification = NotificationModel(
      id: data['id'] ?? '',
      userId: data['user_id'] ?? '',
      title: data['title'] ?? '',
      body: data['body'] ?? '',
      type: data['type'] ?? 'general',
      targetId: data['target_id'],
      targetType: data['target_type'],
      createdAt: DateTime.now(),
    );

    _onNotificationTap?.call(notification);
  }

  // استجابة للإشعار المحلي
  void _onNotificationResponse(NotificationResponse response) {
    if (response.payload != null) {
      final data = jsonDecode(response.payload!) as Map<String, dynamic>;
      _handleNotificationData(data);
    }
  }

  // عرض إشعار محلي
  Future<void> showLocalNotification({
    required int id,
    required String title,
    required String body,
    String? payload,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      'flex_yemen_channel',
      'Flex Yemen Notifications',
      channelDescription: 'Notifications for Flex Yemen app',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: true,
      enableVibration: true,
      playSound: true,
      icon: '@mipmap/ic_launcher',
    );

    const iosDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const details = NotificationDetails(
      android: androidDetails,
      iOS: iosDetails,
    );

    await _localNotifications.show(
      id,
      title,
      body,
      details,
      payload: payload,
    );
  }

  // الحصول على رمز FCM
  Future<String?> getFCMToken() async {
    return await _firebaseMessaging.getToken();
  }

  // تحديث رمز FCM
  Stream<String> onTokenRefresh() {
    return _firebaseMessaging.onTokenRefresh;
  }

  // الاشتراك في موضوع
  Future<void> subscribeToTopic(String topic) async {
    await _firebaseMessaging.subscribeToTopic(topic);
  }

  // إلغاء الاشتراك من موضوع
  Future<void> unsubscribeFromTopic(String topic) async {
    await _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  // حذف رمز FCM
  Future<void> deleteToken() async {
    await _firebaseMessaging.deleteToken();
  }

  // إلغاء جميع الإشعارات
  Future<void> cancelAllNotifications() async {
    await _localNotifications.cancelAll();
  }

  // إلغاء إشعار محدد
  Future<void> cancelNotification(int id) async {
    await _localNotifications.cancel(id);
  }

  // الحصول على عدد الإشعارات غير المقروءة
  Future<int> getUnreadCount() async {
    // يمكن تنفيذ هذا باستخدام Hive أو SharedPreferences
    return 0;
  }

  // تعيين عدد الإشعارات على الأيقونة
  Future<void> setBadge(int count) async {
    // iOS فقط
    await _localNotifications
        .resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>()
        // ?.setBadgeCount(count);
  }
}

// معالجة الإشعارات في الخلفية
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  debugPrint('Handling background message: ${message.messageId}');
}
