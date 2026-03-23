// نموذج الإشعار
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

part 'notification_model.g.dart';

@HiveType(typeId: 10)
class NotificationModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final String title;
  
  @HiveField(3)
  final String body;
  
  @HiveField(4)
  final String type;
  
  @HiveField(5)
  final String? imageUrl;
  
  @HiveField(6)
  final String? targetId;
  
  @HiveField(7)
  final String? targetType;
  
  @HiveField(8)
  final bool isRead;
  
  @HiveField(9)
  final DateTime createdAt;
  
  @HiveField(10)
  final DateTime? readAt;

  NotificationModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.body,
    required this.type,
    this.imageUrl,
    this.targetId,
    this.targetType,
    this.isRead = false,
    required this.createdAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) {
    return NotificationModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      type: json['type'] ?? 'general',
      imageUrl: json['image_url'],
      targetId: json['target_id'],
      targetType: json['target_type'],
      isRead: json['is_read'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      readAt: json['read_at'] != null 
          ? DateTime.parse(json['read_at']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'title': title,
      'body': body,
      'type': type,
      'image_url': imageUrl,
      'target_id': targetId,
      'target_type': targetType,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'read_at': readAt?.toIso8601String(),
    };
  }

  IconData get icon {
    switch (type) {
      case 'order':
        return Icons.shopping_bag;
      case 'message':
        return Icons.message;
      case 'product':
        return Icons.inventory_2;
      case 'wallet':
        return Icons.account_balance_wallet;
      case 'promotion':
        return Icons.local_offer;
      case 'system':
        return Icons.info;
      case 'review':
        return Icons.star;
      case 'follow':
        return Icons.person_add;
      default:
        return Icons.notifications;
    }
  }

  Color get iconColor {
    switch (type) {
      case 'order':
        return Colors.blue;
      case 'message':
        return Colors.green;
      case 'product':
        return Colors.orange;
      case 'wallet':
        return Colors.purple;
      case 'promotion':
        return Colors.red;
      case 'system':
        return Colors.grey;
      case 'review':
        return Colors.amber;
      case 'follow':
        return Colors.teal;
      default:
        return Colors.blueGrey;
    }
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return '${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return '${(difference.inDays / 30).floor()} شهر';
    } else if (difference.inDays > 0) {
      return '${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return '${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }
}
