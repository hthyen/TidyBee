import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/features/customer/model/helper.dart';

class HelperServices {
  final String baseUrl = dotenv.env['API_BOOKING'] ?? '';

  // Future - asynchronous get eligible helpers
  Future<List<Helper>> getEligibleHelpers(
    String bookingId,
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/$bookingId/eligible-helpers?limit=50'),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        final helpersJson = data['data']['eligibleHelpers'] as List<dynamic>;

        final helpers = helpersJson
            .map((json) => Helper.fromJson(json))
            .toList();

        return helpers;
      } else {
        throw Exception('Lỗi tải nhân viên');
      }
    } catch (e) {
      print('Lỗi tải service: $e');
      throw Exception('Lỗi tải nhân viên');
    }
  }
}
