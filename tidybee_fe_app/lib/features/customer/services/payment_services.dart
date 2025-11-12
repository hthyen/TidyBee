import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/features/customer/model/payment.dart';
import 'package:tidybee_fe_app/features/customer/model/qr.dart';

class PaymentService {
  final String baseUrl = dotenv.env['API_PAYMENT'] ?? '';

  // Future - asynchronous createPayment
  Future<Payment?> createPayment({
    required String token,
    required double amount,
    required String bookingRequestId,
    required int paymentMethod,
  }) async {
    try {
      final url = Uri.parse('$baseUrl');

      final body = jsonEncode({
        "bookingRequestId": bookingRequestId,
        "amount": amount,
        "paymentMethod": paymentMethod,
      });

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'];
        return Payment.fromJson(data);
      } else {
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print(" Lỗi tạo giao dịch: $e");
      return null;
    }
  }

  // Future - asynchronous createPayment
  Future<QrPayment?> createQrCode({
    required String token,
    required String transactionId,
  }) async {
    try {
      final url = Uri.parse('$baseUrl/${transactionId}/sepay');

      final body = jsonEncode({"transactionId": transactionId});

      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: body,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'];
        return QrPayment.fromJson(data);
      } else {
        print("Response body: ${response.body}");
        return null;
      }
    } catch (e) {
      print(" Lỗi tạo giao dịch: $e");
      return null;
    }
  }

  // Future - asynchronous get payment by id
  Future<Payment?> getPaymentById(String token, String paymentId) async {
    final url = Uri.parse('$baseUrl/$paymentId');

    try {
      final response = await http.get(
        url,
        headers: {
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final data = jsonData['data'];
        return Payment.fromJson(data);
      } else {
        print('Lỗi tải thông tin thanh toán (status ${response.statusCode})');
        return null;
      }
    } catch (e) {
      print('Lỗi kết nối khi tải thông tin thanh toán: $e');
      return null;
    }
  }
}
