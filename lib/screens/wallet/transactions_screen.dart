// شاشة المعاملات
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/custom_app_bar.dart';

class TransactionsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> _transactions = [
    {
      'type': 'deposit',
      'title': 'إيداع',
      'amount': 50000,
      'currency': 'YER',
      'date': '2024-01-20',
      'time': '14:30',
      'status': 'completed',
    },
    {
      'type': 'withdraw',
      'title': 'سحب',
      'amount': 25000,
      'currency': 'YER',
      'date': '2024-01-19',
      'time': '10:15',
      'status': 'completed',
    },
    {
      'type': 'transfer',
      'title': 'تحويل',
      'amount': 15000,
      'currency': 'YER',
      'date': '2024-01-18',
      'time': '16:45',
      'status': 'completed',
    },
    {
      'type': 'payment',
      'title': 'دفع فاتورة كهرباء',
      'amount': 5000,
      'currency': 'YER',
      'date': '2024-01-17',
      'time': '09:00',
      'status': 'completed',
    },
    {
      'type': 'deposit',
      'title': 'إيداع',
      'amount': 100000,
      'currency': 'YER',
      'date': '2024-01-15',
      'time': '11:20',
      'status': 'completed',
    },
    {
      'type': 'transfer',
      'title': 'استلام تحويل',
      'amount': 30000,
      'currency': 'YER',
      'date': '2024-01-14',
      'time': '13:00',
      'status': 'completed',
    },
  ];

  IconData _getIcon(String type) {
    switch (type) {
      case 'deposit':
        return Icons.arrow_downward;
      case 'withdraw':
        return Icons.arrow_upward;
      case 'transfer':
        return Icons.swap_horiz;
      case 'payment':
        return Icons.payment;
      default:
        return Icons.receipt;
    }
  }

  Color _getIconColor(String type) {
    switch (type) {
      case 'deposit':
        return Colors.green;
      case 'withdraw':
        return Colors.red;
      case 'transfer':
        return Colors.blue;
      case 'payment':
        return Colors.orange;
      default:
        return Colors.grey;
    }
  }

  bool _isIncoming(String type) {
    return type == 'deposit' || type == 'transfer';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return DefaultTabController(
      length: 4,
      child: Scaffold(
        backgroundColor: isDark ? AppTheme.darkBg : AppTheme.lightBg,
        appBar: CustomAppBar(
          title: 'المعاملات',
          bottom: TabBar(
            isScrollable: true,
            labelColor: AppTheme.goldPrimary,
            unselectedLabelColor: isDark ? Colors.white60 : Colors.black54,
            indicatorColor: AppTheme.goldPrimary,
            tabs: [
              Tab(text: 'الكل'),
              Tab(text: 'الإيداعات'),
              Tab(text: 'السحوبات'),
              Tab(text: 'التحويلات'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildTransactionsList(_transactions),
            _buildTransactionsList(_transactions.where((t) => t['type'] == 'deposit').toList()),
            _buildTransactionsList(_transactions.where((t) => t['type'] == 'withdraw').toList()),
            _buildTransactionsList(_transactions.where((t) => t['type'] == 'transfer').toList()),
          ],
        ),
      ),
    );
  }

  Widget _buildTransactionsList(List<Map<String, dynamic>> transactions) {
    if (transactions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.receipt_long_outlined,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'لا توجد معاملات',
              style: TextStyle(
                fontFamily: 'Tajawal',
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: transactions.length,
      itemBuilder: (context, index) {
        final transaction = transactions[index];
        return _buildTransactionCard(transaction, index);
      },
    );
  }

  Widget _buildTransactionCard(Map<String, dynamic> transaction, int index) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final isIncoming = _isIncoming(transaction['type']);

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppTheme.darkSurface : Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getIconColor(transaction['type']).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              _getIcon(transaction['type']),
              color: _getIconColor(transaction['type']),
            ),
          ),
          SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  transaction['title'],
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppTheme.lightText,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  '${transaction['date']} - ${transaction['time']}',
                  style: TextStyle(
                    fontFamily: 'Tajawal',
                    fontSize: 12,
                    color: isDark ? Colors.white54 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${isIncoming ? '+' : '-'} ${transaction['amount'].toStringAsFixed(0)}',
                style: TextStyle(
                  fontFamily: 'Changa',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: isIncoming ? Colors.green : Colors.red,
                ),
              ),
              SizedBox(height: 4),
              Text(
                transaction['currency'],
                style: TextStyle(
                  fontFamily: 'Tajawal',
                  fontSize: 12,
                  color: isDark ? Colors.white54 : Colors.black54,
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate()
     .fadeIn(delay: (index * 100).ms)
     .slideX(begin: 0.2, end: 0);
  }
}
