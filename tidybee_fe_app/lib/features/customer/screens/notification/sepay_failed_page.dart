import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybee_fe_app/core/theme/app_colors.dart';
import 'package:tidybee_fe_app/features/customer/model/payment.dart';

class SepayFailedPage extends StatefulWidget {
  final Payment payment;

  const SepayFailedPage({super.key, required this.payment});

  @override
  State<SepayFailedPage> createState() => _SepayFailedPageState();
}

class _SepayFailedPageState extends State<SepayFailedPage> {
  String? _token;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  Future<void> _loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('accessToken');
    setState(() {
      _token = token;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Colors.white,
      // Appbar
      appBar: AppBar(
        backgroundColor: Colors.red,
        elevation: 0,
        title: const Text(
          "Thanh toán thất bại",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Fail Icon
            const Icon(Icons.cancel_outlined, color: Colors.red, size: 100),

            const SizedBox(height: 20),

            // Fail Message
            const Text(
              "Thanh toán thất bại!",
              style: TextStyle(
                color: Colors.red,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Đã có lỗi xảy ra trong quá trình thanh toán.\nVui lòng thử lại.",
              textAlign: TextAlign.center,
              style: const TextStyle(color: Colors.black54, fontSize: 16),
            ),

            const SizedBox(height: 40),

            // Button navigate to homepage
            OutlinedButton.icon(
              onPressed: () {
                context.go("/customer-homepage", extra: _token);
              },
              icon: const Icon(Icons.home),
              label: const Text("Về trang chủ"),
              style: OutlinedButton.styleFrom(
                minimumSize: const Size(double.infinity, 50),
                side: BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
