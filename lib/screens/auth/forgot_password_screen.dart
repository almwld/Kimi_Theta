// شاشة نسيت كلمة المرور
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class ForgotPasswordScreen extends StatefulWidget {
  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _sendResetLink() async {
    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.resetPassword(
        _emailController.text.trim(),
      );

      if (success && mounted) {
        setState(() {
          _emailSent = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authProvider = context.watch<AuthProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: CustomAppBar(
        title: 'نسيت كلمة المرور',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: _emailSent
              ? _buildSuccessView()
              : _buildFormView(authProvider),
        ),
      ),
    );
  }

  Widget _buildFormView(AuthProvider authProvider) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(height: 40),
          
          // الأيقونة
          Center(
            child: Container(
              width: 100,
              height: 100,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppTheme.goldPrimary.withOpacity(0.2),
                    AppTheme.goldLight.withOpacity(0.1),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.lock_reset,
                size: 50,
                color: AppTheme.goldPrimary,
              ),
            ),
          ).animate()
           .scale(duration: 600.ms, curve: Curves.elasticOut)
           .fadeIn(),
          
          SizedBox(height: 32),
          
          // العنوان
          Text(
            'استعادة كلمة المرور',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Changa',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: isDark ? Colors.white : AppTheme.lightText,
            ),
          ).animate()
           .fadeIn(delay: 200.ms)
           .slideY(begin: 0.2, end: 0),
          
          SizedBox(height: 12),
          
          Text(
            'أدخل بريدك الإلكتروني وسنرسل لك رابطاً لإعادة تعيين كلمة المرور',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 15,
              color: isDark ? Colors.white60 : Colors.black54,
            ),
          ).animate()
           .fadeIn(delay: 300.ms)
           .slideY(begin: 0.2, end: 0),
          
          SizedBox(height: 40),
          
          // حقل البريد الإلكتروني
          CustomTextField(
            label: 'البريد الإلكتروني',
            hint: 'example@email.com',
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            prefixIcon: Icon(Icons.email_outlined),
            validator: (value) {
              if (value?.isEmpty ?? true) {
                return 'هذا الحقل مطلوب';
              }
              if (!value!.contains('@')) {
                return 'بريد إلكتروني غير صالح';
              }
              return null;
            },
          ).animate()
           .fadeIn(delay: 400.ms)
           .slideX(begin: -0.2, end: 0),
          
          SizedBox(height: 32),
          
          // زر الإرسال
          GoldButton(
            text: 'إرسال الرابط',
            onPressed: _sendResetLink,
            isLoading: authProvider.isLoading,
          ).animate()
           .fadeIn(delay: 500.ms)
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
        ],
      ),
    );
  }

  Widget _buildSuccessView() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(height: 60),
        
        // أيقونة النجاح
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.green.withOpacity(0.2),
                  Colors.green.withOpacity(0.1),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.check_circle,
              size: 60,
              color: Colors.green,
            ),
          ),
        ).animate()
         .scale(duration: 600.ms, curve: Curves.elasticOut)
         .fadeIn(),
        
        SizedBox(height: 32),
        
        // عنوان النجاح
        Text(
          'تم إرسال الرابط!',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Changa',
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.lightText,
          ),
        ).animate()
         .fadeIn(delay: 200.ms)
         .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 16),
        
        Text(
          'يرجى التحقق من بريدك الإلكتروني واتباع الرابط لإعادة تعيين كلمة المرور',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 15,
            color: isDark ? Colors.white60 : Colors.black54,
          ),
        ).animate()
         .fadeIn(delay: 300.ms)
         .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 40),
        
        // زر العودة
        GoldButton(
          text: 'العودة لتسجيل الدخول',
          onPressed: () {
            Navigator.pop(context);
          },
        ).animate()
         .fadeIn(delay: 400.ms)
         .slideY(begin: 0.2, end: 0),
        
        SizedBox(height: 16),
        
        // إعادة الإرسال
        TextButton(
          onPressed: () {
            setState(() {
              _emailSent = false;
            });
          },
          child: Text(
            'لم تستلم الرابط؟ إعادة الإرسال',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              color: AppTheme.goldPrimary,
            ),
          ),
        ).animate()
         .fadeIn(delay: 500.ms),
      ],
    );
  }
}
