import 'package:flutter/material.dart';
import '../services/supabase_service.dart';

class ChatProvider extends ChangeNotifier {
  List<Map<String, dynamic>> _chats = [];
  List<Map<String, dynamic>> _messages = [];
  Map<String, dynamic>? _currentChat;
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get chats => _chats;
  List<Map<String, dynamic>> get messages => _messages;
  Map<String, dynamic>? get currentChat => _currentChat;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadChats(String userId) async {
    _isLoading = true;
    notifyListeners();

    try {
      _chats = await SupabaseService.getChats(userId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createChat(String userId, String otherUserId) async {
    _isLoading = true;
    notifyListeners();

    try {
      final newChat = await SupabaseService.createChat(userId, otherUserId);
      _chats.insert(0, newChat);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> loadMessages(String chatId, {int limit = 50}) async {
    _isLoading = true;
    notifyListeners();

    try {
      _messages = await SupabaseService.getMessages(chatId, limit: limit);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> sendMessage(Map<String, dynamic> messageData) async {
    try {
      final newMessage = await SupabaseService.sendMessage(messageData);
      _messages.add(newMessage);
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
