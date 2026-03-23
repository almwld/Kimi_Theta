class ProductModel {
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

  ProductModel({
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
}
