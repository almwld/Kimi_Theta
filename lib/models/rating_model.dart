class RatingModel {
  final String id;
  final String userId;
  final String productId;
  final int rating;
  final String? comment;
  final List<String>? images;
  final DateTime createdAt;
  final Map<String, dynamic>? user;

  RatingModel({
    required this.id,
    required this.userId,
    required this.productId,
    required this.rating,
    this.comment,
    this.images,
    required this.createdAt,
    this.user,
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
      user: json['user'],
    );
  }
}
