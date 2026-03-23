// ملف المسارات
import 'package:flutter/material.dart';
import '../screens/auth/splash_screen.dart';
import '../screens/auth/login_screen.dart';
import '../screens/auth/register_screen.dart';
import '../screens/auth/forgot_password_screen.dart';
import '../screens/home/main_navigation.dart';
import '../screens/home/home_screen.dart';
import '../screens/product/products_screen.dart';
import '../screens/product/product_detail_screen.dart';
import '../screens/product/add_product_screen.dart';
import '../screens/product/favorites_screen.dart';
import '../screens/wallet/wallet_screen.dart';
import '../screens/wallet/deposit_screen.dart';
import '../screens/wallet/transfer_screen.dart';
import '../screens/wallet/withdraw_screen.dart';
import '../screens/wallet/transactions_screen.dart';
import '../screens/chat/chat_screen.dart';
import '../screens/chat/chat_detail_screen.dart';
import '../screens/profile/profile_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../screens/order/my_orders_screen.dart';
import '../screens/search/search_screen.dart';

class AppRoutes {
  // المسارات الرئيسية
  static const String splash = '/';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String main = '/main';
  static const String home = '/home';
  
  // المنتجات
  static const String products = '/products';
  static const String productDetail = '/product-detail';
  static const String addProduct = '/add-product';
  static const String favorites = '/favorites';
  
  // المحفظة
  static const String wallet = '/wallet';
  static const String deposit = '/deposit';
  static const String transfer = '/transfer';
  static const String withdraw = '/withdraw';
  static const String transactions = '/transactions';
  
  // المحادثات
  static const String chat = '/chat';
  static const String chatDetail = '/chat-detail';
  
  // الملف الشخصي والإعدادات
  static const String profile = '/profile';
  static const String settings = '/settings';
  static const String notifications = '/notifications';
  
  // الطلبات
  static const String myOrders = '/my-orders';
  
  // البحث
  static const String search = '/search';

  // خريطة المسارات
  static Map<String, WidgetBuilder> get routes => {
    splash: (context) => SplashScreen(),
    login: (context) => LoginScreen(),
    register: (context) => RegisterScreen(),
    forgotPassword: (context) => ForgotPasswordScreen(),
    main: (context) => MainNavigation(),
    home: (context) => HomeScreen(),
    products: (context) => ProductsScreen(),
    addProduct: (context) => AddProductScreen(),
    favorites: (context) => FavoritesScreen(),
    wallet: (context) => WalletScreen(),
    deposit: (context) => DepositScreen(),
    transfer: (context) => TransferScreen(),
    withdraw: (context) => WithdrawScreen(),
    transactions: (context) => TransactionsScreen(),
    chat: (context) => ChatScreen(),
    profile: (context) => ProfileScreen(),
    settings: (context) => SettingsScreen(),
    notifications: (context) => NotificationsScreen(),
    myOrders: (context) => MyOrdersScreen(),
    search: (context) => SearchScreen(),
  };

  // التنقل إلى مسار
  static void navigateTo(BuildContext context, String route, {Object? arguments}) {
    Navigator.pushNamed(context, route, arguments: arguments);
  }

  // التنقل واستبدال المسار
  static void navigateAndReplace(BuildContext context, String route, {Object? arguments}) {
    Navigator.pushReplacementNamed(context, route, arguments: arguments);
  }

  // التنظيف والذهاب إلى مسار
  static void navigateAndClear(BuildContext context, String route, {Object? arguments}) {
    Navigator.pushNamedAndRemoveUntil(
      context,
      route,
      (route) => false,
      arguments: arguments,
    );
  }

  // العودة
  static void goBack(BuildContext context) {
    Navigator.pop(context);
  }
}
