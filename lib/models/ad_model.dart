// نموذج الإعلان
import 'package:hive/hive.dart';

part 'ad_model.g.dart';

@HiveType(typeId: 3)
class AdModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String subtitle;
  
  @HiveField(3)
  final String imageUrl;
  
  @HiveField(4)
  final String? targetUrl;
  
  @HiveField(5)
  final String type;
  
  @HiveField(6)
  final DateTime startDate;
  
  @HiveField(7)
  final DateTime endDate;
  
  @HiveField(8)
  final bool isActive;
  
  @HiveField(9)
  final int priority;
  
  @HiveField(10)
  final String? backgroundColor;
  
  @HiveField(11)
  final String? buttonText;

  AdModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.imageUrl,
    this.targetUrl,
    required this.type,
    required this.startDate,
    required this.endDate,
    this.isActive = true,
    this.priority = 0,
    this.backgroundColor,
    this.buttonText,
  });

  factory AdModel.fromJson(Map<String, dynamic> json) {
    return AdModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      subtitle: json['subtitle'] ?? '',
      imageUrl: json['image_url'] ?? '',
      targetUrl: json['target_url'],
      type: json['type'] ?? 'banner',
      startDate: json['start_date'] != null 
          ? DateTime.parse(json['start_date']) 
          : DateTime.now(),
      endDate: json['end_date'] != null 
          ? DateTime.parse(json['end_date']) 
          : DateTime.now(),
      isActive: json['is_active'] ?? true,
      priority: json['priority'] ?? 0,
      backgroundColor: json['background_color'],
      buttonText: json['button_text'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'subtitle': subtitle,
      'image_url': imageUrl,
      'target_url': targetUrl,
      'type': type,
      'start_date': startDate.toIso8601String(),
      'end_date': endDate.toIso8601String(),
      'is_active': isActive,
      'priority': priority,
      'background_color': backgroundColor,
      'button_text': buttonText,
    };
  }

  bool get isExpired => DateTime.now().isAfter(endDate);
}
