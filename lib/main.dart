// ملف التشغيل الرئيسي - Flex Yemen
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'providers/auth_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/product_provider.dart';
import 'providers/wallet_provider.dart';
import 'providers/chat_provider.dart';
import 'providers/order_provider.dart';
import 'providers/notification_provider.dart';
import 'services/supabase_service.dart';
import 'services/local_storage_service.dart';
import 'services/notification_service.dart';
import 'screens/auth/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // تهيئة الخدمات
  await _initializeServices();
  
  // تعيين اتجاه الشاشة
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
  
  // تعيين شريط الحالة
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );
  
  runApp(FlexYemenApp());
}

Future<void> _initializeServices() async {
  try {
    // تهيئة Hive
    await LocalStorageService().initialize();
    
    // تهيئة Supabase
    await SupabaseService().initialize(
      url: 'https://your-project.supabase.co',
      anonKey: 'your-anon-key',
    );
    
    // تهيئة الإشعارات
    await NotificationService().initialize();
  } catch (e) {
    debugPrint('Error initializing services: $e');
  }
}

class FlexYemenApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => ProductProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => WalletProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Flex Yemen',
            debugShowCheckedModeBanner: false,
            
            // الثيمات
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeProvider.themeMode,
            
            // اللغة
            locale: Locale('ar', 'YE'),
            supportedLocales: [
              Locale('ar', 'YE'),
              Locale('en', 'US'),
            ],
            
            // الاتجاه
            builder: (context, child) {
              return Directionality(
                textDirection: TextDirection.rtl,
                child: child!,
              );
            },
            
            // الشاشة الرئيسية
            home: SplashScreen(),
          );
        },
      ),
    );
  }
}

// شاشة خطأ التهيئة
class InitializationErrorScreen extends StatelessWidget {
  final String error;

  InitializationErrorScreen({required this.error});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.error_outline,
                size: 64,
                color: Colors.red,
              ),
              SizedBox(height: 16),
              Text(
                'حدث خطأ في تشغيل التطبيق',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                error,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
