import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // المصادقة
  Future<AuthResponse> signIn(String email, String password) async {
    return await _client.auth.signInWithPassword(email: email, password: password);
  }

  Future<AuthResponse> signUp(String email, String password, {Map<String, dynamic>? data}) async {
    return await _client.auth.signUp(email: email, password: password, data: data);
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  Future<void> resetPassword(String email) async {
    await _client.auth.resetPasswordForEmail(email);
  }

  Future<void> updatePassword(String newPassword) async {
    await _client.auth.updateUser(UserAttributes(password: newPassword));
  }

  // المستخدم
  Future<Map<String, dynamic>?> getUser(String userId) async {
    return await _client.from('profiles').select().eq('id', userId).maybeSingle();
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _client.from('profiles').update(data).eq('id', userId);
  }

  Future<String> uploadAvatar(String userId, String path) async {
    // dummy
    return 'https://example.com/avatar.png';
  }

  // المنتجات
  Future<List<Map<String, dynamic>>> getProducts({
    String? category,
    String? city,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = _client.from('products').select();
    if (category != null && category.isNotEmpty) query = query.filter('category', 'eq', category);
    if (city != null && city.isNotEmpty) query = query.filter('city', 'eq', city);
    final response = await query.order('created_at', ascending: false).range(offset, offset + limit - 1);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>?> getProduct(String id) async {
    return await _client.from('products').select().eq('id', id).maybeSingle();
  }

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    final response = await _client.from('products').insert(data).select().single();
    return response;
  }

  Future<void> updateProduct(String id, Map<String, dynamic> data) async {
    await _client.from('products').update(data).eq('id', id);
  }

  Future<void> deleteProduct(String id) async {
    await _client.from('products').delete().eq('id', id);
  }

  // المفضلة
  Future<void> addToFavorites(String userId, String productId) async {
    await _client.from('favorites').insert({'user_id': userId, 'product_id': productId});
  }

  Future<void> removeFromFavorites(String userId, String productId) async {
    await _client.from('favorites').delete().eq('user_id', userId).eq('product_id', productId);
  }

  Future<List<String>> getFavorites(String userId) async {
    final response = await _client.from('favorites').select('product_id').eq('user_id', userId);
    return List<String>.from(response.map((e) => e['product_id']));
  }

  // المحفظة
  Future<Map<String, dynamic>?> getWallet(String userId) async {
    return await _client.from('wallets').select().eq('user_id', userId).maybeSingle();
  }

  Future<void> createWallet(String userId) async {
    await _client.from('wallets').insert({'user_id': userId, 'yer_balance': 0, 'sar_balance': 0, 'usd_balance': 0});
  }

  Future<void> updateBalance(String walletId, String currency, double amount) async {
    await _client.from('wallets').update({'${currency.toLowerCase()}_balance': amount}).eq('id', walletId);
  }

  Future<List<Map<String, dynamic>>> getTransactions(String userId, {int limit = 20}) async {
    final response = await _client
        .from('transactions')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> createTransaction(Map<String, dynamic> data) async {
    await _client.from('transactions').insert(data);
  }

  // المحادثات
  Future<List<Map<String, dynamic>>> getChats(String userId) async {
    final response = await _client
        .from('chats')
        .select('*, other_user:profiles!other_user_id(*)')
        .eq('user_id', userId)
        .order('last_message_time', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createChat(String userId, String otherUserId) async {
    final response = await _client
        .from('chats')
        .insert({'user_id': userId, 'other_user_id': otherUserId})
        .select()
        .single();
    return response;
  }

  Future<List<Map<String, dynamic>>> getMessages(String chatId) async {
    final response = await _client
        .from('messages')
        .select()
        .eq('chat_id', chatId)
        .order('created_at', ascending: true);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> sendMessage(Map<String, dynamic> data) async {
    final response = await _client.from('messages').insert(data).select().single();
    return response;
  }

  Future<String> uploadChatImage(String chatId, String filePath) async {
    // dummy
    return 'https://example.com/chat_image.png';
  }

  Stream<List<Map<String, dynamic>>> listenToMessages(String chatId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('chat_id', chatId)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }

  // الطلبات
  Future<List<Map<String, dynamic>>> getUserOrders(String userId) async {
    final response = await _client
        .from('orders')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<Map<String, dynamic>> createOrder(Map<String, dynamic> data) async {
    final response = await _client.from('orders').insert(data).select().single();
    return response;
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    await _client.from('orders').update({'status': status}).eq('id', orderId);
  }

  // الإشعارات
  Future<List<Map<String, dynamic>>> getNotifications(String userId, {int limit = 20}) async {
    final response = await _client
        .from('notifications')
        .select()
        .eq('user_id', userId)
        .order('created_at', ascending: false)
        .limit(limit);
    return List<Map<String, dynamic>>.from(response);
  }

  Future<void> markNotificationAsRead(String notificationId) async {
    await _client.from('notifications').update({'is_read': true}).eq('id', notificationId);
  }

  Stream<List<Map<String, dynamic>>> listenToNotifications(String userId) {
    return _client
        .from('notifications')
        .stream(primaryKey: ['id'])
        .eq('user_id', userId)
        .map((data) => List<Map<String, dynamic>>.from(data));
  }
}
