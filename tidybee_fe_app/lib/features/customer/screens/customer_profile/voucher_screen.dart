import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class VoucherScreen extends StatelessWidget {
  const VoucherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final vouchers = [
      {'code': 'DISCOUNT10', 'desc': 'Giảm 10% đơn hàng'},
      {'code': 'FREESHIP', 'desc': 'Miễn phí vận chuyển'},
    ];

    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text('Mã giảm giá của tôi'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          final voucher = vouchers[index];

          // List voucher
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(
                Icons.local_offer_outlined,
                color: Colors.orange,
              ),
              title: Text(voucher['code']!),
              subtitle: Text(voucher['desc']!),
              trailing: TextButton(onPressed: () {}, child: const Text('Dùng')),
            ),
          );
        },
      ),
    );
  }
}
