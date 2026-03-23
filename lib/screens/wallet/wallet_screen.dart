// شاشة المحفظة الرئيسية
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import '../../theme/app_theme.dart';
import '../../providers/wallet_provider.dart';
import '../../widgets/common/custom_app_bar.dart';
import '../../widgets/common/loading_widget.dart';
import 'deposit_screen.dart';
import 'transfer_screen.dart';
import 'withdraw_screen.dart';
import 'transactions_screen.dart';

class WalletScreen extends StatefulWidget {
  @override
  State<WalletScreen> createState() => _WalletScreenState();
}

class _WalletScreenState extends State<WalletScreen> {
  int _currentCardIndex = 0;

  final List<Map<String, dynamic>> _currencies = [
    {'code': 'YER', 'name': 'ريال يمني', 'balance': 150000, 'symbol': 'ر.ي'},
    {'code': 'SAR', 'name': 'ريال سعودي', 'balance': 5000, 'symbol': 'ر.س'},
    {'code': 'USD', 'name': 'دولار أمريكي', 'balance': 1000, 'symbol': '\$'},
  ];

  final List<Map<String, dynamic>> _services = [
    {'icon': Icons.arrow_downward, 'name': 'إيداع', 'color': Colors.green, 'screen': 'deposit'},
    {'icon': Icons.swap_horiz, 'name': 'تحويل', 'color': Colors.blue, 'screen': 'transfer'},
    {'icon': Icons.arrow_upward, 'name': 'سحب', 'color': Colors.orange, 'screen': 'withdraw'},
    {'icon': Icons.receipt, 'name': 'فواتير', 'color': Colors.purple, 'screen': 'payments'},
    {'icon': Icons.movie, 'name': 'ترفيه', 'color': Colors.pink, 'screen': 'entertainment'},
    {'icon': Icons.games, 'name': 'ألعاب', 'color': Colors.red, 'screen': 'games'},
    {'icon': Icons.apps, 'name': 'تطبيقات', 'color': Colors.teal, 'screen': 'apps'},
    {'icon': Icons.card_giftcard, 'name': 'بطاقات', 'color': Colors.amber, 'screen': 'gift_cards'},
    {'icon': Icons.shopping_cart, 'name': 'أمازون', 'color': Colors.orange, 'screen': 'amazon'},
    {'icon': Icons.account_balance, 'name': 'بنوك', 'color': Colors.indigo, 'screen': 'banks'},
    {'icon': Icons.send, 'name': 'تحويلات', 'color': Colors.cyan, 'screen': 'money_transfer'},
    {'icon': Icons.gavel, 'name': 'حكومي', 'color': Colors.brown, 'screen': 'government'},
    {'icon': Icons.phone_android, 'name': 'فلكسي', 'color': Colors.green, 'screen': 'flexi'},
    {'icon': Icons.money, 'name': 'نقدي', 'color': Colors.blueGrey, 'screen': 'cash'},
    {'icon': Icons.school, 'name': 'جامعات', 'color': Colors.deepPurple, 'screen': 'universities'},
    {'icon': Icons.payment, 'name': 'شحن', 'color': Colors.lightBlue, 'screen': 'recharge_payment'},
    {'icon': Icons.phone, 'name': 'رصيد', 'color': Colors.lime, 'screen': 'recharge_credit'},
    {'icon': Icons.data_usage, 'name': 'باقات', 'color': Colors.deepOrange, 'screen': 'bundles'},
    {'icon': Icons.wifi, 'name': 'نت', 'color': Colors.lightGreen, 'screen': 'internet'},
    {'icon': Icons.call_received, 'name': 'استلام', 'color': Colors.green, 'screen': 'receive_transfer'},
    {'icon': Icons.history, 'name': 'عمليات', 'color': Colors.grey, 'screen': 'transactions'},
    {'icon': Icons.network_cell, 'name': 'شبكة', 'color': Colors.blue, 'screen': 'network'},
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final walletProvider = context.watch<WalletProvider>();

    return Scaffold(
      backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
      appBar: CustomAppBar(
        title: 'المحفظة',
        showNotification: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            
            // بطاقات الرصيد
            _buildBalanceCards(),
            
            SizedBox(height: 24),
            
            // الأزرار السريعة
            _buildQuickActions(),
            
            SizedBox(height: 24),
            
            // خدمات المحفظة
            _buildServicesGrid(),
            
            SizedBox(height: 24),
            
            // آخر المعاملات
            _buildRecentTransactions(),
            
            SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceCards() {
    return Column(
      children: [
        Container(
          height: 200,
          child: PageView.builder(
            itemCount: _currencies.length,
            onPageChanged: (index) {
              setState(() {
                _currentCardIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final currency = _currencies[index];
              return Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  gradient: AppTheme.cardGradient,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: AppTheme.goldShadow,
                ),
                child: Stack(
                  children: [
                    // الدوائر الزخرفية
                    Positioned(
                      right: -50,
                      top: -50,
                      child: Container(
                        width: 200,
                        height: 200,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    Positioned(
                      left: -30,
                      bottom: -30,
                      child: Container(
                        width: 150,
                        height: 150,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    
                    // المحتوى
                    Padding(
                      padding: EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'الرصيد ${currency['name']}',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 16,
                                  color: Colors.white.withOpacity(0.8),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  currency['code'],
                                  style: TextStyle(
                                    fontFamily: 'Changa',
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Spacer(),
                          Text(
                            '${currency['balance'].toStringAsFixed(0)}',
                            style: TextStyle(
                              fontFamily: 'Changa',
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            currency['symbol'],
                            style: TextStyle(
                              fontFamily: 'Tajawal',
                              fontSize: 18,
                              color: Colors.white.withOpacity(0.8),
                            ),
                          ),
                          Spacer(),
                          Row(
                            children: [
                              Icon(
                                Icons.visibility_off,
                                color: Colors.white.withOpacity(0.6),
                                size: 18,
                              ),
                              SizedBox(width: 8),
                              Text(
                                'إخفاء الرصيد',
                                style: TextStyle(
                                  fontFamily: 'Tajawal',
                                  fontSize: 12,
                                  color: Colors.white.withOpacity(0.6),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ).animate()
               .fadeIn(duration: 500.ms)
               .slideX(begin: 0.2, end: 0);
            },
          ),
        ),
        SizedBox(height: 16),
        // مؤشرات البطاقات
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: _currencies.asMap().entries.map((entry) {
            return Container(
              width: _currentCardIndex == entry.key ? 24 : 8,
              height: 8,
              margin: EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                gradient: _currentCardIndex == entry.key
                    ? AppTheme.goldGradient
                    : null,
                color: _currentCardIndex == entry.key
                    ? null
                    : Colors.grey.shade400,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildQuickActions() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildActionButton(
              icon: Icons.arrow_downward,
              label: 'إيداع',
              color: Colors.green,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => DepositScreen()),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.swap_horiz,
              label: 'تحويل',
              color: Colors.blue,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TransferScreen()),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.arrow_upward,
              label: 'سحب',
              color: Colors.orange,
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => WithdrawScreen()),
              ),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildActionButton(
              icon: Icons.receipt,
              label: 'فواتير',
              color: Colors.purple,
              onTap: () {},
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: color.withOpacity(0.3),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: color,
              size: 28,
            ),
            SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServicesGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'الخدمات',
            style: TextStyle(
              fontFamily: 'Changa',
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Theme.of(context).brightness == Brightness.dark
                  ? Colors.white
                  : AppTheme.lightText,
            ),
          ),
        ),
        SizedBox(height: 16),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              crossAxisSpacing: 8,
              mainAxisSpacing: 12,
            ),
            itemCount: _services.length,
            itemBuilder: (context, index) {
              final service = _services[index];
              return GestureDetector(
                onTap: () {
                  _navigateToService(service['screen'] as String);
                },
                child: Column(
                  children: [
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: (service['color'] as Color).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        service['icon'] as IconData,
                        color: service['color'] as Color,
                        size: 28,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      service['name'] as String,
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 11,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white70
                            : Colors.black54,
                      ),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ).animate()
               .fadeIn(delay: (index * 30).ms)
               .scale(begin: Offset(0.9, 0.9), end: Offset(1, 1));
            },
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'آخر المعاملات',
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: isDark ? Colors.white : AppTheme.lightText,
                ),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => TransactionsScreen(),
                  ),
                ),
                child: Row(
                  children: [
                    Text(
                      'الكل',
                      style: TextStyle(
                        fontFamily: 'Tajawal',
                        fontSize: 13,
                        color: AppTheme.goldPrimary,
                      ),
                    ),
                    Icon(
                      Icons.arrow_back_ios,
                      size: 12,
                      color: AppTheme.goldPrimary,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(height: 12),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 5,
          itemBuilder: (context, index) {
            final isDeposit = index % 2 == 0;
            return Container(
              margin: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? AppTheme.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: isDeposit
                          ? Colors.green.withOpacity(0.1)
                          : Colors.red.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      isDeposit ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isDeposit ? Colors.green : Colors.red,
                    ),
                  ),
                  SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isDeposit ? 'إيداع' : 'سحب',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                            color: isDark ? Colors.white : AppTheme.lightText,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          '2024-01-${15 - index}',
                          style: TextStyle(
                            fontFamily: 'Tajawal',
                            fontSize: 12,
                            color: isDark
                                ? Colors.white54
                                : Colors.black54,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    '${isDeposit ? '+' : '-'} ${(index + 1) * 5000} ر.ي',
                    style: TextStyle(
                      fontFamily: 'Changa',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isDeposit ? Colors.green : Colors.red,
                    ),
                  ),
                ],
              ),
            ).animate()
             .fadeIn(delay: (index * 100).ms)
             .slideX(begin: 0.2, end: 0);
          },
        ),
      ],
    );
  }

  void _navigateToService(String screen) {
    Widget? targetScreen;
    
    switch (screen) {
      case 'deposit':
        targetScreen = DepositScreen();
        break;
      case 'transfer':
        targetScreen = TransferScreen();
        break;
      case 'withdraw':
        targetScreen = WithdrawScreen();
        break;
      case 'transactions':
        targetScreen = TransactionsScreen();
        break;
      default:
        // للشاشات الأخرى نعرض رسالة
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('قريباً - $screen'),
            backgroundColor: AppTheme.goldPrimary,
          ),
        );
        return;
    }

    if (targetScreen != null) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => targetScreen!),
      );
    }
  }
}
