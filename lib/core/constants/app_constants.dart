// الثوابت العامة للتطبيق
import 'package:flutter/material.dart';

class AppConstants {
  // معلومات التطبيق
  static const String appName = 'Flex Yemen';
  static const String appNameAr = 'فليكس اليمن';
  static const String appVersion = '1.0.0';
  static const String appBuildNumber = '1';
  
  // روابط التواصل
  static const String supportPhone = '+967-XXX-XXXXXX';
  static const String supportEmail = 'support@flexyemen.com';
  static const String websiteUrl = 'https://flexyemen.com';
  static const String privacyPolicyUrl = 'https://flexyemen.com/privacy';
  static const String termsUrl = 'https://flexyemen.com/terms';
  
  // المدن اليمنية
  static const List<String> yemeniCities = [
    'صنعاء',
    'عدن',
    'تعز',
    'الحديدة',
    'المكلا',
    'إب',
    'ذمار',
    'البيضاء',
    'سيئون',
    'زبيد',
    'ريمة',
    'عمران',
    'حجة',
    'صعدة',
    'مارب',
    'الجوف',
    'أبين',
    'شبوة',
    'لحج',
    'الضالع',
    'المهرة',
    'سقطرى',
  ];
  
  // فئات المنتجات
  static const List<Map<String, dynamic>> categories = [
    {'id': 'electronics', 'name': 'إلكترونيات', 'icon': 'devices'},
    {'id': 'phones', 'name': 'هواتف', 'icon': 'smartphone'},
    {'id': 'laptops', 'name': 'لابتوبات', 'icon': 'laptop'},
    {'id': 'fashion', 'name': 'أزياء', 'icon': 'checkroom'},
    {'id': 'home', 'name': 'منزل', 'icon': 'home'},
    {'id': 'cars', 'name': 'سيارات', 'icon': 'directions_car'},
    {'id': 'real_estate', 'name': 'عقارات', 'icon': 'apartment'},
    {'id': 'sports', 'name': 'رياضة', 'icon': 'sports'},
    {'id': 'books', 'name': 'كتب', 'icon': 'menu_book'},
    {'id': 'beauty', 'name': 'جمال', 'icon': 'spa'},
    {'id': 'toys', 'name': 'ألعاب', 'icon': 'toys'},
    {'id': 'food', 'name': 'طعام', 'icon': 'restaurant'},
    {'id': 'services', 'name': 'خدمات', 'icon': 'build'},
    {'id': 'jobs', 'name': 'وظائف', 'icon': 'work'},
  ];
  
  // أنواع المستخدمين
  static const String userTypeCustomer = 'customer';
  static const String userTypeSeller = 'seller';
  static const String userTypeAdmin = 'admin';
  
  // حالات الطلب
  static const String orderStatusPending = 'pending';
  static const String orderStatusConfirmed = 'confirmed';
  static const String orderStatusProcessing = 'processing';
  static const String orderStatusShipped = 'shipped';
  static const String orderStatusDelivered = 'delivered';
  static const String orderStatusCancelled = 'cancelled';
  static const String orderStatusRefunded = 'refunded';
  
  // أنواع المعاملات
  static const String transactionTypeDeposit = 'deposit';
  static const String transactionTypeWithdraw = 'withdraw';
  static const String transactionTypeTransfer = 'transfer';
  static const String transactionTypePayment = 'payment';
  static const String transactionTypeRefund = 'refund';
  static const String transactionTypeReceive = 'receive';
  static const String transactionTypeFee = 'fee';
  
  // العملات
  static const String currencyYER = 'YER';
  static const String currencySAR = 'SAR';
  static const String currencyUSD = 'USD';
  
  // رموز العملات
  static const String symbolYER = 'ر.ي';
  static const String symbolSAR = 'ر.س';
  static const String symbolUSD = '\$';
  
  // حدود
  static const int maxProductImages = 10;
  static const int maxChatImages = 5;
  static const int productsPerPage = 20;
  static const int messagesPerPage = 50;
  static const int notificationsPerPage = 30;
  
  // أوقات
  static const int splashDuration = 3; // ثواني
  static const int otpTimeout = 60; // ثواني
  static const int sessionTimeout = 30; // دقائق
  static const int cacheExpiry = 7; // أيام
  
  // المفاتيح المشفرة
  static const String hiveBoxUser = 'user_box';
  static const String hiveBoxSettings = 'settings_box';
  static const String hiveBoxFavorites = 'favorites_box';
  static const String hiveBoxCart = 'cart_box';
  static const String hiveBoxSearchHistory = 'search_history_box';
  static const String hiveBoxCache = 'cache_box';
  
  // إعدادات افتراضية
  static const bool defaultDarkMode = false;
  static const String defaultLanguage = 'ar';
  static const bool defaultNotifications = true;
  static const bool defaultBiometric = false;
  
