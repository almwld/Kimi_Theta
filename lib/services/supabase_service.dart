import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static final supabase = Supabase.instance.client;

  static User? get currentUser => supabase.auth.currentUser;
  static bool get isAuthenticated => currentUser != null;

  static Future<AuthResponse> signIn(String email, String password) async {
    return await supabase.auth.signInWithPassword(email: email, password: password);
  }

  static Future<AuthResponse> signUp(String email, String password, {Map<String, dynamic>? data}) async {
    return await supabase.auth.signUp(email: email, password: password, data: data);
  }

  static Future<void> signOut() async {
    await supabase.auth.signOut();
  }

  static Future<List<Map<String, dynamic>>> getAds({
    String? category,
    String? city,
    String? search,
    int limit = 20,
    int offset = 0,
  }) async {
    var query = supabase.from('ads').select('*, profiles:user_id(*)');

    if (category != null && category.isNotEmpty) {
      query = query.filter('category', 'eq', category);
    }
    if (city != null && city.isNotEmpty) {
      query = query.filter('city', 'eq', city);
    }
    if (search != null && search.isNotEmpty) {
      query = query.filter('title', 'ilike', '%$search%');
    }

    final response = await query
        .order('created_at', ascending: false)
        .range(offset, offset + limit - 1);

    return List<Map<String, dynamic>>.from(response);
  }

  static Future<Map<String, dynamic>?> getAd(String id) async {
    final response = await supabase
        .from('ads')
        .select('*, profiles:user_id(*)')
        .filter('id', 'eq', id)
        .maybeSingle();
    return response;
  }

  static Future<void> addAd(Map<String, dynamic> adData) async {
    await supabase.from('ads').insert({
      ...adData,
      'user_id': currentUser!.id,
    });
  }

  // ... باقي الدوال بنفس الطريقة باستخدام `filter` بدلاً من `eq`, `gte`, `lte`
}
