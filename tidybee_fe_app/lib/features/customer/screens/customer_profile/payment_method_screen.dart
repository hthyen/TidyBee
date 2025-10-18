import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class PaymentMethodScreen extends StatelessWidget {
  const PaymentMethodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final methods = ['Thẻ tín dụng', 'Ví Momo', 'Chuyển khoản ngân hàng'];

    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text('Phương thức thanh toán'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),

      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: methods.length,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          // List payment method
          return ListTile(
            leading: const Icon(Icons.credit_card_outlined, color: Colors.blue),
            title: Text(methods[index]),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () {},
            ),
          );
        },
      ),

      // Button add payment method
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
    );
  }
}
