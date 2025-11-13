import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tidybee_fe_app/features/customer/model/payment.dart';
import 'package:tidybee_fe_app/features/customer/services/payment_services.dart';

class PaymentQrPage extends StatefulWidget {
  final String qrCodeUrl;
  final Payment payment;
  final String token;

  const PaymentQrPage({
    super.key,
    required this.qrCodeUrl,
    required this.token,
    required this.payment,
  });

  @override
  State<PaymentQrPage> createState() => _PaymentQrPageState();
}

class _PaymentQrPageState extends State<PaymentQrPage> {
  final PaymentService _paymentService = PaymentService();

  //  Time variable
  Timer? _pollingTimer;
  int _elapsedSeconds = 0;
  final int _maxSeconds = 300;

  @override
  void initState() {
    super.initState();
    _startPolling();
    print(widget.qrCodeUrl);
  }

  // Create timer run every 5s, call API get payment in 5 min
  void _startPolling() {
    _pollingTimer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      _elapsedSeconds += 5;

      final payment = await _paymentService.getPaymentById(
        widget.token,
        widget.payment.id ?? "",
      );

      if (payment != null) {
        // Payment success
        if (payment.status == 3) {
          _stopPolling();

          if (mounted) {
            context.go('/payment-success', extra: payment);
          }
          return;
        }

        // Payment failed
      } else if (payment?.status == 4) {
        _stopPolling();
        if (mounted) {
          context.go('/payment-failed', extra: payment);
        }
        return;
      }

      // Waiting customer to payment in 5 min
      if (_elapsedSeconds >= _maxSeconds) {
        _stopPolling();

        if (mounted) {
          context.go(
            '/payment-failed',
            extra: {"payment": payment, "token": widget.token},
          );
        }
        return;
      }
    });
  }

  // Cancel calling API get payment
  void _stopPolling() {
    _pollingTimer?.cancel();
  }

  @override
  void dispose() {
    _stopPolling();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text('Mã QR thanh toán'),
        backgroundColor: Colors.green,
        centerTitle: true,
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image QR
            Image.network(
              widget.qrCodeUrl,
              width: 250,
              height: 250,
              fit: BoxFit.contain,
            ),

            const SizedBox(height: 20),

            // Title
            const Text(
              'Vui lòng quét mã QR để thanh toán đơn hàng của bạn.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),

            const SizedBox(height: 10),

            const Text(
              'Vui lòng hoàn tất thanh toán trong 5 phút.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.redAccent,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
