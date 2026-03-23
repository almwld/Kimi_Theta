// شاشة إنشاء حساب
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../providers/auth_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';
import 'login_screen.dart';
import '../home/main_navigation.dart';

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  
  String _selectedCity = AppConstants.yemeniCities[0];
  String _userType = AppConstants.userTypeCustomer;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('يجب الموافقة على الشروط والأحكام'),
          backgroundColor: AppTheme.error,
        ),
      );
      return;
    }

    if (_formKey.currentState?.validate() ?? false) {
      final authProvider = context.read<AuthProvider>();
      
      final success = await authProvider.signUp(
        email: _emailController.text.trim(),
        password: _passwordController.text,
        fullName: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        city: _selectedCity,
        userType: _userType,
      );

      if (success && mounted) {
        // الانتقال إلى الشاشة الرئيسية
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => MainNavigation()),
          (route) => false,
        );
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
        title: 'إنشاء حساب',
        showBackButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // العنوان
                Text(
                  'أنشئ حسابك',
                  style: TextStyle(
                    fontFamily: 'Changa',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? Colors.white : AppTheme.lightText,
                  ),
                ).animate()
                 .fadeIn()
                 .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 8),
                
                Text(
                  'أكمل البيانات التالية للتسجيل',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 15,
                    color: isDark ? Colors.white60 : Colors.black54,
                  ),
                ).animate()
                 .fadeIn(delay: 100.ms),
                
                SizedBox(height: 32),
                
                // الاسم الكامل
                CustomTextField(
                  label: 'الاسم الكامل',
                  hint: 'أدخل اسمك الكامل',
                  controller: _nameController,
                  prefixIcon: Icon(Icons.person_outline),
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'هذا الحقل مطلوب';
                    }
                    return null;
                  },
                ).animate()
                 .fadeIn(delay: 200.ms)
                 .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 20),
                
                // البريد الإلكتروني
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
                 .fadeIn(delay: 300.ms)
                 .slideX(begin: 0.2, end: 0),
                
                SizedBox(height: 20),
                
                // رقم الهاتف
                PhoneTextField(
                  controller: _phoneController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'هذا الحقل مطلوب';
                    }
                    if ((value?.length ?? 0) < 9) {
                      return 'رقم هاتف غير صالح';
                    }
                    return null;
                  },
                ).animate()
                 .fadeIn(delay: 400.ms)
                 .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 20),
                
                // المدينة
                _buildCityDropdown().animate()
                 .fadeIn(delay: 500.ms)
                 .slideX(begin: 0.2, end: 0),
                
                SizedBox(height: 20),
                
                // نوع المستخدم
                _buildUserTypeSelector().animate()
                 .fadeIn(delay: 600.ms),
                
                SizedBox(height: 20),
                
                // كلمة المرور
                PasswordTextField(
                  label: 'كلمة المرور',
                  controller: _passwordController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'هذا الحقل مطلوب';
                    }
                    if ((value?.length ?? 0) < 6) {
                      return 'كلمة المرور يجب أن تكون 6 أحرف على الأقل';
                    }
                    return null;
                  },
                ).animate()
                 .fadeIn(delay: 700.ms)
                 .slideX(begin: -0.2, end: 0),
                
                SizedBox(height: 20),
                
                // تأكيد كلمة المرور
                PasswordTextField(
                  label: 'تأكيد كلمة المرور',
                  hint: 'أعد إدخال كلمة المرور',
                  controller: _confirmPasswordController,
                  validator: (value) {
                    if (value?.isEmpty ?? true) {
                      return 'هذا الحقل مطلوب';
                    }
                    if (value != _passwordController.text) {
                      return 'كلمتا المرور غير متطابقتين';
                    }
                    return null;
                  },
                ).animate()
                 .fadeIn(delay: 800.ms)
                 .slideX(begin: 0.2, end: 0),
                
                SizedBox(height: 24),
                
                // الموافقة على الشروط
                Row(
                  children: [
                    Checkbox(
                      value: _agreeToTerms,
                      onChanged: (value) {
                        setState(() {
                          _agreeToTerms = value ?? false;
                        });
                      },
                      activeColor: AppTheme.goldPrimary,
                    ),
                    Expanded(
                      child: Wrap(
                        children: [
                          Text(
                            'أوافق على ',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: عرض الشروط
                            },
                            child: Text(
                              'الشروط والأحكام',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.goldPrimary,
                              ),
                            ),
                          ),
                          Text(
                            ' و',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 13,
                              color: isDark ? Colors.white70 : Colors.black54,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // TODO: عرض سياسة الخصوصية
                            },
                            child: Text(
                              'سياسة الخصوصية',
                              style: TextStyle(
                                fontFamily: 'Tajawal',
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                color: AppTheme.goldPrimary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ).animate()
                 .fadeIn(delay: 900.ms),
                
                SizedBox(height: 32),
                
                // زر إنشاء الحساب
                GoldButton(
                  text: 'إنشاء حساب',
                  onPressed: _register,
                  isLoading: authProvider.isLoading,
                ).animate()
                 .fadeIn(delay: 1000.ms)
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
                
                // تسجيل الدخول
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'لديك حساب بالفعل؟',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 15,
                        color: isDark ? Colors.white60 : Colors.black54,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text(
                        'تسجيل الدخول',
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

  Widget _buildCityDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'المدينة',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppTheme.lightText,
          ),
        ),
        SizedBox(height: 8),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: isDark ? AppTheme.darkCard : AppTheme.lightCard,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isDark ? Colors.grey.shade800 : Colors.grey.shade300,
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: _selectedCity,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppTheme.goldPrimary),
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 15,
                color: isDark ? Colors.white : AppTheme.lightText,
              ),
              dropdownColor: isDark ? AppTheme.darkSurface : Colors.white,
              items: AppConstants.yemeniCities.map((city) {
                return DropdownMenuItem(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCity = value!;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUserTypeSelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'نوع الحساب',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isDark ? Colors.white : AppTheme.lightText,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildTypeOption(
                title: 'عميل',
                subtitle: 'أبحث عن منتجات',
                icon: Icons.shopping_bag_outlined,
                isSelected: _userType == AppConstants.userTypeCustomer,
                onTap: () {
                  setState(() {
                    _userType = AppConstants.userTypeCustomer;
                  });
                },
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: _buildTypeOption(
                title: 'تاجر',
                subtitle: 'أعرض منتجاتي',
                icon: Icons.store_outlined,
                isSelected: _userType == AppConstants.userTypeSeller,
                onTap: () {
                  setState(() {
                    _userType = AppConstants.userTypeSeller;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTypeOption({
    required String title,
    required String subtitle,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: isSelected ? AppTheme.goldGradient : null,
          color: isSelected ? null : (isDark ? AppTheme.darkCard : AppTheme.lightCard),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppTheme.goldPrimary : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppTheme.goldPrimary,
              size: 28,
            ),
            SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Changa',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: isSelected ? Colors.white : (isDark ? Colors.white : AppTheme.lightText),
              ),
            ),
            SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                color: isSelected ? Colors.white70 : (isDark ? Colors.white60 : Colors.black54),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
