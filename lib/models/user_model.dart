// نموذج المستخدم
import 'package:hive/hive.dart';

part 'user_model.g.dart';

@HiveType(typeId: 1)
class UserModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String fullName;
  
  @HiveField(2)
  final String email;
  
  @HiveField(3)
  final String phone;
  
  @HiveField(4)
  final String? avatarUrl;
  
  @HiveField(5)
  final String? coverUrl;
  
  @HiveField(6)
  final String city;
  
  @HiveField(7)
  final String userType;
  
  @HiveField(8)
  final DateTime createdAt;
  
  @HiveField(9)
  final bool isVerified;
  
  @HiveField(10)
  final double rating;
  
  @HiveField(11)
  final int followersCount;
  
  @HiveField(12)
  final int followingCount;
  
  @HiveField(13)
  final int productsCount;

  UserModel({
    required this.id,
    required this.fullName,
    required this.email,
    required this.phone,
    this.avatarUrl,
    this.coverUrl,
    required this.city,
    required this.userType,
    required this.createdAt,
    this.isVerified = false,
    this.rating = 0.0,
    this.followersCount = 0,
    this.followingCount = 0,
    this.productsCount = 0,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? '',
      fullName: json['full_name'] ?? '',
      email: json['email'] ?? '',
      phone: json['phone'] ?? '',
      avatarUrl: json['avatar_url'],
      coverUrl: json['cover_url'],
      city: json['city'] ?? '',
      userType: json['user_type'] ?? 'customer',
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      isVerified: json['is_verified'] ?? false,
      rating: (json['rating'] ?? 0.0).toDouble(),
      followersCount: json['followers_count'] ?? 0,
      followingCount: json['following_count'] ?? 0,
      productsCount: json['products_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'email': email,
      'phone': phone,
      'avatar_url': avatarUrl,
      'cover_url': coverUrl,
      'city': city,
      'user_type': userType,
      'created_at': createdAt.toIso8601String(),
      'is_verified': isVerified,
      'rating': rating,
      'followers_count': followersCount,
      'following_count': followingCount,
      'products_count': productsCount,
    };
  }

  UserModel copyWith({
    String? id,
    String? fullName,
    String? email,
    String? phone,
    String? avatarUrl,
    String? coverUrl,
    String? city,
    String? userType,
    DateTime? createdAt,
    bool? isVerified,
    double? rating,
    int? followersCount,
    int? followingCount,
    int? productsCount,
  }) {
    return UserModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      coverUrl: coverUrl ?? this.coverUrl,
      city: city ?? this.city,
      userType: userType ?? this.userType,
      createdAt: createdAt ?? this.createdAt,
      isVerified: isVerified ?? this.isVerified,
      rating: rating ?? this.rating,
      followersCount: followersCount ?? this.followersCount,
      followingCount: followingCount ?? this.followingCount,
      productsCount: productsCount ?? this.productsCount,
    );
  }
}
