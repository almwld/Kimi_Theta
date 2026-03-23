// شاشة الإيداع
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class DepositScreen extends StatefulWidget {
  @override
  State<DepositScreen> createState() => _DepositScreenState();
}

class _DepositScreenState extends State<DepositScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  
  String _selectedMethod = 'bank';
  String _selectedCurrency = 'YER';

  final List<Map<String, dynamic>> _paymentMethods = [
    {'id': 'bank', 'name': 'تحويل بنكي', 'icon': Icons.account_balance},
    {'id': 'card', 'name': 'بطاقة ائتمان', 'icon': Icons.credit_card},
    {'id': 'agent', 'name': 'وكيل', 'icon': Icons.store},
    {'id': 'crypto', 'name': 'عملات رقمية', 'icon': Icons.currency_bitcoin},
  ];

  @override
  void dispose() {
    _amountController.dispose();
    super.dispose();
  }

  Future<void> _deposit() async {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: تنفيذ الإيداع
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال طلب الإيداع بنجاح'),
          backgroundColor: AppTheme.success,
        ),
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: CustomAppBar(
        title: 'إيداع',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // بطاقة الرصيد
              _buildBalanceCard(),
              
              SizedBox(height: 24),
              
              // اختيار العملة
              _buildCurrencySelector(),
              
              SizedBox(height: 24),
              
              // المبلغ
              AmountTextField(
                controller: _amountController,
                currency: _selectedCurrency,
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'أدخل المبلغ';
                  }
                  final amount = double.tryParse(value!);
                  if (amount == null || amount <= 0) {
                    return 'مبلغ غير صالح';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 24),
              
              // طريقة الدفع
              _buildPaymentMethods(),
              
              SizedBox(height: 32),
              
              // زر الإيداع
              GoldButton(
                text: 'إيداع',
                onPressed: _deposit,
              ),
              
              SizedBox(height: 24),
              
              // معلومات إضافية
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          color: AppTheme.goldPrimary,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'معلومات مهمة',
                          style: TextStyle(
                            fontFamily: 'Changa',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark ? Colors.white : AppTheme.lightText,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 12),
                    Text(
                      '• سيتم معالجة طلب الإيداع خلال 24 ساعة\n'
                      '• قد تطبق رسوم على بعض طرق الدفع\n'
                      '• تأكد من صحة البيانات قبل التأكيد',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        color: isDark ? Colors.white70 : Colors.black54,
                        height: 1.8,
                      ),
                    ),
                  ],
                ),
              ),
              
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBalanceCard() {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: AppTheme.goldGradient,
        borderRadius: BorderRadius.circular(20),
        boxShadow: AppTheme.goldShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'الرصيد الحالي',
            style: TextStyle(
              fontFamily: 'Tajawal',
              fontSize: 14,
              color: Colors.white.withOpacity(0.8),
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Text(
                '150,000',
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Text(
                'ر.ي',
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 18,
                  color: Colors.white.withOpacity(0.8),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
     .fadeIn(duration: 500.ms)
     .slideY(begin: -0.2, end: 0);
  }

  Widget _buildCurrencySelector() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'اختر العملة',
          style: TextStyle(
            fontFamily: 'Changa',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.lightText,
          ),
        ),
        SizedBox(height: 12),
        Row(
          children: [
            _buildCurrencyOption('YER', 'ريال يمني'),
            SizedBox(width: 8),
            _buildCurrencyOption('SAR', 'ريال سعودي'),
            SizedBox(width: 8),
            _buildCurrencyOption('USD', 'دولار'),
          ],
        ),
      ],
    );
  }

  Widget _buildCurrencyOption(String code, String name) {
    final isSelected = _selectedCurrency == code;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _selectedCurrency = code;
          });
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            gradient: isSelected ? AppTheme.goldGradient : null,
            color: isSelected ? null : (isDark ? AppTheme.darkSurface : Colors.white),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected ? AppTheme.goldPrimary : (isDark ? Colors.grey.shade800 : Colors.grey.shade300),
            ),
          ),
          child: Column(
            children: [
              Text(
                code,
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : (isDark ? Colors.white : AppTheme.lightText),
                ),
              ),
              SizedBox(height: 4),
              Text(
                name,
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 11,
                  color: isSelected ? Colors.white70 : (isDark ? Colors.white60 : Colors.black54),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentMethods() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'طريقة الدفع',
          style: TextStyle(
            fontFamily: 'Changa',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.white : AppTheme.lightText,
          ),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: _paymentMethods.length,
          itemBuilder: (context, index) {
            final method = _paymentMethods[index];
            final isSelected = _selectedMethod == method['id'];

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedMethod = method['id'];
                });
              },
              child: Container(
                margin: EdgeInsets.only(bottom: 8),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isDark ? AppTheme.darkSurface : Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected ? AppTheme.goldPrimary : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: isSelected
                            ? AppTheme.goldPrimary.withOpacity(0.1)
                            : (isDark ? AppTheme.darkCard : Colors.grey.shade100),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        method['icon'] as IconData,
                        color: isSelected ? AppTheme.goldPrimary : Colors.grey,
                      ),
                    ),
                    SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        method['name'],
                        style: TextStyle(
                          fontFamily: 'Tajawal',
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isDark ? Colors.white : AppTheme.lightText,
                        ),
                      ),
                    ),
                    if (isSelected)
                      Icon(
                        Icons.check_circle,
                        color: AppTheme.goldPrimary,
                      ),
                  ],
                ),
              ),
            ).animate()
             .fadeIn(delay: (index * 100).ms)
             .slideX(begin: 0.2, end: 0);
          },
        ),
      ],
    );
  }
}
