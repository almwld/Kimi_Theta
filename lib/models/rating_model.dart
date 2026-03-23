class RatingModel {
  final String id;
  final String userId;
  final String productId;
  final int rating;
  final String? comment;
  final List<String>? images;
  final DateTime createdAt;

  RatingModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    this.comment,
    this.images,
    required this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'],
      userId: json['user_id'],
      productId: json['product_id'],
      rating: json['rating'],
      comment: json['comment'],
      images: json['images'] != null ? List<String>.from(json['images']) : null,
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'product_id': productId,
      'rating': rating,
      'comment': comment,
      'images': images,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
