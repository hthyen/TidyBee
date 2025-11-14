import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/features/customer/model/customer.dart';

class CustomerService {
  final String baseUrl = dotenv.env['API_PROFILE_CUSTOMER'] ?? '';

  // Future - asynchronous get customer by id
  Future<Customer?> getCustomer(String token, String customerId) async {
    final url = Uri.parse('$baseUrl/${customerId}');

    final response = await http.get(
      url,
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
        "Accept": "application/json",
      },
    );

    if (response.statusCode == 200) {
      // Forces to use UTF-8 encoding to avoid issues with special characters (Vietnamese)
      final data = jsonDecode(utf8.decode(response.bodyBytes));
      final user = Customer.fromJson(data['data']);

      return user;
    } else {
      // Handle error
      // ignore: avoid_print
      print('Lỗi tải thông tin cá nhân: ${response.statusCode}');
      return null;
    }
  }
}
