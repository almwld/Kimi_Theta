import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/order_provider.dart';

class MyOrdersScreen extends StatelessWidget {
  const MyOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orderProvider = Provider.of<OrderProvider>(context);
    final orders = orderProvider.orders;

    return Scaffold(
      appBar: AppBar(title: const Text('طلباتي')),
      body: orders.isEmpty
          ? const Center(child: Text('لا توجد طلبات'))
          : ListView.builder(
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return ListTile(
                  title: Text('طلب #${order.id.substring(0, 8)}'),
                  subtitle: Text(order.status),
                  trailing: Text('${order.total} ر.ي'),
                );
              },
            ),
    );
  }
}
