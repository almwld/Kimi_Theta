// نموذج المنتج
import 'package:hive/hive.dart';

part 'product_model.g.dart';

@HiveType(typeId: 2)
class ProductModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String title;
  
  @HiveField(2)
  final String description;
  
  @HiveField(3)
  final double price;
  
  @HiveField(4)
  final double? oldPrice;
  
  @HiveField(5)
  final List<String> images;
  
  @HiveField(6)
  final String category;
  
  @HiveField(7)
  final String subCategory;
  
  @HiveField(8)
  final String condition;
  
  @HiveField(9)
  final String city;
  
  @HiveField(10)
  final String sellerId;
  
  @HiveField(11)
  final String sellerName;
  
  @HiveField(12)
  final String? sellerAvatar;
  
  @HiveField(13)
  final double sellerRating;
  
  @HiveField(14)
  final DateTime createdAt;
  
  @HiveField(15)
  final bool isFeatured;
  
  @HiveField(16)
  final bool isAuction;
  
  @HiveField(17)
  final DateTime? auctionEndTime;
  
  @HiveField(18)
  final double? currentBid;
  
  @HiveField(19)
  final int viewsCount;
  
  @HiveField(20)
  final int favoritesCount;
  
  @HiveField(21)
  final double rating;
  
  @HiveField(22)
  final int reviewsCount;
  
  @HiveField(23)
  final bool hasWarranty;
  
  @HiveField(24)
  final bool hasShipping;
  
  @HiveField(25)
  final bool is negotiable;

  ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.images,
    required this.category,
    required this.subCategory,
    required this.condition,
    required this.city,
    required this.sellerId,
    required this.sellerName,
    this.sellerAvatar,
    required this.sellerRating,
    required this.createdAt,
    this.isFeatured = false,
    this.isAuction = false,
    this.auctionEndTime,
    this.currentBid,
    this.viewsCount = 0,
    this.favoritesCount = 0,
    this.rating = 0.0,
    this.reviewsCount = 0,
    this.hasWarranty = false,
    this.hasShipping = false,
    this.is negotiable = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      price: (json['price'] ?? 0.0).toDouble(),
      oldPrice: json['old_price']?.toDouble(),
      images: List<String>.from(json['images'] ?? []),
      category: json['category'] ?? '',
      subCategory: json['sub_category'] ?? '',
      condition: json['condition'] ?? 'new',
      city: json['city'] ?? '',
      sellerId: json['seller_id'] ?? '',
      sellerName: json['seller_name'] ?? '',
      sellerAvatar: json['seller_avatar'],
      sellerRating: (json['seller_rating'] ?? 0.0).toDouble(),
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      isFeatured: json['is_featured'] ?? false,
      isAuction: json['is_auction'] ?? false,
      auctionEndTime: json['auction_end_time'] != null 
          ? DateTime.parse(json['auction_end_time']) 
          : null,
      currentBid: json['current_bid']?.toDouble(),
      viewsCount: json['views_count'] ?? 0,
      favoritesCount: json['favorites_count'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      reviewsCount: json['reviews_count'] ?? 0,
      hasWarranty: json['has_warranty'] ?? false,
      hasShipping: json['has_shipping'] ?? false,
      is negotiable: json['is_negotiable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'old_price': oldPrice,
      'images': images,
      'category': category,
      'sub_category': subCategory,
      'condition': condition,
      'city': city,
      'seller_id': sellerId,
      'seller_name': sellerName,
      'seller_avatar': sellerAvatar,
      'seller_rating': sellerRating,
      'created_at': createdAt.toIso8601String(),
      'is_featured': isFeatured,
      'is_auction': isAuction,
      'auction_end_time': auctionEndTime?.toIso8601String(),
      'current_bid': currentBid,
      'views_count': viewsCount,
      'favorites_count': favoritesCount,
      'rating': rating,
      'reviews_count': reviewsCount,
      'has_warranty': hasWarranty,
      'has_shipping': hasShipping,
      'is_negotiable': is negotiable,
    };
  }

  double get discountPercentage {
    if (oldPrice == null || oldPrice == 0) return 0;
    return ((oldPrice! - price) / oldPrice! * 100).roundToDouble();
  }

  bool get isOnSale => oldPrice != null && oldPrice! > price;
}
