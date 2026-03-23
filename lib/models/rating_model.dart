// نموذج التقييم
import 'package:hive/hive.dart';

part 'rating_model.g.dart';

@HiveType(typeId: 11)
class RatingModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String productId;
  
  @HiveField(2)
  final String userId;
  
  @HiveField(3)
  final String userName;
  
  @HiveField(4)
  final String? userAvatar;
  
  @HiveField(5)
  final double rating;
  
  @HiveField(6)
  final String comment;
  
  @HiveField(7)
  final List<String>? images;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final bool isVerifiedPurchase;
  
  @HiveField(10)
  final int helpfulCount;
  
  @HiveField(11)
  final String? sellerResponse;
  
  @HiveField(12)
  final DateTime? sellerResponseDate;

  RatingModel({
    required this.id,
    required this.productId,
    required this.userId,
    required this.userName,
    this.userAvatar,
    required this.rating,
    required this.comment,
    this.images,
    required this.createdAt,
    this.isVerifiedPurchase = false,
    this.helpfulCount = 0,
    this.sellerResponse,
    this.sellerResponseDate,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] ?? '',
      productId: json['product_id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userAvatar: json['user_avatar'],
      rating: (json['rating'] ?? 0.0).toDouble(),
      comment: json['comment'] ?? '',
      images: json['images'] != null 
          ? List<String>.from(json['images']) 
          : null,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      isVerifiedPurchase: json['is_verified_purchase'] ?? false,
      helpfulCount: json['helpful_count'] ?? 0,
      sellerResponse: json['seller_response'],
      sellerResponseDate: json['seller_response_date'] != null 
          ? DateTime.parse(json['seller_response_date']) 
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'product_id': productId,
      'user_id': userId,
      'user_name': userName,
      'user_avatar': userAvatar,
      'rating': rating,
      'comment': comment,
      'images': images,
      'created_at': createdAt.toIso8601String(),
      'is_verified_purchase': isVerifiedPurchase,
      'helpful_count': helpfulCount,
      'seller_response': sellerResponse,
      'seller_response_date': sellerResponseDate?.toIso8601String(),
    };
  }

  String get formattedDate {
    final day = createdAt.day.toString().padLeft(2, '0');
    final month = createdAt.month.toString().padLeft(2, '0');
    final year = createdAt.year;
    return '$day/$month/$year';
  }

  String get initials {
    if (userName.isEmpty) return '';
    final parts = userName.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return userName[0].toUpperCase();
  }
}
