import 'package:equatable/equatable.dart';

class ProductModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final double price;
  final double? oldPrice;
  final String category;
  final String city;
  final List<String> images;
  final String sellerId;
  final String sellerName;
  final String? sellerAvatar;
  final double sellerRating;
  final DateTime createdAt;
  final bool isFeatured;
  final bool isAuction;
  final DateTime? auctionEndTime;
  final double? currentBid;
  final int viewsCount;
  final int favoritesCount;
  final double rating;
  final int reviewsCount;
  final bool hasWarranty;
  final bool hasShipping;
  final bool isNegotiable;

  const ProductModel({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    this.oldPrice,
    required this.category,
    required this.city,
    required this.images,
    required this.sellerId,
    required this.sellerName,
    this.sellerAvatar,
    this.sellerRating = 0.0,
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
    this.isNegotiable = false,
  });

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      price: (json['price'] as num).toDouble(),
      oldPrice: json['oldPrice'] != null ? (json['oldPrice'] as num).toDouble() : null,
      category: json['category'],
      city: json['city'],
      images: List<String>.from(json['images'] ?? []),
      sellerId: json['sellerId'],
      sellerName: json['sellerName'],
      sellerAvatar: json['sellerAvatar'],
      sellerRating: (json['sellerRating'] as num?)?.toDouble() ?? 0.0,
      createdAt: DateTime.parse(json['createdAt']),
      isFeatured: json['isFeatured'] ?? false,
      isAuction: json['isAuction'] ?? false,
      auctionEndTime: json['auctionEndTime'] != null ? DateTime.parse(json['auctionEndTime']) : null,
      currentBid: json['currentBid'] != null ? (json['currentBid'] as num).toDouble() : null,
      viewsCount: json['viewsCount'] ?? 0,
      favoritesCount: json['favoritesCount'] ?? 0,
      rating: (json['rating'] as num?)?.toDouble() ?? 0.0,
      reviewsCount: json['reviewsCount'] ?? 0,
      hasWarranty: json['hasWarranty'] ?? false,
      hasShipping: json['hasShipping'] ?? false,
      isNegotiable: json['isNegotiable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'price': price,
      'oldPrice': oldPrice,
      'category': category,
      'city': city,
      'images': images,
      'sellerId': sellerId,
      'sellerName': sellerName,
      'sellerAvatar': sellerAvatar,
      'sellerRating': sellerRating,
      'createdAt': createdAt.toIso8601String(),
      'isFeatured': isFeatured,
      'isAuction': isAuction,
      'auctionEndTime': auctionEndTime?.toIso8601String(),
      'currentBid': currentBid,
      'viewsCount': viewsCount,
      'favoritesCount': favoritesCount,
      'rating': rating,
      'reviewsCount': reviewsCount,
      'hasWarranty': hasWarranty,
      'hasShipping': hasShipping,
      'isNegotiable': isNegotiable,
    };
  }

  ProductModel copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    double? oldPrice,
    String? category,
    String? city,
    List<String>? images,
    String? sellerId,
    String? sellerName,
    String? sellerAvatar,
    double? sellerRating,
    DateTime? createdAt,
    bool? isFeatured,
    bool? isAuction,
    DateTime? auctionEndTime,
    double? currentBid,
    int? viewsCount,
    int? favoritesCount,
    double? rating,
    int? reviewsCount,
    bool? hasWarranty,
    bool? hasShipping,
    bool? isNegotiable,
  }) {
    return ProductModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      price: price ?? this.price,
      oldPrice: oldPrice ?? this.oldPrice,
      category: category ?? this.category,
      city: city ?? this.city,
      images: images ?? this.images,
      sellerId: sellerId ?? this.sellerId,
      sellerName: sellerName ?? this.sellerName,
      sellerAvatar: sellerAvatar ?? this.sellerAvatar,
      sellerRating: sellerRating ?? this.sellerRating,
      createdAt: createdAt ?? this.createdAt,
      isFeatured: isFeatured ?? this.isFeatured,
      isAuction: isAuction ?? this.isAuction,
      auctionEndTime: auctionEndTime ?? this.auctionEndTime,
      currentBid: currentBid ?? this.currentBid,
      viewsCount: viewsCount ?? this.viewsCount,
      favoritesCount: favoritesCount ?? this.favoritesCount,
      rating: rating ?? this.rating,
      reviewsCount: reviewsCount ?? this.reviewsCount,
      hasWarranty: hasWarranty ?? this.hasWarranty,
      hasShipping: hasShipping ?? this.hasShipping,
      isNegotiable: isNegotiable ?? this.isNegotiable,
    );
  }

  String get formattedPrice {
    if (price >= 1000000) {
      return '${(price / 1000000).toStringAsFixed(1)}M';
    } else if (price >= 1000) {
      return '${(price / 1000).toStringAsFixed(0)}K';
    }
    return price.toStringAsFixed(0);
  }

  String get timeAgo {
    final now = DateTime.now();
    final difference = now.difference(createdAt);

    if (difference.inDays > 365) {
      return 'منذ ${difference.inDays ~/ 365} سنة';
    } else if (difference.inDays > 30) {
      return 'منذ ${difference.inDays ~/ 30} شهر';
    } else if (difference.inDays > 0) {
      return 'منذ ${difference.inDays} يوم';
    } else if (difference.inHours > 0) {
      return 'منذ ${difference.inHours} ساعة';
    } else if (difference.inMinutes > 0) {
      return 'منذ ${difference.inMinutes} دقيقة';
    } else {
      return 'الآن';
    }
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        price,
        oldPrice,
        category,
        city,
        images,
        sellerId,
        sellerName,
        sellerAvatar,
        sellerRating,
        createdAt,
        isFeatured,
        isAuction,
        auctionEndTime,
        currentBid,
        viewsCount,
        favoritesCount,
        rating,
        reviewsCount,
        hasWarranty,
        hasShipping,
        isNegotiable,
      ];
}
