import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tidybee_fe_app/core/common_services/utils_method.dart';
import 'package:tidybee_fe_app/core/common_widgets/status.dart';
import 'package:tidybee_fe_app/features/customer/model/payment.dart';

class CashNotifiPage extends StatefulWidget {
  final Payment payment;
  const CashNotifiPage({super.key, required this.payment});

  @override
  State<CashNotifiPage> createState() => _CashNotifiPageState();
}

class _CashNotifiPageState extends State<CashNotifiPage> {
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

    final payment = widget.payment;

    final (methodText, methodIcon, methodColor) = mapPaymentMethod(
      payment.paymentMethod,
    );

    final (statusText, statusIcon, statusColor) = mapProcessStatus(
      payment.status ?? 0,
    );

    return Scaffold(
      // Appbar
      appBar: AppBar(
        title: const Text("Thông tin thanh toán"),
        backgroundColor: Colors.blue,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // id
            _buildRow("Mã đơn hàng:", payment.id ?? "-"),

            // transactionId
            _buildRow("Mã giao dịch:", payment.transactionId ?? "-"),

            // amount
            _buildRow("Số tiền:", UtilsMethod.formatMoney(payment.amount ?? 0)),

            // paymentMethodDisplayName
            _buildDetailRowWithIcon(
              'Phương thức: ',
              methodText,
              methodIcon,
              methodColor,
            ),

            // paymentStatusDisplayName
            _buildDetailRowWithIcon(
              'Trạng thái: ',
              statusText,
              statusIcon,
              statusColor,
            ),

            // createdAt
            _buildRow(
              'Thời gian thanh toán: ',
              UtilsMethod.formatDate(
                widget.payment.createdAt?.toIso8601String() ?? "",
              ),
            ),

            const SizedBox(height: 40),

            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  context.go("/customer-homepage", extra: _token);
                },
                icon: const Icon(Icons.home),
                label: const Text("Quay về trang chủ"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 12,
                  ),
                  textStyle: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget
  Widget _buildRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),

          Expanded(
            flex: 5,
            child: Text(value, style: const TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRowWithIcon(
    String title,
    String? value,
    IconData icon,
    Color color,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.black87,
              fontSize: 10,
              fontWeight: FontWeight.w500,
            ),
          ),
          Row(
            children: [
              Icon(icon, size: 14, color: color),

              const SizedBox(width: 4),

              Text(
                value ?? '-',
                style: TextStyle(
                  color: color,
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
