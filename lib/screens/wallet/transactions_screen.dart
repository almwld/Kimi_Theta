import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/wallet_provider.dart';
import '../../theme/app_theme.dart';

class TransactionsScreen extends StatelessWidget {
  const TransactionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final walletProvider = Provider.of<WalletProvider>(context);
    final transactions = walletProvider.transactions;

    return Scaffold(
      appBar: AppBar(title: const Text('المعاملات')),
      body: transactions.isEmpty
          ? const Center(child: Text('لا توجد معاملات'))
          : ListView.builder(
              itemCount: transactions.length,
              itemBuilder: (context, index) {
                final tx = transactions[index];
                return ListTile(
                  title: Text(tx.type),
                  subtitle: Text(tx.description ?? ''),
                  trailing: Text('${tx.amount} ${tx.currency}'),
                );
              },
            ),
    );
  }
}
