import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // ===== المصادقة =====
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

  // ===== المستخدم =====
  Future<Map<String, dynamic>?> getUser(String userId) async {
    final response = await _client
        .from('profiles')
        .select()
        .eq('id', userId)
        .maybeSingle();
    return response;
  }

  Future<void> updateUser(String userId, Map<String, dynamic> data) async {
    await _client.from('profiles').update(data).eq('id', userId);
  }

  // ===== المحفظة =====
  Future<Map<String, dynamic>?> getWallet(String userId) async {
    return await _client.from('wallets').select().eq('user_id', userId).maybeSingle();
  }

  Future<void> createWallet(String userId) async {
    await _client.from('wallets').insert({
      'user_id': userId,
      'yer_balance': 0,
      'sar_balance': 0,
      'usd_balance': 0,
    });
  }

  // ===== الطلبات =====
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

  // ===== المنتجات (للاستخدام العام) =====
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
}
