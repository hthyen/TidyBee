import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:tidybee_fe_app/features/helper/model/helper.dart';

class HelperServices {
  final String helperProfileUrl = dotenv.env['API_HELPER_BY_ID'] ?? '';

  /// Retrieve helper information by userId
  Future<Helper?> getHelper(String token, String userId) async {
    try {
      final url = Uri.parse('$helperProfileUrl/$userId');
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

  /// Create or update Helper Profile
  Future<bool> updateHelper(
    String token,
    Map<String, dynamic> updateData,
  ) async {
    try {
      final url = Uri.parse(helperProfileUrl);
      final response = await http.post(
        url,
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        print('Cập nhật/đăng ký helper profile thành công');
        return true;
      } else {
        print('Lỗi cập nhật helper profile: ${response.statusCode}');
        print('Body lỗi: ${response.body}');
        return false;
      }
    } catch (e) {
      print('Lỗi exception khi cập nhật helper: $e');
      return false;
    }
  }
}
