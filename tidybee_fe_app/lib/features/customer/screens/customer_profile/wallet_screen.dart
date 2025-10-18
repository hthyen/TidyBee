import 'package:flutter/material.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';

class WalletScreen extends StatelessWidget {
  const WalletScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const balance = 250000; // mock

    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text('Ví của tôi'),
        centerTitle: true,
        backgroundColor: AppColors.primary,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 40),

            // Title
            const Text('Số dư khả dụng', style: TextStyle(fontSize: 16)),

            const SizedBox(height: 10),

            // Money
            Text(
              '${balance.toStringAsFixed(0)} VNĐ',
              style: const TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),

            const SizedBox(height: 30),

            // Button add money
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                ),
                onPressed: () {},
                child: const Text('Nạp thêm tiền'),
              ),
            ),

            const SizedBox(height: 12),

            // Button to watch transaction history
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {},
                child: const Text('Xem lịch sử giao dịch'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
