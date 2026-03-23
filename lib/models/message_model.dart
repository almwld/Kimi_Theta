// نموذج الرسالة
import 'package:hive/hive.dart';

part 'message_model.g.dart';

@HiveType(typeId: 7)
class MessageModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String chatId;
  
  @HiveField(2)
  final String senderId;
  
  @HiveField(3)
  final String content;
  
  @HiveField(4)
  final String type;
  
  @HiveField(5)
  final String? mediaUrl;
  
  @HiveField(6)
  final DateTime createdAt;
  
  @HiveField(7)
  final bool isRead;
  
  @HiveField(8)
  final DateTime? readAt;
  
  @HiveField(9)
  final bool isDeleted;
  
  @HiveField(10)
  final String? replyToMessageId;
  
  @HiveField(11)
  final String? replyToContent;

  MessageModel({
    required this.id,
    required this.chatId,
    required this.senderId,
    required this.content,
    this.type = 'text',
    this.mediaUrl,
    required this.createdAt,
    this.isRead = false,
    this.readAt,
    this.isDeleted = false,
    this.replyToMessageId,
    this.replyToContent,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) {
    return MessageModel(
      id: json['id'] ?? '',
      chatId: json['chat_id'] ?? '',
      senderId: json['sender_id'] ?? '',
      content: json['content'] ?? '',
      type: json['type'] ?? 'text',
      mediaUrl: json['media_url'],
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      isRead: json['is_read'] ?? false,
      readAt: json['read_at'] != null 
          ? DateTime.parse(json['read_at']) 
          : null,
      isDeleted: json['is_deleted'] ?? false,
      replyToMessageId: json['reply_to_message_id'],
      replyToContent: json['reply_to_content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'chat_id': chatId,
      'sender_id': senderId,
      'content': content,
      'type': type,
      'media_url': mediaUrl,
      'created_at': createdAt.toIso8601String(),
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'is_deleted': isDeleted,
      'reply_to_message_id': replyToMessageId,
      'reply_to_content': replyToContent,
    };
  }

  bool get isImage => type == 'image';
  bool get isText => type == 'text';
  bool get isFile => type == 'file';

  String get formattedTime {
    final hour = createdAt.hour.toString().padLeft(2, '0');
    final minute = createdAt.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
