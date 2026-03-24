import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabase = Supabase.instance.client;

  // ===== المصادقة =====
  static Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(email: email, password: password);
  }

  static Future<AuthResponse> signUp(String email, String password, {Map<String, dynamic>? data}) async {
    return await supabase.auth.signUp(email: email, password: password, data: data);
  }

  static Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  static Future<void> resetPassword(String email) async {
    await supabase.auth.resetPasswordForEmail(email);
  }

  // ===== المستخدم =====
  static Future<Map<String, dynamic>?> getUser(String userId) async {
    return await supabase.from('profiles').select().eq('id', userId).maybeSingle();
  }

  static Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await supabase.from('profiles').update(data).eq('id', userId);
  }

  // ===== المحفظة =====
  static Future<Map<String, dynamic>?> getWallet(String userId) async {
    return await supabase.from('wallets').select().eq('user_id', userId).maybeSingle();
  }

  static Future<void> createWallet(String userId) async {
    await supabase.from('wallets').insert({
      'user_id': userId,
      'yer_balance': 0,
      'sar_balance': 0,
      'usd_balance': 0,
    });
  }

  static Future<void> updateBalance(String walletId, String currency, double amount) async {
    await supabase.from('wallets').update({'${currency.toLowerCase()}_balance': amount}).eq('id', walletId);
  }

  static Future<List<Map<String, dynamic>>> getTransactions(String userId, {int limit = 20}) async {
    final response = await supabase
        .from('transactions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  // ===== المنتجات =====
  static Future<List<Map<String, dynamic>>> getProducts({
    String? category,
    String? city,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = supabase.from('products').select();
    if (category != null && category.isNotEmpty) query = query.filter('category', 'eq', category);
    if (city != null && city.isNotEmpty) query = query.filter('city', 'eq', city);
    final response = await query.order('created_at', ascending: false).range(offset, offset + limit - 1);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>?> getProduct(String id) async {
    return await supabase.from('products').select().eq('id', id).maybeSingle();
  }

  static Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    final response = await supabase.from('products').insert(data).select().single();
    return response;
  }

  // ===== المفضلة =====
  static Future<void> addToFavorites(String userId, String productId) async {
    await supabase.from('favorites').insert({'user_id': userId, 'product_id': productId});
  }

  static Future<void> removeFromFavorites(String userId, String productId) async {
    await supabase.from('favorites').delete().eq('user_id', userId).eq('product_id', productId);
  }

  static Future<List<String>> getFavorites(String userId) async {
    final response = await supabase.from('favorites').select('product_id').eq('user_id', userId);
    return List<String>.from(response.map((e) => e['product_id']));
  }

  // ===== المحادثات =====
  static Future<List<Map<String, dynamic>>> getChats(String userId) async {
    final response = await supabase
        .from('chats')
        .select('*, other_user:profiles!other_user_id(*)')
        .eq('user_id', userId)
        .order('last_message_time', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> createChat(String userId, String otherUserId) async {
    final response = await supabase
        .from('chats')
        .insert({'user_id': userId, 'other_user_id': otherUserId})
        .select()
        .single();
    return response;
  }

  static Future<List<Map<String, dynamic>>> getMessages(String chatId, {int limit = 50}) async {
    final response = await supabase
        .from('messages')
        .select()
        .eq('chat_id', chatId)
        .order('created_at', ascending: true)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> data) async {
    final response = await supabase.from('messages').insert(data).select().single();
    return response;
  }

  // ===== الطلبات =====
  static Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    final response = await supabase
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final response = await supabase.from('orders').insert(data).select().single();
    return response;
  }

  // ===== الإشعارات =====
  static Future<List<Map<String, dynamic>>> getNotifications(String userId, {int limit = 20}) async {
    final response = await supabase
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  static Future<void> markNotificationAsRead(String notificationId) async {
    await supabase.from('notifications').update({'is_read': true}).eq('id', notificationId);
  }
}
