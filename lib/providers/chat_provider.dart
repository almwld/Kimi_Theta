// موفر المحادثات - إدارة حالة المحادثات والرسائل
import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../services/supabase_service.dart';

class ChatProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();

  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  ChatModel? _currentChat;
  bool _isLoading = false;
  String? _error;
  bool _isTyping = false;
  RealtimeChannel? _messagesChannel;

  // getters
  List<ChatModel> get chats => _chats;
  List<MessageModel> get messages => _messages;
  ChatModel? get currentChat => _currentChat;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isTyping => _isTyping;

  // تهيئة الموفر
  Future<void> initialize(String userId) async {
    await loadChats(userId);
  }

  // تحميل المحادثات
  Future<void> loadChats(String userId) async {
    _setLoading(true);
    _clearError();

    try {
      _chats = await _supabaseService.getChats(userId);
      notifyListeners();
    } catch (e) {
      _setError('فشل تحميل المحادثات');
    } finally {
      _setLoading(false);
    }
  }

  // إنشاء محادثة جديدة
  Future<ChatModel?> createChat(
    String currentUserId,
    String otherUserId,
  ) async {
    _setLoading(true);
    _clearError();

    try {
      final chat = await _supabaseService.createChat(
        currentUserId,
        otherUserId,
      );

      if (chat != null) {
        // التحقق من عدم وجود المحادثة في القائمة
        final exists = _chats.any((c) => c.id == chat.id);
        if (!exists) {
          _chats.insert(0, chat);
          notifyListeners();
        }
      }

      return chat;
    } catch (e) {
      _setError('فشل إنشاء المحادثة');
      return null;
    } finally {
      _setLoading(false);
    }
  }

  // فتح محادثة
  Future<void> openChat(String chatId, String currentUserId) async {
    _setLoading(true);
    _clearError();

    try {
      // إيجاد المحادثة
      _currentChat = _chats.firstWhere(
        (c) => c.id == chatId,
        orElse: () => throw Exception('Chat not found'),
      );

      // تحميل الرسائل
      await loadMessages(chatId);

      // الاستماع للرسائل الجديدة
      _listenToMessages(chatId);

      notifyListeners();
    } catch (e) {
      _setError('فشل فتح المحادثة');
    } finally {
      _setLoading(false);
    }
  }

  // تحميل الرسائل
  Future<void> loadMessages(String chatId, {int limit = 50}) async {
    _setLoading(true);
    _clearError();

    try {
      _messages = await _supabaseService.getMessages(
        chatId,
        limit: limit,
      );
      notifyListeners();
    } catch (e) {
      _setError('فشل تحميل الرسائل');
    } finally {
      _setLoading(false);
    }
  }

  // إرسال رسالة
  Future<bool> sendMessage({
    required String chatId,
    required String senderId,
    required String content,
    String type = 'text',
    String? mediaUrl,
  }) async {
    try {
      final message = await _supabaseService.sendMessage({
        'chat_id': chatId,
        'sender_id': senderId,
        'content': content,
        'type': type,
        'media_url': mediaUrl,
        'created_at': DateTime.now().toIso8601String(),
        'is_read': false,
      });

      if (message != null) {
        _messages.add(message);
        
        // تحديث آخر رسالة في المحادثة
        final chatIndex = _chats.indexWhere((c) => c.id == chatId);
        if (chatIndex >= 0) {
          _chats[chatIndex] = ChatModel(
            id: _chats[chatIndex].id,
            participant1Id: _chats[chatIndex].participant1Id,
            participant2Id: _chats[chatIndex].participant2Id,
            participant1Name: _chats[chatIndex].participant1Name,
            participant2Name: _chats[chatIndex].participant2Name,
            participant1Avatar: _chats[chatIndex].participant1Avatar,
            participant2Avatar: _chats[chatIndex].participant2Avatar,
            lastMessage: content,
            lastMessageTime: DateTime.now(),
            unreadCount: _chats[chatIndex].unreadCount,
            lastMessageSenderId: senderId,
            isOnline: _chats[chatIndex].isOnline,
            createdAt: _chats[chatIndex].createdAt,
          );
          
          // نقل المحادثة إلى الأعلى
          final chat = _chats.removeAt(chatIndex);
          _chats.insert(0, chat);
        }

        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      debugPrint('Error sending message: $e');
      return false;
    }
  }

  // إرسال صورة
  Future<bool> sendImage(
    String chatId,
    String senderId,
    dynamic file,
  ) async {
    try {
      // رفع الصورة
      final imageUrl = await _supabaseService.uploadChatImage(chatId, file);
      
      if (imageUrl != null) {
        return await sendMessage(
          chatId: chatId,
          senderId: senderId,
          content: 'صورة',
          type: 'image',
          mediaUrl: imageUrl,
        );
      }
      return false;
    } catch (e) {
      debugPrint('Error sending image: $e');
      return false;
    }
  }

  // الاستماع للرسائل الجديدة
  void _listenToMessages(String chatId) {
    // إلغاء الاشتراك السابق
    _messagesChannel?.unsubscribe();

    _messagesChannel = _supabaseService.listenToMessages(
      chatId,
      (message) {
        // التحقق من عدم وجود الرسالة في القائمة
        final exists = _messages.any((m) => m.id == message.id);
        if (!exists) {
          _messages.add(message);
          notifyListeners();
        }
      },
    );
  }

  // تعيين حالة الكتابة
  void setTyping(bool value) {
    _isTyping = value;
    notifyListeners();
  }

  // البحث في المحادثات
  List<ChatModel> searchChats(String query, String currentUserId) {
    if (query.isEmpty) return _chats;

    return _chats.where((chat) {
      final otherName = chat.getOtherParticipantName(currentUserId);
      final lastMessage = chat.lastMessage ?? '';
      return otherName.toLowerCase().contains(query.toLowerCase()) ||
          lastMessage.toLowerCase().contains(query.toLowerCase());
    }).toList();
  }

  // الحصول على عدد الرسائل غير المقروءة
  int getUnreadCount(String userId) {
    return _chats.fold(0, (sum, chat) {
      if (chat.lastMessageSenderId != userId) {
        return sum + chat.unreadCount;
      }
      return sum;
    });
  }

  // إغلاق المحادثة الحالية
  void closeChat() {
    _currentChat = null;
    _messages = [];
    _messagesChannel?.unsubscribe();
    _messagesChannel = null;
    notifyListeners();
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
    _messagesChannel?.unsubscribe();
    super.dispose();
  }
}
