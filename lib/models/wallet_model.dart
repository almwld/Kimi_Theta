// نموذج المحفظة
import 'package:hive/hive.dart';

part 'wallet_model.g.dart';

@HiveType(typeId: 8)
class WalletModel {
  @HiveField(0)
  final String id;
  
  @HiveField(1)
  final String userId;
  
  @HiveField(2)
  final double yemeniRial;
  
  @HiveField(3)
  final double saudiRiyal;
  
  @HiveField(4)
  final double usDollar;
  
  @HiveField(5)
  final bool isActive;
  
  @HiveField(6)
  final DateTime createdAt;
  
  @HiveField(7)
  final DateTime updatedAt;
  
  @HiveField(8)
  final String? pinCode;
  
  @HiveField(9)
  final bool isPinEnabled;

  WalletModel({
    required this.id,
    required this.userId,
    this.yemeniRial = 0.0,
    this.saudiRiyal = 0.0,
    this.usDollar = 0.0,
    this.isActive = true,
    required this.createdAt,
    required this.updatedAt,
    this.pinCode,
    this.isPinEnabled = false,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      yemeniRial: (json['yemeni_rial'] ?? 0.0).toDouble(),
      saudiRiyal: (json['saudi_riyal'] ?? 0.0).toDouble(),
      usDollar: (json['us_dollar'] ?? 0.0).toDouble(),
      isActive: json['is_active'] ?? true,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : DateTime.now(),
      pinCode: json['pin_code'],
      isPinEnabled: json['is_pin_enabled'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'yemeni_rial': yemeniRial,
      'saudi_riyal': saudiRiyal,
      'us_dollar': usDollar,
      'is_active': isActive,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'pin_code': pinCode,
      'is_pin_enabled': isPinEnabled,
    };
  }

  double getTotalBalance(String currency) {
    switch (currency) {
      case 'YER':
        return yemeniRial;
      case 'SAR':
        return saudiRiyal;
      case 'USD':
        return usDollar;
      default:
        return 0.0;
    }
  }

  String getCurrencySymbol(String currency) {
    switch (currency) {
      case 'YER':
        return 'ر.ي';
      case 'SAR':
        return 'ر.س';
      case 'USD':
        return '\$';
      default:
        return '';
    }
  }
}
