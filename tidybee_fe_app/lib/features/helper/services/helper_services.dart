import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';
import 'package:tidybee_fe_app/features/helper/model/helper_profile_summary_model.dart';

class HelperServices {
  final String baseUrl = dotenv.env['API_HELPER'] ?? '';
  final String helperProfileSummaryUrl =
      dotenv.env['API_HELPER_PROFILE_SUMMARY'] ?? '';

  // Retrieve helper information by userId
  Future<Helper?> getHelper(String token, String userId) async {
    try {
      final url = Uri.parse('$baseUrl/$userId');
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return Helper.fromJson(data['data']);
      } else {
        print('Lỗi tải thông tin helper: ${response.statusCode}');
        print('Body lỗi: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi exception khi tải thông tin helper: $e');
      return null;
    }
  }

  // Create or update Helper Profile
  Future<bool> updateHelper({
    required String token,
    required Map<String, dynamic> updateData,
  }) async {
    try {
      final url = Uri.parse(baseUrl);

      final response = await http.put(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200 || response.statusCode == 204) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

  Future<HelperProfileSummaryModel?> getHelperProfileSummary(
    String token,
    String userId,
  ) async {
    try {
      final url = Uri.parse('$helperProfileSummaryUrl/$userId/dashboard');
      final response = await http.get(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(utf8.decode(response.bodyBytes));
        return HelperProfileSummaryModel.fromJson(data);
      } else {
        print('Lỗi lấy profile summary: ${response.statusCode}');
        print('Body: ${response.body}');
        return null;
      }
    } catch (e) {
      print('Exception: $e');
      return null;
    }
  }
}
