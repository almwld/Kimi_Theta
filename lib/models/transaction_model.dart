class TransactionModel {
  final String id;
  final String userId;
  final String type;
  final double amount;
  final String currency;
  final String? description;
  final String? recipientId;
  final DateTime createdAt;
  final Map<String, dynamic>? recipient;

  TransactionModel({
    required this.id,
    required this.userId,
    required this.type,
    required this.amount,
    required this.currency,
    this.description,
    this.recipientId,
    required this.createdAt,
    this.recipient,
  });

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'],
      userId: json['user_id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'],
      description: json['description'],
      recipientId: json['recipient_id'],
      createdAt: DateTime.parse(json['created_at']),
      recipient: json['recipient'],
    );
  }
}