  // رسائل الخطأ
  static const String errorNetwork = 'لا يوجد اتصال بالإنترنت';
  static const String errorServer = 'خطأ في الخادم، يرجى المحاولة لاحقاً';
  static const String errorTimeout = 'انتهت مهلة الاتصال';
  static const String errorUnknown = 'حدث خطأ غير متوقع';
  static const String errorInvalidCredentials = 'بيانات الدخول غير صحيحة';
  static const String errorUserNotFound = 'المستخدم غير موجود';
  static const String errorEmailExists = 'البريد الإلكتروني مستخدم بالفعل';
  static const String errorPhoneExists = 'رقم الهاتف مستخدم بالفعل';
  static const String errorWeakPassword = 'كلمة المرور ضعيفة جداً';
  static const String errorInvalidEmail = 'بريد إلكتروني غير صالح';
  static const String errorInvalidPhone = 'رقم هاتف غير صالح';
  static const String errorRequiredField = 'هذا الحقل مطلوب';
  static const String errorInvalidAmount = 'مبلغ غير صالح';
  static const String errorInsufficientBalance = 'رصيد غير كافٍ';
  
  // رسائل النجاح
  static const String successLogin = 'تم تسجيل الدخول بنجاح';
  static const String successRegister = 'تم إنشاء الحساب بنجاح';
  static const String successLogout = 'تم تسجيل الخروج بنجاح';
  static const String successUpdate = 'تم التحديث بنجاح';
  static const String successDelete = 'تم الحذف بنجاح';
  static const String successAdd = 'تمت الإضافة بنجاح';
  static const String successOrder = 'تم تقديم الطلب بنجاح';
  static const String successPayment = 'تم الدفع بنجاح';
  static const String successTransfer = 'تم التحويل بنجاح';
  static const String successDeposit = 'تم الإيداع بنجاح';
  static const String successWithdraw = 'تم السحب بنجاح';
  
  // نصوص واجهة المستخدم
  static const String welcomeMessage = 'مرحباً بك في فليكس اليمن';
  static const String loginTitle = 'تسجيل الدخول';
  static const String registerTitle = 'إنشاء حساب جديد';
  static const String forgotPasswordTitle = 'نسيت كلمة المرور';
  static const String homeTitle = 'الرئيسية';
  static const String shopTitle = 'المتجر';
  static const String mapTitle = 'الخريطة';
  static const String addTitle = 'إضافة';
  static const String chatTitle = 'الدردشة';
  static const String walletTitle = 'المحفظة';
  static const String profileTitle = 'حسابي';
  
  // خدمات المحفظة
  static const List<Map<String, dynamic>> walletServices = [
    {'id': 'deposit', 'name': 'إيداع', 'icon': Icons.arrow_downward},
    {'id': 'transfer', 'name': 'تحويل', 'icon': Icons.swap_horiz},
    {'id': 'withdraw', 'name': 'سحب', 'icon': Icons.arrow_upward},
    {'id': 'payments', 'name': 'دفع فواتير', 'icon': Icons.receipt},
    {'id': 'entertainment', 'name': 'ترفيه', 'icon': Icons.movie},
    {'id': 'games', 'name': 'ألعاب', 'icon': Icons.games},
    {'id': 'apps', 'name': 'تطبيقات', 'icon': Icons.apps},
    {'id': 'gift_cards', 'name': 'بطاقات', 'icon': Icons.card_giftcard},
    {'id': 'amazon', 'name': 'أمازون', 'icon': Icons.shopping_cart},
    {'id': 'banks', 'name': 'بنوك', 'icon': Icons.account_balance},
    {'id': 'money_transfer', 'name': 'تحويلات', 'icon': Icons.send},
    {'id': 'government', 'name': 'حكومي', 'icon': Icons.account_balance},
    {'id': 'flexi', 'name': 'فلكسي', 'icon': Icons.phone_android},
    {'id': 'cash', 'name': 'سحب نقدي', 'icon': Icons.money},
    {'id': 'universities', 'name': 'جامعات', 'icon': Icons.school},
    {'id': 'recharge_payment', 'name': 'شحن وسداد', 'icon': Icons.payment},
    {'id': 'recharge_credit', 'name': 'شحن رصيد', 'icon': Icons.phone},
    {'id': 'bundles', 'name': 'باقات', 'icon': Icons.data_usage},
    {'id': 'internet', 'name': 'إنترنت', 'icon': Icons.wifi},
    {'id': 'receive_transfer', 'name': 'استلام', 'icon': Icons.call_received},
    {'id': 'transactions', 'name': 'عمليات', 'icon': Icons.history},
    {'id': 'network', 'name': 'شبكة', 'icon': Icons.network_cell},
  ];
}
