// خدمة Supabase - إدارة الاتصال والعمليات
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/product_model.dart';
import '../models/order_model.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../models/transaction_model.dart';
import '../models/notification_model.dart';
import '../models/rating_model.dart';

class SupabaseService {
  static final SupabaseService _instance = SupabaseService._internal();
  factory SupabaseService() => _instance;
  SupabaseService._internal();

  SupabaseClient? _client;
  
  // تهيئة Supabase
  Future<void> initialize({
    required String url,
    required String anonKey,
  }) async {
    await Supabase.initialize(
      url: url,
      anonKey: anonKey,
    );
    _client = Supabase.instance.client;
  }

  SupabaseClient get client {
    if (_client == null) {
      throw Exception('Supabase not initialized');
    }
    return _client!;
  }

  User? get currentUser => client.auth.currentUser;
  bool get isAuthenticated => currentUser != null;

  // ==================== المصادقة ====================
  
  // تسجيل الدخول
  Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    try {
      final response = await client.auth.signInWithPassword(
        email: email,
        password: password,
      );
      return response;
    } catch (e) {
      debugPrint('Error signing in: $e');
      rethrow;
    }
  }

  // تسجيل الدخول برقم الهاتف
  Future<void> signInWithPhone({
    required String phone,
  }) async {
    try {
      await client.auth.signInWithOtp(
        phone: phone,
      );
    } catch (e) {
      debugPrint('Error signing in with phone: $e');
      rethrow;
    }
  }

  // التحقق من رمز OTP
  Future<AuthResponse> verifyOTP({
    required String phone,
    required String token,
  }) async {
    try {
      final response = await client.auth.verifyOTP(
        phone: phone,
        token: token,
        type: OtpType.sms,
      );
      return response;
    } catch (e) {
      debugPrint('Error verifying OTP: $e');
      rethrow;
    }
  }

  // إنشاء حساب
  Future<AuthResponse> signUp({
    required String email,
    required String password,
    required Map<String, dynamic> userData,
  }) async {
    try {
      final response = await client.auth.signUp(
        email: email,
        password: password,
        data: userData,
      );
      
      // إنشاء سجل المستخدم في قاعدة البيانات
      if (response.user != null) {
        await client.from('users').insert({
          'id': response.user!.id,
          'email': email,
          'full_name': userData['full_name'],
          'phone': userData['phone'],
          'city': userData['city'],
          'user_type': userData['user_type'],
          'created_at': DateTime.now().toIso8601String(),
        });
      }
      
      return response;
    } catch (e) {
      debugPrint('Error signing up: $e');
      rethrow;
    }
  }

  // تسجيل الخروج
  Future<void> signOut() async {
    try {
      await client.auth.signOut();
    } catch (e) {
      debugPrint('Error signing out: $e');
      rethrow;
    }
  }

  // إعادة تعيين كلمة المرور
  Future<void> resetPassword(String email) async {
    try {
      await client.auth.resetPasswordForEmail(email);
    } catch (e) {
      debugPrint('Error resetting password: $e');
      rethrow;
    }
  }

  // تحديث كلمة المرور
  Future<void> updatePassword(String newPassword) async {
    try {
      await client.auth.updateUser(
        UserAttributes(password: newPassword),
      );
    } catch (e) {
      debugPrint('Error updating password: $e');
      rethrow;
    }
  }

  // ==================== المستخدمين ====================

  // الحصول على بيانات المستخدم
  Future<UserModel?> getUser(String userId) async {
    try {
      final response = await client
          .from('users')
          .select('*')
          .eq('id', userId)
          .single();
      
      return UserModel.fromJson(response);
    } catch (e) {
      debugPrint('Error getting user: $e');
      return null;
    }
  }

  // تحديث بيانات المستخدم
  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    try {
      await client
          .from('users')
          .update(data)
          .eq('id', userId);
    } catch (e) {
      debugPrint('Error updating user: $e');
      rethrow;
    }
  }

  // رفع صورة الملف الشخصي
  Future<String?> uploadAvatar(String userId, File file) async {
    try {
      final fileName = 'avatar_$userId${DateTime.now().millisecondsSinceEpoch}.jpg';
      await client.storage
          .from('avatars')
          .upload(fileName, file);
      
      final url = client.storage
          .from('avatars')
          .getPublicUrl(fileName);
      
      // تحديث رابط الصورة في قاعدة البيانات
      await updateUser(userId, {'avatar_url': url});
      
      return url;
    } catch (e) {
      debugPrint('Error uploading avatar: $e');
      return null;
    }
  }

  // ==================== المنتجات ====================

  // الحصول على قائمة المنتجات
  Future<List<ProductModel>> getProducts({
    int page = 0,
    int limit = 20,
    String? category,
    String? search,
    String? city,
    double? minPrice,
    double? maxPrice,
    String sortBy = 'created_at',
    bool descending = true,
  }) async {
    try {
      var query = client
          .from('products')
          .select('*')
          .range(page * limit, (page + 1) * limit - 1)
          .order(sortBy, ascending: !descending);

      if (category != null) {
        query = query.eq('category', category);
      }
      
      if (search != null && search.isNotEmpty) {
        query = query.ilike('title', '%$search%');
      }
      
      if (city != null) {
        query = query.eq('city', city);
      }
      
      if (minPrice != null) {
        query = query.gte('price', minPrice);
      }
      
      if (maxPrice != null) {
        query = query.lte('price', maxPrice);
      }

      final response = await query;
      
      return (response as List)
          .map((json) => ProductModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting products: $e');
      return [];
    }
  }

  // الحصول على منتج واحد
  Future<ProductModel?> getProduct(String productId) async {
    try {
      final response = await client
          .from('products')
          .select('*')
          .eq('id', productId)
          .single();
      
      // زيادة عدد المشاهدات
      await client.rpc('increment_views', params: {'product_id': productId});
      
      return ProductModel.fromJson(response);
    } catch (e) {
      debugPrint('Error getting product: $e');
      return null;
    }
  }

  // إضافة منتج
  Future<ProductModel?> addProduct(Map<String, dynamic> data) async {
    try {
      final response = await client
          .from('products')
          .insert(data)
          .select()
          .single();
      
      return ProductModel.fromJson(response);
    } catch (e) {
      debugPrint('Error adding product: $e');
      return null;
    }
  }

  // تحديث منتج
  Future<void> updateProduct(
    String productId,
    Map<String, dynamic> data,
  ) async {
    try {
      await client
          .from('products')
          .update(data)
          .eq('id', productId);
    } catch (e) {
      debugPrint('Error updating product: $e');
      rethrow;
    }
  }

  // حذف منتج
  Future<void> deleteProduct(String productId) async {
    try {
      await client
          .from('products')
          .delete()
          .eq('id', productId);
    } catch (e) {
      debugPrint('Error deleting product: $e');
      rethrow;
    }
  }

  // رفع صور المنتج
  Future<List<String>> uploadProductImages(
    String productId,
    List<File> files,
  ) async {
    final urls = <String>[];
    
    for (var i = 0; i < files.length; i++) {
      try {
        final fileName = 'product_${productId}_${DateTime.now().millisecondsSinceEpoch}_$i.jpg';
        await client.storage
            .from('products')
            .upload(fileName, files[i]);
        
        final url = client.storage
            .from('products')
            .getPublicUrl(fileName);
        
        urls.add(url);
      } catch (e) {
        debugPrint('Error uploading product image: $e');
      }
    }
    
    return urls;
  }

  // ==================== المفضلة ====================

  // إضافة إلى المفضلة
  Future<void> addToFavorites(String userId, String productId) async {
    try {
      await client.from('favorites').insert({
        'user_id': userId,
        'product_id': productId,
        'created_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error adding to favorites: $e');
      rethrow;
    }
  }

  // إزالة من المفضلة
  Future<void> removeFromFavorites(String userId, String productId) async {
    try {
      await client
          .from('favorites')
          .delete()
          .eq('user_id', userId)
          .eq('product_id', productId);
    } catch (e) {
      debugPrint('Error removing from favorites: $e');
      rethrow;
    }
  }

  // الحصول على المفضلة
  Future<List<String>> getFavorites(String userId) async {
    try {
      final response = await client
          .from('favorites')
          .select('product_id')
          .eq('user_id', userId);
      
      return (response as List)
          .map((item) => item['product_id'] as String)
          .toList();
    } catch (e) {
      debugPrint('Error getting favorites: $e');
      return [];
    }
  }

  // التحقق من وجود في المفضلة
  Future<bool> isFavorite(String userId, String productId) async {
    try {
      final response = await client
          .from('favorites')
          .select()
          .eq('user_id', userId)
          .eq('product_id', productId)
          .maybeSingle();
      
      return response != null;
    } catch (e) {
      debugPrint('Error checking favorite: $e');
      return false;
    }
  }

  // ==================== الطلبات ====================

  // إنشاء طلب
  Future<OrderModel?> createOrder(Map<String, dynamic> data) async {
    try {
      final response = await client
          .from('orders')
          .insert(data)
          .select()
          .single();
      
      return OrderModel.fromJson(response);
    } catch (e) {
      debugPrint('Error creating order: $e');
      return null;
    }
  }

  // الحصول على طلبات المستخدم
  Future<List<OrderModel>> getUserOrders(String userId) async {
    try {
      final response = await client
          .from('orders')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => OrderModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting user orders: $e');
      return [];
    }
  }

  // تحديث حالة الطلب
  Future<void> updateOrderStatus(
    String orderId,
    String status,
  ) async {
    try {
      await client
          .from('orders')
          .update({
            'status': status,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);
    } catch (e) {
      debugPrint('Error updating order status: $e');
      rethrow;
    }
  }

  // ==================== المحفظة ====================

  // الحصول على محفظة المستخدم
  Future<Map<String, dynamic>?> getWallet(String userId) async {
    try {
      final response = await client
          .from('wallets')
          .select('*')
          .eq('user_id', userId)
          .maybeSingle();
      
      return response;
    } catch (e) {
      debugPrint('Error getting wallet: $e');
      return null;
    }
  }

  // إنشاء محفظة
  Future<void> createWallet(String userId) async {
    try {
      await client.from('wallets').insert({
        'user_id': userId,
        'yemeni_rial': 0,
        'saudi_riyal': 0,
        'us_dollar': 0,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });
    } catch (e) {
      debugPrint('Error creating wallet: $e');
      rethrow;
    }
  }

  // تحديث الرصيد
  Future<void> updateBalance(
    String walletId,
    String currency,
    double amount,
  ) async {
    try {
      final column = currency == 'YER'
          ? 'yemeni_rial'
          : currency == 'SAR'
              ? 'saudi_riyal'
              : 'us_dollar';
      
      await client.rpc(
        'update_balance',
        params: {
          'wallet_id': walletId,
          'currency_column': column,
          'amount': amount,
        },
      );
    } catch (e) {
      debugPrint('Error updating balance: $e');
      rethrow;
    }
  }

  // إنشاء معاملة
  Future<TransactionModel?> createTransaction(
    Map<String, dynamic> data,
  ) async {
    try {
      final response = await client
          .from('transactions')
          .insert(data)
          .select()
          .single();
      
      return TransactionModel.fromJson(response);
    } catch (e) {
      debugPrint('Error creating transaction: $e');
      return null;
    }
  }

  // الحصول على معاملات المستخدم
  Future<List<TransactionModel>> getTransactions(
    String walletId, {
    int limit = 50,
  }) async {
    try {
      final response = await client
          .from('transactions')
          .select('*')
          .eq('wallet_id', walletId)
          .order('created_at', ascending: false)
          .limit(limit);
      
      return (response as List)
          .map((json) => TransactionModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting transactions: $e');
      return [];
    }
  }

  // ==================== المحادثات ====================

  // الحصول على محادثات المستخدم
  Future<List<ChatModel>> getChats(String userId) async {
    try {
      final response = await client
          .from('chats')
          .select('*')
          .or('participant1_id.eq.$userId,participant2_id.eq.$userId')
          .order('last_message_time', ascending: false);
      
      return (response as List)
          .map((json) => ChatModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting chats: $e');
      return [];
    }
  }

  // إنشاء محادثة
  Future<ChatModel?> createChat(
    String participant1Id,
    String participant2Id,
  ) async {
    try {
      // التحقق من وجود المحادثة
      final existing = await client
          .from('chats')
          .select()
          .or(
            'and(participant1_id.eq.$participant1Id,participant2_id.eq.$participant2Id),'
            'and(participant1_id.eq.$participant2Id,participant2_id.eq.$participant1Id)',
          )
          .maybeSingle();
      
      if (existing != null) {
        return ChatModel.fromJson(existing);
      }
      
      // الحصول على أسماء المشاركين
      final user1 = await getUser(participant1Id);
      final user2 = await getUser(participant2Id);
      
      final response = await client
          .from('chats')
          .insert({
            'participant1_id': participant1Id,
            'participant2_id': participant2Id,
            'participant1_name': user1?.fullName ?? '',
            'participant2_name': user2?.fullName ?? '',
            'participant1_avatar': user1?.avatarUrl,
            'participant2_avatar': user2?.avatarUrl,
            'created_at': DateTime.now().toIso8601String(),
          })
          .select()
          .single();
      
      return ChatModel.fromJson(response);
    } catch (e) {
      debugPrint('Error creating chat: $e');
      return null;
    }
  }

  // الحصول على رسائل المحادثة
  Future<List<MessageModel>> getMessages(
    String chatId, {
    int limit = 50,
  }) async {
    try {
      final response = await client
          .from('messages')
          .select('*')
          .eq('chat_id', chatId)
          .order('created_at', ascending: true)
          .limit(limit);
      
      return (response as List)
          .map((json) => MessageModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting messages: $e');
      return [];
    }
  }

  // إرسال رسالة
  Future<MessageModel?> sendMessage(Map<String, dynamic> data) async {
    try {
      final response = await client
          .from('messages')
          .insert(data)
          .select()
          .single();
      
      // تحديث آخر رسالة في المحادثة
      await client
          .from('chats')
          .update({
            'last_message': data['content'],
            'last_message_time': DateTime.now().toIso8601String(),
            'last_message_sender_id': data['sender_id'],
          })
          .eq('id', data['chat_id']);
      
      return MessageModel.fromJson(response);
    } catch (e) {
      debugPrint('Error sending message: $e');
      return null;
    }
  }

  // رفع صورة في المحادثة
  Future<String?> uploadChatImage(String chatId, File file) async {
    try {
      final fileName = 'chat_${chatId}_${DateTime.now().millisecondsSinceEpoch}.jpg';
      await client.storage
          .from('chat_images')
          .upload(fileName, file);
      
      return client.storage
          .from('chat_images')
          .getPublicUrl(fileName);
    } catch (e) {
      debugPrint('Error uploading chat image: $e');
      return null;
    }
  }

  // ==================== التقييمات ====================

  // إضافة تقييم
  Future<RatingModel?> addRating(Map<String, dynamic> data) async {
    try {
      final response = await client
          .from('ratings')
          .insert(data)
          .select()
          .single();
      
      // تحديث متوسط تقييم المنتج
      await client.rpc('update_product_rating', params: {
        'product_id': data['product_id'],
      });
      
      return RatingModel.fromJson(response);
    } catch (e) {
      debugPrint('Error adding rating: $e');
      return null;
    }
  }

  // الحصول على تقييمات المنتج
  Future<List<RatingModel>> getProductRatings(String productId) async {
    try {
      final response = await client
          .from('ratings')
          .select('*')
          .eq('product_id', productId)
          .order('created_at', ascending: false);
      
      return (response as List)
          .map((json) => RatingModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting product ratings: $e');
      return [];
    }
  }

  // ==================== الإشعارات ====================

  // الحصول على إشعارات المستخدم
  Future<List<NotificationModel>> getNotifications(
    String userId, {
    int limit = 30,
  }) async {
    try {
      final response = await client
          .from('notifications')
          .select('*')
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);
      
      return (response as List)
          .map((json) => NotificationModel.fromJson(json))
          .toList();
    } catch (e) {
      debugPrint('Error getting notifications: $e');
      return [];
    }
  }

  // تحديث حالة الإشعار
  Future<void> markNotificationAsRead(String notificationId) async {
    try {
      await client
          .from('notifications')
          .update({
            'is_read': true,
            'read_at': DateTime.now().toIso8601String(),
          })
          .eq('id', notificationId);
    } catch (e) {
      debugPrint('Error marking notification as read: $e');
      rethrow;
    }
  }

  // ==================== الاستماع المباشر ====================

  // الاستماع للرسائل الجديدة
  RealtimeChannel listenToMessages(
    String chatId,
    Function(MessageModel) onMessage,
  ) {
    return client
        .channel('messages:$chatId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'messages',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'chat_id',
            value: chatId,
          ),
          callback: (payload) {
            onMessage(MessageModel.fromJson(payload.newRecord));
          },
        )
        .subscribe();
  }

  // الاستماع للإشعارات الجديدة
  RealtimeChannel listenToNotifications(
    String userId,
    Function(NotificationModel) onNotification,
  ) {
    return client
        .channel('notifications:$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.insert,
          schema: 'public',
          table: 'notifications',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            onNotification(NotificationModel.fromJson(payload.newRecord));
          },
        )
        .subscribe();
  }
}
