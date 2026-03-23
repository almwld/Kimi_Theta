// أدوات مساعدة
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Helpers {
  // تنسيق التاريخ
  static String formatDate(DateTime date, {String format = 'yyyy-MM-dd'}) {
    return DateFormat(format, 'ar').format(date);
  }

  // تنسيق الوقت
  static String formatTime(DateTime time) {
    return DateFormat('HH:mm', 'ar').format(time);
  }

  // تنسيق التاريخ والوقت
  static String formatDateTime(DateTime dateTime) {
    return DateFormat('yyyy-MM-dd HH:mm', 'ar').format(dateTime);
  }

  // تنسيق المبلغ
  static String formatCurrency(double amount, {String currency = 'YER'}) {
    final formatter = NumberFormat('#,##0.00', 'ar');
    final symbol = _getCurrencySymbol(currency);
    return '${formatter.format(amount)} $symbol';
  }

  // الحصول على رمز العملة
  static String _getCurrencySymbol(String currency) {
    switch (currency) {
      case 'YER':
        return 'ر.ي';
      case 'SAR':
        return 'ر.س';
      case 'USD':
        return '\$';
      default:
        return currency;
    }
  }

  // تنسيق الرقم
  static String formatNumber(int number) {
    final formatter = NumberFormat('#,###', 'ar');
    return formatter.format(number);
  }

  // حساب الوقت المنقضي
  static String timeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays > 365) {
      return 'منذ ${(difference.inDays / 365).floor()} سنة';
    } else if (difference.inDays > 30) {
      return 'منذ ${(difference.inDays / 30).floor()} شهر';
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

  // اختصار النص
  static String truncateText(String text, int maxLength) {
    if (text.length <= maxLength) return text;
    return '${text.substring(0, maxLength)}...';
  }

  // التحقق من صحة البريد الإلكتروني
  static bool isValidEmail(String email) {
    final regex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return regex.hasMatch(email);
  }

  // التحقق من صحة رقم الهاتف اليمني
  static bool isValidYemeniPhone(String phone) {
    final regex = RegExp(r'^((\+967|00967|0)?[137]\d{8})$');
    return regex.hasMatch(phone);
  }

  // تنسيق رقم الهاتف
  static String formatPhoneNumber(String phone) {
    if (phone.startsWith('+967')) {
      return phone;
    } else if (phone.startsWith('00967')) {
      return '+967${phone.substring(5)}';
    } else if (phone.startsWith('0')) {
      return '+967${phone.substring(1)}';
    }
    return '+967$phone';
  }

  // الحصول على الأحرف الأولى
  static String getInitials(String name) {
    if (name.isEmpty) return '';
    final parts = name.split(' ');
    if (parts.length > 1) {
      return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    }
    return name[0].toUpperCase();
  }

  // إنشاء ظل
  static List<BoxShadow> createShadow({
    Color color = Colors.black,
    double opacity = 0.1,
    double blurRadius = 10,
    Offset offset = const Offset(0, 4),
  }) {
    return [
      BoxShadow(
        color: color.withOpacity(opacity),
        blurRadius: blurRadius,
        offset: offset,
      ),
    ];
  }

  // عرض Snackbar
  static void showSnackBar(
    BuildContext context, {
    required String message,
    Color? backgroundColor,
    Duration duration = const Duration(seconds: 3),
  }) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        backgroundColor: backgroundColor,
        duration: duration,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  // عرض Dialog
  static Future<bool?> showConfirmDialog(
    BuildContext context, {
    required String title,
    required String message,
    String confirmText = 'تأكيد',
    String cancelText = 'إلغاء',
    Color? confirmColor,
  }) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: TextStyle(
            fontFamily: 'Changa',
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          message,
          style: TextStyle(fontFamily: 'Tajawal'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              cancelText,
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: confirmColor,
            ),
            child: Text(
              confirmText,
              style: TextStyle(fontFamily: 'Tajawal'),
            ),
          ),
        ],
      ),
    );
  }
}

// ملحقات على String
extension StringExtensions on String {
  String get capitalize {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  String get toCamelCase {
    return split(' ').map((word) => word.capitalize).join(' ');
  }
}

// ملحقات على DateTime
extension DateTimeExtensions on DateTime {
  String get formattedDate => Helpers.formatDate(this);
  String get formattedTime => Helpers.formatTime(this);
  String get formattedDateTime => Helpers.formatDateTime(this);
  String get timeAgo => Helpers.timeAgo(this);
}

// ملحقات على double
extension DoubleExtensions on double {
  String get formattedCurrency => Helpers.formatCurrency(this);
}

// ملحقات على int
extension IntExtensions on int {
  String get formattedNumber => Helpers.formatNumber(this);
}
