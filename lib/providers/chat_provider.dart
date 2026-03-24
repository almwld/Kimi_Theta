import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ChatProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _messages = [];

  List<Map<String, dynamic>> get chats => _chats;
  List<Map<String, dynamic>> get messages => _messages;

  Future<void> loadChats(String userId) async {
    _chats = await SupabaseService.getChats(userId);
    notifyListeners();
  }

  Future<void> loadMessages(String chatId, {int limit = 50}) async {
    _messages = await SupabaseService.getMessages(chatId, limit: limit);
    notifyListeners();
  }

  Future<void> sendMessage(Map<String, dynamic> messageData) async {
    final newMessage = await SupabaseService.sendMessage(messageData);
    _messages.add(newMessage);
    notifyListeners();
  }

  Future<void> createChat(String userId, String otherUserId) async {
    final newChat = await SupabaseService.createChat(userId, otherUserId);
    _chats.insert(0, newChat);
    notifyListeners();
  }
}
