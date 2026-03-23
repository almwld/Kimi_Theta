// نموذج المحادثة
import 'package:hive/hive.dart';

part 'chat_model.g.dart';

@HiveType(typeId: 6)
class ChatModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String participant1Id;
  
  @HiveField(2)
  final String participant2Id;
  
  @HiveField(3)
  final String participant1Name;
  
  @HiveField(4)
  final String participant2Name;
  
  @HiveField(5)
  final String? participant1Avatar;
  
  @HiveField(6)
  final String? participant2Avatar;
  
  @HiveField(7)
  final String? lastMessage;
  
  @HiveField(8)
  final DateTime? lastMessageTime;
  
  @HiveField(9)
  final int unreadCount;
  
  @HiveField(10)
  final String? lastMessageSenderId;
  
  @HiveField(11)
  final bool isOnline;
  
  @HiveField(12)
  final DateTime createdAt;

  ChatModel({
    required this.id,
    required this.participant1Id,
    required this.participant2Id,
    required this.participant1Name,
    required this.participant2Name,
    this.participant1Avatar,
    this.participant2Avatar,
    this.lastMessage,
    this.lastMessageTime,
    this.unreadCount = 0,
    this.lastMessageSenderId,
    this.isOnline = false,
    required this.createdAt,
  });

  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'] ?? '',
      participant1Id: json['participant1_id'] ?? '',
      participant2Id: json['participant2_id'] ?? '',
      participant1Name: json['participant1_name'] ?? '',
      participant2Name: json['participant2_name'] ?? '',
      participant1Avatar: json['participant1_avatar'],
      participant2Avatar: json['participant2_avatar'],
      lastMessage: json['last_message'],
      lastMessageTime: json['last_message_time'] != null 
          ? DateTime.parse(json['last_message_time']) 
          : null,
      unreadCount: json['unread_count'] ?? 0,
      lastMessageSenderId: json['last_message_sender_id'],
      isOnline: json['is_online'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'participant1_id': participant1Id,
      'participant2_id': participant2Id,
      'participant1_name': participant1Name,
      'participant2_name': participant2Name,
      'participant1_avatar': participant1Avatar,
      'participant2_avatar': participant2Avatar,
      'last_message': lastMessage,
      'last_message_time': lastMessageTime?.toIso8601String(),
      'unread_count': unreadCount,
      'last_message_sender_id': lastMessageSenderId,
      'is_online': isOnline,
      'created_at': createdAt.toIso8601String(),
    };
  }

  String getOtherParticipantName(String currentUserId) {
    return currentUserId == participant1Id ? participant2Name : participant1Name;
  }

  String? getOtherParticipantAvatar(String currentUserId) {
    return currentUserId == participant1Id ? participant2Avatar : participant1Avatar;
  }
}
