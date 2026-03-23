// شاشة إضافة منتج
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:dotted_border/dotted_border.dart';
import '../../theme/app_theme.dart';
import '../../core/constants/app_constants.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class AddProductScreen extends StatefulWidget {
  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  final _oldPriceController = TextEditingController();
  
  String _selectedCategory = AppConstants.categories[0]['id'];
  String _selectedCity = AppConstants.yemeniCities[0];
  String _condition = 'new';
  bool _hasWarranty = false;
  bool _hasShipping = false;
  bool _isNegotiable = false;
  bool _isAuction = false;
  bool _isFeatured = false;
  
  List<String> _selectedImages = [];

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _oldPriceController.dispose();
    super.dispose();
  }

  Future<void> _pickImages() async {
    // TODO: اختيار الصور من المعرض
  }

  Future<void> _submitProduct() async {
    if (_formKey.currentState?.validate() ?? false) {
      // TODO: إرسال المنتج
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('تم إضافة المنتج بنجاح'),
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
        title: 'إضافة منتج',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // صور المنتج
              _buildImagePicker(),
              
              SizedBox(height: 24),
              
              // معلومات المنتج
              _buildSectionTitle('معلومات المنتج'),
              SizedBox(height: 16),
              
              CustomTextField(
                label: 'عنوان المنتج',
                hint: 'أدخل عنوان المنتج',
                controller: _titleController,
                prefixIcon: Icon(Icons.title),
                validator: (value) {
                  if (value?.isEmpty ?? true) {
                    return 'هذا الحقل مطلوب';
                  }
                  return null;
                },
              ),
              
              SizedBox(height: 16),
              
              CustomTextArea(
                label: 'الوصف',
                hint: 'أدخل وصفاً تفصيلياً للمنتج',
                controller: _descriptionController,
                maxLines: 5,
              ),
              
              SizedBox(height: 24),
              
              // السعر
              _buildSectionTitle('السعر'),
              SizedBox(height: 16),
              
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      label: 'السعر الحالي',
                      hint: '0.00',
                      controller: _priceController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(Icons.attach_money),
                      validator: (value) {
                        if (value?.isEmpty ?? true) {
                          return 'هذا الحقل مطلوب';
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: CustomTextField(
                      label: 'السعر قبل الخصم (اختياري)',
                      hint: '0.00',
                      controller: _oldPriceController,
                      keyboardType: TextInputType.number,
                      prefixIcon: Icon(Icons.money_off),
                    ),
                  ),
                ],
              ),
              
              SizedBox(height: 24),
              
              // الفئة والمدينة
              _buildSectionTitle('التصنيف والموقع'),
              SizedBox(height: 16),
              
              _buildCategoryDropdown(),
              
              SizedBox(height: 16),
              
              _buildCityDropdown(),
              
              SizedBox(height: 24),
              
              // حالة المنتج
              _buildSectionTitle('حالة المنتج'),
              SizedBox(height: 16),
              
              _buildConditionSelector(),
              
              SizedBox(height: 24),
              
              // الخيارات الإضافية
              _buildSectionTitle('خيارات إضافية'),
              SizedBox(height: 16),
              
              _buildSwitchOption(
                title: 'يوجد ضمان',
                subtitle: 'المنتج يتضمن ضمان',
                value: _hasWarranty,
                onChanged: (value) {
                  setState(() {
                    _hasWarranty = value;
                  });
                },
              ),
              
              _buildSwitchOption(
                title: 'توصيل متاح',
                subtitle: 'يوجد خدمة توصيل للمنتج',
                value: _hasShipping,
                onChanged: (value) {
                  setState(() {
                    _hasShipping = value;
                  });
                },
              ),
              
              _buildSwitchOption(
                title: 'قابل للتفاوض',
                subtitle: 'السعر قابل للتفاوض',
                value: _isNegotiable,
                onChanged: (value) {
                  setState(() {
                    _isNegotiable = value;
                  });
                },
              ),
              
              _buildSwitchOption(
                title: 'مزاد',
                subtitle: 'عرض المنتج في المزاد',
                value: _isAuction,
                onChanged: (value) {
                  setState(() {
                    _isAuction = value;
                  });
                },
              ),
              
              _buildSwitchOption(
                title: 'منتج مميز',
                subtitle: 'عرض المنتج في الصفحة الرئيسية',
                value: _isFeatured,
                onChanged: (value) {
                  setState(() {
                    _isFeatured = value;
                  });
                },
              ),
              
              SizedBox(height: 32),
              
              // زر النشر
              GoldButton(
                text: 'نشر المنتج',
                onPressed: _submitProduct,
              ),
              
              SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 20,
          decoration: BoxDecoration(
            gradient: AppTheme.goldGradient,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'Changa',
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).brightness == Brightness.dark
                ? Colors.white
                : AppTheme.lightText,
          ),
        ),
      ],
    );
  }

  Widget _buildImagePicker() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionTitle('صور المنتج'),
        SizedBox(height: 12),
        Text(
          'أضف حتى 10 صور للمنتج',
          style: TextStyle(
            fontFamily: 'Tajawal',
            fontSize: 13,
            color: isDark ? Colors.white54 : Colors.black54,
          ),
        ),
        SizedBox(height: 12),
        Container(
          height: 120,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _selectedImages.length + 1,
            itemBuilder: (context, index) {
              if (index == _selectedImages.length) {
                return GestureDetector(
                  onTap: _pickImages,
                  child: DottedBorder(
                    borderType: BorderType.RRect,
                    radius: Radius.circular(12),
                    color: AppTheme.goldPrimary,
                    strokeWidth: 2,
                    dashPattern: [8, 4],
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: AppTheme.goldPrimary.withOpacity(0.05),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.add_photo_alternate_outlined,
                            color: AppTheme.goldPrimary,
                            size: 32,
                          ),
                          SizedBox(height: 8),
                          Text(
                            'إضافة صورة',
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 12,
                              color: AppTheme.goldPrimary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
              
              return Container(
                width: 100,
                height: 100,
                margin: EdgeInsets.only(right: 8),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: NetworkImage(_selectedImages[index]),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Align(
                  alignment: Alignment.topLeft,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImages.removeAt(index);
                      });
                    },
                    child: Container(
                      margin: EdgeInsets.all(4),
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryDropdown() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'الفئة',
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
              value: _selectedCategory,
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down, color: AppTheme.goldPrimary),
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 15,
                color: isDark ? Colors.white : AppTheme.lightText,
              ),
              dropdownColor: isDark ? AppTheme.darkSurface : Colors.white,
              items: AppConstants.categories.map((category) {
                return DropdownMenuItem(
                  value: category['id'],
                  child: Text(category['name']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCategory = value!;
                });
              },
            ),
          ),
        ),
      ],
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

  Widget _buildConditionSelector() {
    return Row(
      children: [
        Expanded(
          child: _buildConditionOption(
            title: 'جديد',
            icon: Icons.new_releases,
            isSelected: _condition == 'new',
            onTap: () {
              setState(() {
                _condition = 'new';
              });
            },
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildConditionOption(
            title: 'مستعمل',
            icon: Icons.recycling,
            isSelected: _condition == 'used',
            onTap: () {
              setState(() {
                _condition = 'used';
              });
            },
          ),
        ),
      ],
    );
  }

  Widget _buildConditionOption({
    required String title,
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : AppTheme.goldPrimary,
            ),
            SizedBox(width: 8),
            Text(
              title,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : (isDark ? Colors.white : AppTheme.lightText),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchOption({
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppTheme.lightText,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  subtitle,
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppTheme.goldPrimary,
          ),
        ],
      ),
    );
  }
}
