import 'package:flutter/material.dart';
import '../services/supabase_service.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';

class ChatProvider extends ChangeNotifier {
  final SupabaseService _supabaseService = SupabaseService();
  List<ChatModel> _chats = [];
  List<MessageModel> _messages = [];
  ChatModel? _currentChat;

  List<ChatModel> get chats => _chats;
  List<MessageModel> get messages => _messages;
  ChatModel? get currentChat => _currentChat;

  Future<void> fetchChats(String userId) async {
    _chats = await _supabaseService.getChats(userId);
    notifyListeners();
  }

  Future<void> createChat(String userId, String otherUserId) async {
    final chat = await _supabaseService.createChat(userId, otherUserId);
    _chats.insert(0, chat);
    notifyListeners();
  }

  Future<void> fetchMessages(String chatId, {int limit = 50}) async {
    _messages = await _supabaseService.getMessages(chatId, limit: limit);
    notifyListeners();
  }

  Future<void> sendMessage(Map<String, dynamic> data) async {
    final message = await _supabaseService.sendMessage(data);
    _messages.add(message);
    notifyListeners();
  }

  void listenToMessages(String chatId) {
    _supabaseService.listenToMessages(chatId).listen((messages) {
      _messages = messages;
      notifyListeners();
    });
  }
}
