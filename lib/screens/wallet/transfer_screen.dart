// شاشة التحويل
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class TransferScreen extends StatefulWidget {
  @override
  State<TransferScreen> createState() => _TransferScreenState();
}

class _TransferScreenState extends State<TransferScreen> {
  final _formKey = GlobalKey<FormState>();
  final _amountController = TextEditingController();
  final _recipientController = TextEditingController();
  final _noteController = TextEditingController();
  
  String _selectedCurrency = 'YER';

  @override
  void dispose() {
    _amountController.dispose();
    _recipientController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _transfer() async {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إرسال التحويل بنجاح'),
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
        title: 'تحويل',
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
              
              // المستلم
              CustomTextField(
                label: 'رقم الهاتف أو البريد الإلكتروني للمستلم',
                hint: 'أدخل بيانات المستلم',
                controller: _recipientController,
                prefixIcon: Icon(Icons.person_outline),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'هذا الحقل مطلوب';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 24),
              
              // ملاحظة
              CustomTextArea(
                label: 'ملاحظة (اختياري)',
                hint: 'أضف ملاحظة للتحويل',
                controller: _noteController,
              ),
              
              SizedBox(height: 32),
              
              // زر التحويل
              GoldButton(
                text: 'تحويل',
                onPressed: _transfer,
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
            'الرصيد المتاح',
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
}
