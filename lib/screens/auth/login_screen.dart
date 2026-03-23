// شاشة تسجيل الدخول
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import 'register_screen.dart';
import 'forgot_password_screen.dart';
import '../home/main_navigation.dart';

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.signIn(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (success && mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainNavigation()),
        );
      }
    }
  }

  void _loginAsGuest() {
    context.read<AuthProvider>().signInAsGuest();
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainNavigation()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: 40),
                
                // الشعار
                Center(
                  child: Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      gradient: AppTheme.goldGradient,
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: AppTheme.goldShadow,
                    ),
                    child: Center(
                      child: Text(
                        'F',
                        style: TextStyle(
                          fontFamily: 'Changa',
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ).animate()
                 .scale(duration: 600.ms, curve: Curves.elasticOut)
                 .fadeIn(),
                
                SizedBox(height: 32),
                
                // عنوان الترحيب
                Text(
                  'مرحباً بعودتك!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Changa',
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.lightText,
                  ),
                ).animate()
                 .fadeIn(delay: 200.ms)
                 .slideY(begin: 0.2, end: 0),
                
                SizedBox(height: 8),
                
                Text(
                  'سجل دخولك للمتابعة',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 16,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ).animate()
                 .fadeIn(delay: 300.ms)
                 .slideY(begin: 0.2, end: 0),
                
                SizedBox(height: 40),
                
                // حقل البريد الإلكتروني
                CustomTextField(
                  label: 'البريد الإلكتروني أو رقم الهاتف',
                  hint: 'أدخل بريدك الإلكتروني',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  prefixIcon: Icon(Icons.email_outlined),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                ).animate()
                 .fadeIn(delay: 400.ms)
                 .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 20),
                
                // حقل كلمة المرور
                PasswordTextField(
                  label: 'كلمة المرور',
                  controller: _passwordController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'هذا الحقل مطلوب';
                    }
                    if ((value?.length ?? 0) < 6) {
                      return 'كلمة المرور قصيرة جداً';
                    }
                    return null;
                  },
                ).animate()
                 .fadeIn(delay: 500.ms)
                 .slideX(begin: 0.2, end: 0),
                
                SizedBox(height: 16),
                
                // تذكرني ونسيت كلمة المرور
                Row(
                  children: [
                    // تذكرني
                    Row(
                      children: [
                        Checkbox(
                          value: _rememberMe,
                          onChanged: (value) {
                            setState(() {
                              _rememberMe = value ?? false;
                            });
                          },
                          activeColor: AppTheme.goldPrimary,
                        ),
                        Text(
                          'تذكرني',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 14,
                            color: isDark ? Colors.white70 : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                    
                    Spacer(),
                    
                    // نسيت كلمة المرور
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ForgotPasswordScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'نسيت كلمة المرور؟',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    ),
                  ],
                ).animate()
                 .fadeIn(delay: 600.ms),
                
                SizedBox(height: 24),
                
                // زر تسجيل الدخول
                GoldButton(
                  text: 'تسجيل الدخول',
                  onPressed: _login,
                  isLoading: authProvider.isLoading,
                ).animate()
                 .fadeIn(delay: 700.ms)
                 .slideY(begin: 0.2, end: 0),
                
                if (authProvider.error != null) ...[
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppTheme.error.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.error_outline,
                          color: AppTheme.error,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            authProvider.error!,
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                              color: AppTheme.error,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
                
                SizedBox(height: 24),
                
                // أو
                Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        'أو',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 14,
                          color: isDark ? Colors.white.withOpacity(0.4) : Colors.black.withOpacity(0.38),
                        ),
                      ),
                    ),
                    Expanded(child: Divider()),
                  ],
                ).animate()
                 .fadeIn(delay: 800.ms),
                
                SizedBox(height: 24),
                
                // زر Google
                SecondaryButton(
                  text: 'الدخول باستخدام Google',
                  icon: Icons.g_mobiledata,
                  onPressed: () {
                    // TODO: تسجيل الدخول بـ Google
                  },
                ).animate()
                 .fadeIn(delay: 900.ms)
                 .slideY(begin: 0.2, end: 0),
                
                SizedBox(height: 16),
                
                // الدخول كضيف
                TextButton(
                  onPressed: _loginAsGuest,
                  child: Text(
                    'الدخول كضيف',
                    style: TextStyle(
                      fontFamily: 'Tajawal',
                      fontSize: 15,
                      color: isDark ? Colors.white60 : Colors.black54,
                    ),
                  ),
                ).animate()
                 .fadeIn(delay: 1000.ms),
                
                SizedBox(height: 32),
                
                // إنشاء حساب
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'ليس لديك حساب؟',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 15,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => RegisterScreen(),
                          ),
                        );
                      },
                      child: Text(
                        'إنشاء حساب',
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: AppTheme.goldPrimary,
                        ),
                      ),
                    ),
                  ],
                ).animate()
                 .fadeIn(delay: 1100.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
